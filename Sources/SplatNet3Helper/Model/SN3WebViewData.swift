import Foundation
import SplatNet3API
import SwiftSoup

public struct SN3WebViewData: Codable {
    let version: String
    let graphQL: GraphQL

    public struct GraphQL: Codable {
        let apis: [String: String]
    }
}

public extension SN3Helper {
    static func getWebViewData() async throws -> SN3WebViewData {
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

        let sn3Data = SN3WebViewData(
            version: try parseWebViewVersion(jsContent: jsContent),
            graphQL: SN3WebViewData.GraphQL(apis: try parseGraphQLAPIs(jsContent: jsContent))
        )

        return sn3Data
    }

    private static func parseWebViewVersion(jsContent: String) throws -> String {
        guard
            let match = try? NSRegularExpression(
                pattern: #"=.(?<revision>[0-9a-f]{40}).*revision_info_not_set.*=.(?<version>\d+\.\d+\.\d+)-"#,
                options: [])
                .firstMatch(in: jsContent, range: NSRange(location: 0, length: jsContent.count))
        else {
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

    private static func parseGraphQLAPIs(jsContent: String) throws -> [String: String] {
        guard
            let matchs = try? NSRegularExpression(
                pattern: #"params:\{id:.(?<id>[0-9a-f]{32}).,metadata:\{\},name:.(?<name>[a-zA-Z0-9_]+).,"#,
                options: [])
                .matches(in: jsContent, range: NSRange(location: 0, length: jsContent.count))
        else {
            throw Error.parseDataError()
        }

        var apis = [String: String]()
        for match in matchs {
            let hashRange = match.range(withName: "id")
            let nameRange = match.range(withName: "name")

            if hashRange.location == NSNotFound ||
                nameRange.location == NSNotFound {
                throw Error.parseDataError()
            }

            let hash = NSString(string: jsContent).substring(with: hashRange)
            let name = NSString(string: jsContent).substring(with: nameRange)

            apis[name] = hash
        }

        return apis
    }
}