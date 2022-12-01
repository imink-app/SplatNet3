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
            let data = try await SN3Helper.getWebViewData()

            let encoder = JSONEncoder()
            let str = String(data: try! encoder.encode(data), encoding: .utf8)!

            let fm = FileManager()
            let saveURL = fm.currentDirectoryPath.appendingPathComponent("splatnet3_webview_data.json")

            try str.write(toFile: saveURL, atomically: true, encoding: .utf8)
        }
    }
}