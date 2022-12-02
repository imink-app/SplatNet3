import Foundation
import InkMoya
import SplatNet3Helper

#if canImport(FoundationNetworking)
    import FoundationNetworking
#endif

public struct GraphQLPlugin: PluginType {
    let graphQLMap: GraphQLMap

    public func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        var request = request
        if let target = target as? SN3API,

            case .graphQL(let query) = target,
            let hash = graphQLMap[query.graphQLName],

            case .jsonData(let body) = target.data,
            let oldBody = body as? GraphQLRequestBody {
            
            let body = GraphQLRequestBody(
                        variables: oldBody.variables,
                        extensions: .init(
                            persistedQuery: .init(
                                version: oldBody.extensions.persistedQuery.version,
                                sha256Hash: hash
                            )
                        )
                    )
            request.httpBody = body.toJSONData()
        }
        return request
    }
}