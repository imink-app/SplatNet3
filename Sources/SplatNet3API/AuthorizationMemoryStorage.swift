public class AuthorizationMemoryStorage: SN3AuthorizationStorage {
    private var bulletTokens: BulletTokens?

    public init() { }

    public func getBulletTokens() async throws -> BulletTokens? {
        bulletTokens
    }

    public func setBulletTokens(_ newValue: BulletTokens) async throws {
        bulletTokens = newValue
    }
}