import Foundation
import InkMoya
import SplatNet3

public class SN3Client {
    var session: IMSessionType = IMSession.shared
    private var webServiceToken: String?
    private var bulletTokens: SN3BulletTokens?

    public init(webVersion: String, session: IMSessionType? = nil) {
        if let session = session {
            self.session = session
        }

        self.session.plugins = [WebVersionPlugin(webVersion: webVersion)]
    }

    public func login(webServiceToken: String) async throws {
        let (data, res) = try await session.request(api: SN3API.bulletTokens(webServiceToken: webServiceToken))
        let statusCode = res.httpURLResponse.statusCode
        if statusCode == 401 {
            throw Error.invalidWebServiceToken
        } else if statusCode != 200, statusCode != 201 {
            throw Error.responseError(code: statusCode, url: res.httpURLResponse.url, body: String(data: data, encoding: .utf8))
        }

        let decoder = JSONDecoder()
        bulletTokens = try decoder.decode(SN3BulletTokens.self, from: data)

        var plugins = session.plugins
        plugins.removeAll { $0 is BulletTokenPlugin }
        session.plugins = plugins + [BulletTokenPlugin(bulletToken: bulletTokens!.bulletToken)]

        self.webServiceToken = webServiceToken
    }

    public func getBulletTokens() -> SN3BulletTokens? {
        bulletTokens
    }

    public func getLatestBattleHistories() async throws -> BattleHistories {
        let response: SN3Response<SN3LatestBattleHistoriesData> = try await graphQL(.latestBattleHistories)
        return response.data.latestBattleHistories
    }

    public func getRegularBattleHistories() async throws -> BattleHistories {
        let response: SN3Response<SN3RegularBattleHistoriesData> = try await graphQL(.regularBattleHistories)
        return response.data.regularBattleHistories
    }

    public func getBankaraBattleHistories() async throws -> BattleHistories {
        let response: SN3Response<SN3BankaraBattleHistoriesData> = try await graphQL(.bankaraBattleHistories)
        return response.data.bankaraBattleHistories
    }

    public func getPrivateBattleHistories() async throws -> BattleHistories {
        let response: SN3Response<SN3PrivateBattleHistoriesData> = try await graphQL(.privateBattleHistories)
        return response.data.privateBattleHistories
    }

    public func getVSHistoryDetail(vsResultId: String) async throws -> VSHistoryDetail {
        let response: SN3Response<SN3VSHistoryDetailData> = try await graphQL(.vsHistoryDetail(vsResultId: vsResultId))
        return response.data.vsHistoryDetail
    }

    public func getCoopHistory() async throws -> CoopHistory {
        let response: SN3Response<SN3CoopHistoryData> = try await graphQL(.coopHistory)
        return response.data.coopResult
    }

    public func getCoopHistoryDetail(coopHistoryDetailId: String) async throws -> CoopHistoryDetail {
        let response: SN3Response<SN3CoopHistoryDetailData> = try await graphQL(.coopHistoryDetail(coopHistoryDetailId: coopHistoryDetailId))
        return response.data.coopHistoryDetail
    }
}

extension SN3Client {
    private func graphQL<T>(_ query: SN3PersistedQuery) async throws -> SN3Response<T> where T : Decodable {
        try await graphQL2(query)
    }

    private func graphQL2<T>(_ query: SN3PersistedQuery) async throws -> SN3Response<T> where T : Decodable {
        let (data, res) = try await session.request(api: SN3API.graphQL(query))
        let statusCode = res.httpURLResponse.statusCode
        if statusCode == 401 {
            throw Error.invalidBulletToken
        } else if statusCode != 200 {
            throw Error.responseError(code: res.httpURLResponse.statusCode, url: res.httpURLResponse.url, body: String(data: data, encoding: .utf8))
        }

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let response = try decoder.decode(SN3Response<T>.self, from: data)
        return response
    }
}

extension SN3Client {
    enum Error: Swift.Error {
        case invalidWebServiceToken
        case invalidBulletToken
        case responseError(code: Int, url: URL? = nil, body: String? = nil)
    }
}