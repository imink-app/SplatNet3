import Foundation
import InkMoya
import SwiftSoup
import SplatNet3API

#if canImport(FoundationNetworking)
    import FoundationNetworking
#endif

public struct SN3Helper {
    public static var session: IMSessionType = IMSession.shared

    public static func getWebViewVersion() async throws -> String {
        var (data, res) = try await session.request(api: SN3API.web())
        if res.httpURLResponse.statusCode != 200 {
            throw Error.requestHtmlError(url: res.url)
        }

        guard let webHtml = String(data: data, encoding: .utf8) else {
            throw Error.requestHtmlError(url: res.url)
        }

        let doc = try SwiftSoup.parse(webHtml)
        let s = try doc.select("script[src*='static']")

        guard let mainJsPath = try? s.first()?.attr("src") else {
            throw Error.parseDataError(url:res.url)
        }

        (data, res) = try await session.request(api: SN3API.web(path: mainJsPath))
        if res.httpURLResponse.statusCode != 200 {
            throw Error.requestHtmlError(url: res.url)
        }

        guard let jsContent = String(data: data, encoding: .utf8) else {
            throw Error.parseDataError(url: res.url)
        }

        guard
            let match = try? NSRegularExpression(
                pattern: #"=\"(?<revision>[0-9a-f]{40}).*revision_info_not_set.*=\"(?<version>\d+\.\d+\.\d+)"#,
                options: [])
                .firstMatch(in: jsContent, range: NSRange(location: 0, length: jsContent.count))
        else {
            throw Error.parseDataError(url: res.url)
        }

        let revisionRange = match.range(withName: "revision")
        let versionRange = match.range(withName: "version")

        if revisionRange.location == NSNotFound ||
            versionRange.location == NSNotFound {
            throw Error.parseDataError(url: res.url)
        }

        let revision = NSString(string: jsContent).substring(with: revisionRange)
        let version = NSString(string: jsContent).substring(with: versionRange)

        return "\(version)-\(revision[revision.startIndex..<revision.index(revision.startIndex, offsetBy: 8)])"
    }
}

public extension SN3Helper {
    enum Error: Swift.Error {
        case requestHtmlError(url: URL? = nil)
        case parseDataError(url: URL? = nil)
    }
}