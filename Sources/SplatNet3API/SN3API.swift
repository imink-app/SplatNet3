import Foundation
import InkMoya
import SplatNet3

public enum SN3API {
    case web(path: String = "/")
    case bulletTokens(gameServiceToken: String)
    case graphQL(_ query: SN3PersistedQuery)
}

extension SN3API: TargetType {
    public var baseURL: URL { URL(string: "https://api.lp1.av5ja.srv.nintendo.net")! }
    
    public var path: String {
        switch self {
        case .web(let path):
            return path
        case .bulletTokens:
            return "/api/bullet_tokens"
        case .graphQL:
            return "/api/graphql"
        }
    }
    
    public var method: RequestMethod {
        switch self {
        case .web:
            return .get
        default:
            return .post
        }
    }
    
    public var headers: [String : String]? {
        switch self {
        case .web:
            return nil
        case .bulletTokens(let gameServiceToken):
            return [
                "Accept-Language": "en-GB",
                "X-NACountry": "US",
                "Cookie": "_gtoken=\(gameServiceToken);"
            ]
        case .graphQL:
            return [
                "Accept-Language": "en-GB",
            ]
        }
    }
    
    public var querys: [(String, String?)]? { nil }
    
    public var data: MediaType? {
        switch self {
        case .web, .bulletTokens:
            return nil
        case .graphQL(let query):
            var variables = [String: String]()
            switch query {
            case .vsHistoryDetail(let vsResultId):
                variables["vsResultId"] = vsResultId
            case .coopHistoryDetail(let coopHistoryDetailId):
                variables["coopHistoryDetailId"] = coopHistoryDetailId
            default:
                break
            }
            
            return .jsonData(
                GraphQLRequestBody(
                    variables: variables,
                    extensions: .init(
                        persistedQuery: .init(
                            version: 1,
                            sha256Hash: "Replace with hash in GraphQLPlugin.swift"
                        )
                    )
                )
            )
        }
    }
    
    public var sampleData: Data {
        let path = "/SampleData/\(sampleDataFileName)"
        let url = Bundle.module.url(forResource: path, withExtension: nil)!
        return try! Data(contentsOf: url)
    }
}

extension SN3API {
    var sampleDataFileName: String {
        switch self {
        case .web(let path):
            if path.hasPrefix("/static/js/main.") {
                return "main.js"
            } else {
                return "api.lp1.av5ja.srv.nintendo.net.html"
            }
        case .bulletTokens:
            return "bulletTokens.json"
        case .graphQL(let query):
            switch query {
            case .latestBattleHistories:
                return "latestBattleHistories.json"
            case .regularBattleHistories:
                return "regularBattleHistories.json"
            case .bankaraBattleHistories:
                return "bankaraBattleHistories.json"
            case .privateBattleHistories:
                return "privateBattleHistories.json"
            case .vsHistoryDetail(let vsResultId):
                if vsResultId == "disconnection" {
                    return "vsHistoreDetail_disconnection.json"
                } else {
                    return "vsHistoryDetail.json"
                }
            case .coopHistory:
                return "coopHistory.json"
            case .coopHistoryDetail:
                return "coopHistoryDetail.json"
            }
        }
    }
}
