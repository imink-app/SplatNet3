// https://github.com/samuelthomas2774/nxapi/discussions/11
// https://github.com/samuelthomas2774/nxapi/blob/main/src/api/splatnet3.ts
// https://github.com/samuelthomas2774/nxapi/blob/main/src/api/splatnet3-types.ts

public protocol SN3PersistedQuery {
    associatedtype Parameter = Void
    associatedtype Response: Decodable
    static var response: KeyPath<SN3Response, Response?> { get }
    static var hash: String { get }
}

public enum SN3PersistedQueries {
    
    public enum LatestBattleHistories: SN3PersistedQuery {
        public static let response = \SN3Response.latestBattleHistories
        public static let hash = "7d8b560e31617e981cf7c8aa1ca13a00"
    }
    
    public enum RegularBattleHistories: SN3PersistedQuery {
        public static let response = \SN3Response.regularBattleHistories
        public static let hash = "819b680b0c7962b6f7dc2a777cd8c5e4"
    }
    
    public enum BankaraBattleHistories: SN3PersistedQuery {
        public static let response = \SN3Response.bankaraBattleHistories
        public static let hash = "c1553ac75de0a3ea497cdbafaa93e95b"
    }
    
    public enum PrivateBattleHistories: SN3PersistedQuery {
        public static let response = \SN3Response.privateBattleHistories
        public static let hash = "51981299595060692440e0ca66c475a1"
    }
    
    public enum CoopHistory: SN3PersistedQuery {
        public static let response = \SN3Response.coopHistory
        public static let hash = "817618ce39bcf5570f52a97d73301b30"
    }
    
    public enum VSHistoryDetail: SN3PersistedQuery {
        public static let response = \SN3Response.vsHistoryDetail
        public static let hash = "2b085984f729cd51938fc069ceef784a"
        
        public struct Parameter {
            public let vsResultId: String
        }
    }
    
    public enum CoopHistoryDetail: SN3PersistedQuery {
        public static let response = \SN3Response.coopHistoryDetail
        public static let hash = "f3799a033f0a7ad4b1b396f9a3bafb1e"
        
        public struct Parameter {
            public let coopHistoryDetailId: String
        }
    }
}
