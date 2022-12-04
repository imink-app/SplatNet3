// https://github.com/samuelthomas2774/nxapi/discussions/11
// https://github.com/samuelthomas2774/nxapi/blob/main/src/api/splatnet3.ts
// https://github.com/samuelthomas2774/nxapi/blob/main/src/api/splatnet3-types.ts

import Foundation
import InkMoya
import SplatNet3

public struct EmptyParameter: Encodable {}

public protocol SN3PersistedQuery: TargetType {
    associatedtype Parameter: Encodable = EmptyParameter
    associatedtype TopLevelResponse: Decodable
    associatedtype Response: Decodable
    
    var parameter: Parameter { get }
    
    static var name: String { get }
    static var responseKeyPath: KeyPath<TopLevelResponse, Response> { get }
}

extension SN3PersistedQuery where Parameter == EmptyParameter {
    public var parameter: EmptyParameter { EmptyParameter() }
}

extension SN3PersistedQuery {
    
    public var baseURL: URL { URL(string: "https://api.lp1.av5ja.srv.nintendo.net")! }
    public var path: String { "/api/graphql" }
    public var method: RequestMethod { .post }
    public var querys: [(String, String?)]? { nil }
    
    public var headers: [String : String]? {
        [
            "Accept-Language": "en-GB"
        ]
    }
    
    public var data: MediaType? {
        return .jsonData(
            GraphQLRequestBody(
                variables: parameter,
                extensions: .init(
                    persistedQuery: .init(
                        version: 1,
                        sha256Hash: "Replace with hash in GraphQLPlugin.swift"
                    )
                )
            )
        )
    }
    
    public var sampleData: Data {
        let path: String
        let name = type(of: self).name
        if let query = self as? VSHistoryDetailQuery,
            query.parameter.vsResultId == "disconnection" {
            path = "/SampleData/\(name)Disconnection.json"
        } else {
            path = "/SampleData/\(name).json"
        }
        let url = Bundle.module.url(forResource: path, withExtension: nil)!
        return try! Data(contentsOf: url)
    }
}

// MARK: - LatestBattleHistoriesQuery
    
public struct LatestBattleHistoriesQuery: SN3PersistedQuery {
    public static let name = "LatestBattleHistoriesQuery"
    public static let responseKeyPath = \SN3Response<SN3LatestBattleHistoriesData>.data.latestBattleHistories
}

extension SN3PersistedQuery where Self == LatestBattleHistoriesQuery {
    public static var latestBattleHistories: LatestBattleHistoriesQuery { .init() }
}

// MARK: RegularBattleHistoriesQuery

public struct RegularBattleHistoriesQuery: SN3PersistedQuery {
    public static let name = "RegularBattleHistoriesQuery"
    public static let responseKeyPath = \SN3Response<SN3RegularBattleHistoriesData>.data.regularBattleHistories
}

extension SN3PersistedQuery where Self == RegularBattleHistoriesQuery {
    public static var regularBattleHistories: RegularBattleHistoriesQuery { .init() }
}

// MARK: BankaraBattleHistoriesQuery

public struct BankaraBattleHistoriesQuery: SN3PersistedQuery {
    public static let name = "BankaraBattleHistoriesQuery"
    public static let responseKeyPath = \SN3Response<SN3BankaraBattleHistoriesData>.data.bankaraBattleHistories
}

extension SN3PersistedQuery where Self == BankaraBattleHistoriesQuery {
    public static var bankaraBattleHistories: BankaraBattleHistoriesQuery { .init() }
}

// MARK: PrivateBattleHistoriesQuery

public struct PrivateBattleHistoriesQuery: SN3PersistedQuery {
    public static let name = "PrivateBattleHistoriesQuery"
    public static let responseKeyPath = \SN3Response<SN3PrivateBattleHistoriesData>.data.privateBattleHistories
}

extension SN3PersistedQuery where Self == PrivateBattleHistoriesQuery {
    public static var privateBattleHistories: PrivateBattleHistoriesQuery { .init() }
}

// MARK: CoopHistoryQuery

public struct CoopHistoryQuery: SN3PersistedQuery {
    public static let name = "CoopHistoryQuery"
    public static let responseKeyPath = \SN3Response<SN3CoopHistoryData>.data.coopResult
}

extension SN3PersistedQuery where Self == CoopHistoryQuery {
    public static var coopHistory: CoopHistoryQuery { .init() }
}

// MARK: VSHistoryDetailQuery

public struct VSHistoryDetailQuery: SN3PersistedQuery {
    public static let name = "VsHistoryDetailQuery"
    public static let responseKeyPath = \SN3Response<SN3VSHistoryDetailData>.data.vsHistoryDetail
    
    public struct Parameter: Encodable {
        public let vsResultId: String
    }
    
    public var parameter: Parameter
}

extension SN3PersistedQuery where Self == VSHistoryDetailQuery {
    public static func vsHistoryDetail(id: String) -> VSHistoryDetailQuery {
        .init(parameter: .init(vsResultId: id))
    }
}

// MARK: CoopHistoryDetailQuery

public struct CoopHistoryDetailQuery: SN3PersistedQuery {
    public static let name = "CoopHistoryDetailQuery"
    public static let responseKeyPath = \SN3Response<SN3CoopHistoryDetailData>.data.coopHistoryDetail
    
    public struct Parameter: Encodable {
        public let coopHistoryDetailId: String
    }
    
    public var parameter: Parameter
}

extension SN3PersistedQuery where Self == CoopHistoryDetailQuery {
    public static func coopHistoryDetail(id: String) -> CoopHistoryDetailQuery {
        .init(parameter: .init(coopHistoryDetailId: id))
    }
}
