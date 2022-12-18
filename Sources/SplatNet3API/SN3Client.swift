import Foundation
import InkMoya
import SplatNet3Helper

public class SN3Client {
    private var session: IMSessionType = IMSession.shared
    private let internalAuthorizationStorage: SN3AuthorizationStorage

    private let webVersion: String
    private let graphQLHashMap: [String: String]
    private let gameServiceToken: String

    public var authorizationStorage: SN3AuthorizationStorage {
        internalAuthorizationStorage
    }

    public init(webVersion: String, graphQLHashMap: [String: String], gameServiceToken: String, authorizationStorage: SN3AuthorizationStorage = AuthorizationMemoryStorage(), session: IMSessionType? = nil) async throws {
        self.webVersion = webVersion
        self.graphQLHashMap = graphQLHashMap
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
    
    func graphQL<T: SN3PersistedQuery>(_ query: T)  async throws -> T.Response {
        do {
            return try await requestGraphQL(query)
        } catch Error.invalidBulletToken {
            try await makeBullet()
            return try await graphQL(query)
        }
    }
}

extension SN3Client {
    private func makeBullet() async throws {
        let (data, res) = try await session.request(api: SN3API.bulletTokens(gameServiceToken: gameServiceToken))
        switch res.statusCode {
        case 200, 201:
            break // OK
        case 401:
            throw Error.invalidGameServiceToken
        case let code:
            throw Error.responseError(code: code, url: res.url, body: String(data: data, encoding: .utf8))
        }

        let bulletTokens = try JSONDecoder().decode(BulletTokens.self, from: data)

        try await internalAuthorizationStorage.setBulletTokens(bulletTokens)
        try await configureSession()
    }
}

extension SN3Client {
    
    private func requestGraphQL<T: SN3PersistedQuery>(_ query: T)  async throws -> T.Response {
        let (data, res) = try await session.request(api: query)
        let statusCode = res.statusCode
        if statusCode == 401 {
            throw Error.invalidBulletToken
        }
        
        if statusCode != 200 {
            throw Error.responseError(code: res.statusCode, url: res.url, body: String(data: data, encoding: .utf8))
        }

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let response = try decoder.decode(T.TopLevelResponse.self, from: data)
        return response[keyPath: T.responseKeyPath]
    }
}

extension SN3Client {
    private func configureSession() async throws {
        var plugins = [PluginType]()

        plugins.append(WebVersionPlugin(webVersion: webVersion))
        plugins.append(GraphQLPlugin(graphQLHashMap: graphQLHashMap))

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
