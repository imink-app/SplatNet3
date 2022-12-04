import Foundation
import InkMoya

public enum SN3API {
    case web(path: String = "/")
    case bulletTokens(gameServiceToken: String)
}

extension SN3API: TargetType {
    
    public var baseURL: URL { URL(string: "https://api.lp1.av5ja.srv.nintendo.net")! }
    
    public var path: String {
        switch self {
        case .web(let path):
            return path
        case .bulletTokens:
            return "/api/bullet_tokens"
        }
    }
    
    public var method: RequestMethod {
        switch self {
        case .web:
            return .get
        default:
            return .post
        }
    }
    
    public var headers: [String : String]? {
        switch self {
        case .web:
            return nil
        case .bulletTokens(let gameServiceToken):
            return [
                "Accept-Language": "en-GB",
                "X-NACountry": "US",
                "Cookie": "_gtoken=\(gameServiceToken);"
            ]
        }
    }
    
    public var querys: [(String, String?)]? { nil }
    
    public var data: MediaType? { nil }
    
    public var sampleData: Data {
        let path = "/SampleData/\(sampleDataFileName)"
        let url = Bundle.module.url(forResource: path, withExtension: nil)!
        return try! Data(contentsOf: url)
    }
}

extension SN3API {
    var sampleDataFileName: String {
        switch self {
        case .web(let path):
            if path.hasPrefix("/static/js/main.") {
                return "main.js"
            } else {
                return "api.lp1.av5ja.srv.nintendo.net.html"
            }
        case .bulletTokens:
            return "bulletTokens.json"
        }
    }
}
