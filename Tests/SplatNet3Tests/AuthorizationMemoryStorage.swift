import SplatNet3API

class AuthorizationMemoryStorage: SN3AuthorizationStorage {
    private var bulletTokens: BulletTokens?

    func getBulletTokens() async throws -> BulletTokens? {
        bulletTokens
    }

    func setBulletTokens(_ newValue: BulletTokens) async throws {
        bulletTokens = newValue
    }
}