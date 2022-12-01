import Foundation
import InkMoya

#if canImport(FoundationNetworking)
    import FoundationNetworking
#endif

public struct SN3Helper {
    internal static var session: IMSessionType = IMSession.shared
}

public extension SN3Helper {
    enum Error: Swift.Error {
        case requestHtmlError(url: URL? = nil)
        case parseDataError(url: URL? = nil)
    }
}