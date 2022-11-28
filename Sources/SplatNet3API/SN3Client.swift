import Foundation
import InkMoya
import SplatNet3

public class SN3Client {
    private var session: IMSessionType = IMSession.shared
    private let internalAuthorizationStorage: SN3AuthorizationStorage

    private let webVersion: String
    private let gameServiceToken: String

    public var authorizationStorage: SN3AuthorizationStorage {
        internalAuthorizationStorage
    }

    public init(webVersion: String, gameServiceToken: String, authorizationStorage: SN3AuthorizationStorage = AuthorizationMemoryStorage(), session: IMSessionType? = nil) async throws {
        self.webVersion = webVersion
        self.gameServiceToken = gameServiceToken
        self.internalAuthorizationStorage = authorizationStorage

        if let session = session {
            self.session = session
        }

        try await configureSession()

        if try await authorizationStorage.getBulletTokens() == nil {
            try await makeBullet()
        }
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
    private func makeBullet() async throws {
        let (data, res) = try await session.request(api: SN3API.bulletTokens(gameServiceToken: gameServiceToken))
        let statusCode = res.httpURLResponse.statusCode
        if 200...201 ~= statusCode {
        } else if 401 == statusCode {
            throw Error.invalidGameServiceToken
        } else {
            throw Error.responseError(code: statusCode, url: res.httpURLResponse.url, body: String(data: data, encoding: .utf8))
        }

        let decoder = JSONDecoder()
        let bulletTokens = try decoder.decode(BulletTokens.self, from: data)

        try await internalAuthorizationStorage.setBulletTokens(bulletTokens)
        try await configureSession()
    }
}

extension SN3Client {
    private func graphQL<T>(_ query: SN3PersistedQuery) async throws -> SN3Response<T> where T : Decodable {
        do {
            return try await requestGraphQL(query)
        } catch Error.invalidBulletToken {
            try await makeBullet()
            return try await graphQL(query)
        }
    }

    private func requestGraphQL<T>(_ query: SN3PersistedQuery) async throws -> SN3Response<T> where T : Decodable {
        let (data, res) = try await session.request(api: SN3API.graphQL(query))
        let statusCode = res.httpURLResponse.statusCode
        if statusCode == 401 {
            throw Error.invalidBulletToken
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
    private func configureSession() async throws {
        var plugins = [PluginType]()

        plugins.append(WebVersionPlugin(webVersion: webVersion))

        if let bulletTokens = try await internalAuthorizationStorage.getBulletTokens() {
            plugins.append(BulletTokenPlugin(bulletToken: bulletTokens.bulletToken))
        }

        session.plugins = plugins
    }
}

public extension SN3Client {
    enum Error: Swift.Error {
        case invalidGameServiceToken
        case invalidBulletToken
        case responseError(code: Int, url: URL? = nil, body: String? = nil)
    }
}