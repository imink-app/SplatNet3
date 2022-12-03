import Foundation
import InkMoya
import SplatNet3Helper

#if canImport(FoundationNetworking)
    import FoundationNetworking
#endif

public struct GraphQLPlugin: PluginType {
    
    let graphQLHashMap: [String: String]
    
    public func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        var request = request
        guard let target = target as? any SN3PersistedQuery,
              let hash = graphQLHashMap[type(of: target).name],
              var body = target.data?.jsonObj as? GraphQLRequestBody else {
            return request
        }
        body.extensions.persistedQuery.sha256Hash = hash
        request.httpBody = body.toJSONData()
        return request
    }
}

private extension MediaType {
    
    var jsonObj: Encodable? {
        switch self {
        case .jsonData(let data):
            return data
        default:
            return nil
        }
    }
}
