import Foundation
import ArgumentParser
import SplatNet3Helper

struct Webview: AsyncParsableCommand {
    
    static let configuration = CommandConfiguration(
        abstract: "dump webview data, including version and graphql hash.")
    
    func run() async throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.keyEncodingStrategy = .convertToSnakeCase
        let obj = try await SN3Helper.getWebViewData()
        let str = String(data: try encoder.encode(obj), encoding: .utf8)!
        print(str)
    }
}
