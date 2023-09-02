import Foundation
import InkMoya
import SwiftSoup

#if canImport(FoundationNetworking)
    import FoundationNetworking
#endif

public struct SN3Helper {
    
    public static func getWebViewData() async throws -> SN3WebViewData {
        let webviewURL = URL(string: "https://api.lp1.av5ja.srv.nintendo.net")!

        var req = URLRequest(url: webviewURL)
        var (data, res) = try await IMSession.shared.data(for: req)
        if (res as? HTTPURLResponse)?.statusCode != 200 {
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

        req = URLRequest(url: webviewURL.appendingPathComponent(mainJsPath))
        (data, res) = try await IMSession.shared.data(for: req)
        if (res as? HTTPURLResponse)?.statusCode != 200 {
            throw Error.requestHtmlError(url: res.url)
        }

        guard let jsContent = String(data: data, encoding: .utf8) else {
            throw Error.parseDataError(url: res.url)
        }

        let sn3Data = SN3WebViewData(
            version: try parseWebViewVersion(jsContent: jsContent),
            graphql: SN3WebViewData.GraphQL(hashMap: try parseGraphQLHashMap(jsContent: jsContent))
        )

        return sn3Data
    }

    
    private static func parseWebViewVersion(jsContent: String) throws -> String {
        guard let match = versionRegex.firstMatch(in: jsContent, range: NSRange(location: 0, length: jsContent.count)) else {
            throw Error.parseDataError()
        }

        let revisionRange = match.range(withName: "revision")
        let versionRange = match.range(withName: "version")

        if revisionRange.location == NSNotFound ||
            versionRange.location == NSNotFound {
            throw Error.parseDataError()
        }

        let revision = NSString(string: jsContent).substring(with: revisionRange)
        let version = NSString(string: jsContent).substring(with: versionRange)

        return "\(version)-\(revision[revision.startIndex..<revision.index(revision.startIndex, offsetBy: 8)])"
    }

    private static func parseGraphQLHashMap(jsContent: String) throws -> [String: String] {
        let matchs = hashRegex.matches(in: jsContent, range: NSRange(location: 0, length: jsContent.count))
        var hashMap = [String: String]()
        for match in matchs {
            let hashRange = match.range(withName: "id")
            let nameRange = match.range(withName: "name")

            if hashRange.location == NSNotFound ||
                nameRange.location == NSNotFound {
                throw Error.parseDataError()
            }

            let hash = NSString(string: jsContent).substring(with: hashRange)
            let name = NSString(string: jsContent).substring(with: nameRange)

            hashMap[name] = hash
        }

        return hashMap
    }
}

public extension SN3Helper {
    enum Error: Swift.Error {
        case requestHtmlError(url: URL? = nil)
        case parseDataError(url: URL? = nil)
    }
}

private let versionRegex = try! NSRegularExpression(pattern: #"=.(?<revision>[0-9a-f]{40}).*revision_info_not_set.*=.(?<version>\d+\.\d+\.\d+)-"#, options: [])
private let hashRegex = try! NSRegularExpression(pattern: #"params:\{id:.(?<id>[0-9a-f]{64}).,metadata:\{\},name:.(?<name>[a-zA-Z0-9_]+).,"#, options: [])
