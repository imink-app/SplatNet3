import Foundation            
import ArgumentParser
import SplatNet3Helper

@main
struct SN3CLI: AsyncParsableCommand {
    enum CMD: String, ExpressibleByArgument, CaseIterable {
        case webview
    }

    @Argument(help: "")
    var cmd: CMD? = nil

    mutating func run() async throws {
        if cmd == .webview {
            let decoder = JSONDecoder()

            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
            encoder.keyEncodingStrategy = .convertToSnakeCase

            let fm = FileManager.default
            let saveURL = URL(fileURLWithPath: fm.currentDirectoryPath).appendingPathComponent("splatnet3_webview_data.json", isDirectory: false)

            let data = try await SN3Helper.getWebViewData()

            if fm.fileExists(atPath: saveURL.path),
                let json = try? String(contentsOf: saveURL, encoding: .utf8),
                let existData = try? decoder.decode(SN3WebViewData.self, from: json.data(using: .utf8)!),
                existData == data {
                return
            }

            let str = String(data: try! encoder.encode(data), encoding: .utf8)!
            try str.write(to: saveURL, atomically: true, encoding: .utf8)
        }
    }
}
