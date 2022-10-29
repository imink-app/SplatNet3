import Foundation
import InkMoya
#if canImport(FoundationNetworking)
    import FoundationNetworking
#endif

public struct BulletTokenPlugin: PluginType {
    let bulletToken: String

    public func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        var request = request
        request.addValue("Bearer \(bulletToken)", forHTTPHeaderField: "Authorization")
        return request
    }
}