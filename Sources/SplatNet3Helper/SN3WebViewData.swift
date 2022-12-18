import Foundation

#if canImport(FoundationNetworking)
    import FoundationNetworking
#endif

public struct SN3WebViewData: Codable, Equatable {
    public let version: String
    public let graphql: GraphQL

    public struct GraphQL: Codable, Equatable {
        public let hashMap: [String: String]
    }
}
