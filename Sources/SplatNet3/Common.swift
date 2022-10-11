import Foundation

public struct SN3ID: RawRepresentable, Hashable, Codable {
    
    public let rawValue: String
    
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
    
    public func encode(to encoder: Encoder) throws {
        let str = rawValue.data(using: .utf8)!.base64EncodedString()
        var container = encoder.singleValueContainer()
        try container.encode(str)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let str = try container.decode(String.self)
        guard let data = Data(base64Encoded: str),
                let decoded = String(data: data, encoding: .utf8) else {
            throw DecodingError
                .dataCorrupted(.init(codingPath: container.codingPath, debugDescription: "invalid SN3ID"))
        }
        self.init(rawValue: decoded)
    }
}

public struct SN3DataItem<Content>: Hashable, Codable where Content: Hashable, Content: Codable {
    public let data: Content
}

public struct SN3NodesItem<Node>: Hashable, Codable where Node: Hashable, Node: Codable {
    public let nodes: [Node]
}

extension SN3NodesItem: RandomAccessCollection {
    
    public var startIndex: Int { nodes.startIndex }
    
    public var endIndex: Int { nodes.endIndex }
    
    public subscript(position: Int) -> Node { nodes[position] }
}


