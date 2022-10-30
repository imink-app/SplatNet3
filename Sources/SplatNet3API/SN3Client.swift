import Foundation
import InkMoya
import SplatNet3

public class SN3Client {
    var session: IMSessionType = IMSession.shared

    private var webServiceToken: String?
    private var bulletTokens: BulletTokens?

    private let makeBulletNumberOfRetry: Int
    private var currentMakeBulletRetrys = 0

    public init(webVersion: String, bulletTokens: BulletTokens? = nil, makeBulletNumberOfRetry: Int = 2, session: IMSessionType? = nil) {
        var plugins = [PluginType]()

        if let session = session {
            self.session = session
        }

        if let bulletTokens = bulletTokens {
            self.bulletTokens = bulletTokens
            plugins.append(BulletTokenPlugin(bulletToken: bulletTokens.bulletToken))
        }

        self.session.plugins = plugins + [WebVersionPlugin(webVersion: webVersion)]

        self.makeBulletNumberOfRetry = makeBulletNumberOfRetry
    }

    public func makeBullet(webServiceToken: String? = nil) async throws {
        if webServiceToken == nil, self.webServiceToken == nil {
            throw Error.webServiceTokenNoExist
        }

        if let webServiceToken = webServiceToken {
            self.webServiceToken = webServiceToken
        }

        let webServiceToken = self.webServiceToken!

        let (data, res) = try await session.request(api: SN3API.bulletTokens(webServiceToken: webServiceToken))
        let statusCode = res.httpURLResponse.statusCode
        if statusCode == 401 {
            throw Error.invalidWebServiceToken
        } else if statusCode != 200, statusCode != 201 {
            throw Error.responseError(code: statusCode, url: res.httpURLResponse.url, body: String(data: data, encoding: .utf8))
        }

        let decoder = JSONDecoder()
        bulletTokens = try decoder.decode(BulletTokens.self, from: data)

        var plugins = session.plugins
        plugins.removeAll { $0 is BulletTokenPlugin }
        session.plugins = plugins + [BulletTokenPlugin(bulletToken: bulletTokens!.bulletToken)]
    }

    public func getBulletTokens() -> BulletTokens? {
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
        do {
            return try await requestGraphQL(query)
        } catch Error.invalidBulletToken {
            // If the request still fails after re-generating bullet_token several times, 
            // the invalidWebServiceToken is returned and the user is asked to pass in a new WebServiceToken.
            if currentMakeBulletRetrys >= makeBulletNumberOfRetry {
                throw Error.invalidWebServiceToken
            }
            currentMakeBulletRetrys += 1

            try await makeBullet()
            return try await graphQL(query)
        }
    }

    private func requestGraphQL<T>(_ query: SN3PersistedQuery) async throws -> SN3Response<T> where T : Decodable {
        let (data, res) = try await session.request(api: SN3API.graphQL(query))
        let statusCode = res.httpURLResponse.statusCode
        if statusCode == 401 {
            throw Error.invalidBulletToken
        } else {
            currentMakeBulletRetrys = 0
        }
        
        if statusCode != 200 {
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
        case webServiceTokenNoExist
        case invalidWebServiceToken
        case invalidBulletToken
        case responseError(code: Int, url: URL? = nil, body: String? = nil)
    }
}