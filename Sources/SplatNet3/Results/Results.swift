import Foundation

extension SN3EndPoints {
    public typealias Results = [SN3DataItem<ResultsItem>]
}

public struct ResultsItem: Codable, Hashable {
    public let vsHistoryDetail: VSHistoryDetail
}

public struct VSHistoryDetail: Codable, Hashable {
    
    public let __typename: String
    public let id: SN3ID
    public let playedTime: Date
    public let duration: Int
    public let vsMode: VSMode
    public let vsRule: VSRule
    public let vsStage: SN3IDNameImage
    public let judgement: VSJudgement
    public let knockout: VSKnockout
    public let player: VSPlayerSelf
    public let awards: [Award]
    public let myTeam: Team
    public let otherTeams: [Team]
    
    public let bankaraMatch: BankaraMatch?
    // TODO: ?
//    public let leagueMatch: Never?
//    public let xMatch: Never?
    public let festMatch: FestMatch?
    
    public let previousHistoryDetail: SN3JustID?
    public let nextHistoryDetail: SN3JustID?
    
    public struct Award: Codable, Hashable {
        public let name: String
        public let rank: String
        
        public struct Rank: RawRepresentable, Codable, Hashable {
            public let rawValue: String
            public init(rawValue: String) {
                self.rawValue = rawValue
            }
            
            public static let gold = Rank(rawValue: "GOLD")
            public static let silver = Rank(rawValue: "SILVER")
        }
    }
    
    public struct BankaraMatch: Codable, Hashable {
        public let earnedUdemaePoint: Int?
        public let mode: String
        
        public struct Mode: RawRepresentable, Codable, Hashable {
            public let rawValue: String
            public init(rawValue: String) {
                self.rawValue = rawValue
            }
            
            public static let challenge = Self(rawValue: "CHALLENGE")
            public static let open = Self(rawValue: "OPEN")
        }
    }
    
    public struct FestMatch: Codable, Hashable {
        public let contribution: Int
        public let dragonMatchType: String
        public let jewel: Int
        public let myFestPower: Double
    }
    
    public struct Team: Codable, Hashable {
        public let color: SN3Color
        public let festTeamName: String?
        public let judgement: VSJudgement
        public let order: Int
        public let players: [VSPlayer]
        public let result: TeamResult
        public let tricolorRole: TricolorRole?
        
        public struct TricolorRole: RawRepresentable, Codable, Hashable {
            public let rawValue: String
            public init(rawValue: String) {
                self.rawValue = rawValue
            }
            
            public static let attack1 = Self(rawValue: "ATTACK1")
            public static let attack2 = Self(rawValue: "ATTACK2")
            public static let defense = Self(rawValue: "DEFENSE")
        }
    }
}

public struct TeamResult: Codable, Hashable {
    public let paintRatio: Double
    // TODO: ?
//    public let score: Never?
//    public let noroshi: Never?
}
