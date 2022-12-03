import Foundation

struct GraphQLRequestBody: Encodable {
    
    var variables: AnyEncodable
    var extensions: Extensions
    
    init<T: Encodable>(variables: T, extensions: Extensions) {
        self.variables = AnyEncodable(variables)
        self.extensions = extensions
    }
    
    init(variables: AnyEncodable, extensions: Extensions) {
        self.variables = variables
        self.extensions = extensions
    }

    struct Extensions: Encodable {
        var persistedQuery: PersistedQuery

        struct PersistedQuery: Encodable {
            var version: Int
            var sha256Hash: String
        }
    }
}

struct AnyEncodable: Encodable {
    
    private var base: any Encodable
    
    init<T: Encodable>(_ base: T) {
        self.base = base
    }
    
    func encode(to encoder: Encoder) throws {
        try base.encode(to: encoder)
    }
}
