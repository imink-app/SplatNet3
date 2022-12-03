import Foundation

struct GraphQLRequestBody: Encodable {
    let variables: [String: String]
    let extensions: Extensions

    struct Extensions: Encodable {
        let persistedQuery: PersistedQuery

        struct PersistedQuery: Encodable {
            let version: Int
            let sha256Hash: String
        }
    }
}

// extension GraphQLRequestBody {
//     init<T>(extensions: Extensions, variables: T = [String: String]()) where T: Encodable {
//         self.extensions = extensions
//         self.variables = variables
//     }

//     enum CodingKeys: CodingKey {
//         case extensions, variables
//     }

//     func encode(to encoder: Encoder) throws {
//         var container = encoder.container(keyedBy: CodingKeys.self)
//         try container.encode(extensions, forKey: CodingKeys.extensions)
//         try container.encode(variables, forKey: CodingKeys.variables)
//     }
// }
