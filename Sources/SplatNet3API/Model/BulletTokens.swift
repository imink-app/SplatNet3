public struct BulletTokens: Decodable {
    public let bulletToken: String
    public let lang: String

    public init(bulletToken: String, lang: String) {
        self.bulletToken = bulletToken
        self.lang = lang
    }
}