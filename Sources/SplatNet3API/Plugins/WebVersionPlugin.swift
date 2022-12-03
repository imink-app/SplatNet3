import Foundation
import InkMoya
#if canImport(FoundationNetworking)
    import FoundationNetworking
#endif

public struct WebVersionPlugin: PluginType {
    let webVersion: String

    public func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        var request = request
        request.addValue(webVersion, forHTTPHeaderField: "X-Web-View-Ver")
        return request
    }
}
