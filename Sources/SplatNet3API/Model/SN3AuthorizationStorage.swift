public protocol SN3AuthorizationStorage {
    func getBulletTokens() async throws -> BulletTokens?
    func setBulletTokens(_ newValue: BulletTokens) async throws
}