import ArgumentParser

@main
struct SN3CLI: AsyncParsableCommand {
    
    static let configuration = CommandConfiguration(subcommands: [Webview.self])
    
}
