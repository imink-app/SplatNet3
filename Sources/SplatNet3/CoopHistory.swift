import Foundation

public struct CoopHistory: Decodable {
    public let historyGroupsOnlyFirst: SN3NodesList<First>
    public let regularAverageClearWave: Double
    public let regularGrade: SN3IDName
    public let regularGradePoint: Int
    public let monthlyGear: MonthlyGear
    public let scale: Scale
    public let pointCard: PointCard
    public let historyGroups: SN3NodesList<Group>
}

extension CoopHistory {
    
    public struct First: Decodable {
        public let historyDetails: SN3NodesList<SN3JustID>
    }
    
    public struct MonthlyGear: Decodable {
        public let name: String
        public let image: SN3Image
        public let __typename: String
    }
    
    public struct Scale: Decodable {
        public let gold: Int
        public let silver: Int
        public let bronze: Int
    }
    
    public struct PointCard: Decodable {
        public let defeatBossCount: Int
        public let deliverCount: Int
        public let goldenDeliverCount: Int
        public let playCount: Int
        public let rescueCount: Int
        public let regularPoint: Int
        public let totalPoint: Int
    }
    
    public struct Group: Decodable {
        public let startTime: SN3Date
        public let endTime: SN3Date
        public let mode: String
        public let rule: String
        public let highestResult: HighestResult
        public let historyDetails: SN3NodesList<Detail>
    }
}

extension CoopHistory.Group {
    
    public struct HighestResult: Decodable {
        public let grade: SN3IDName
        public let gradePoint: Int
        public let jobScore: Int
    }
    
    public struct Detail: Decodable {
        public let id: SN3ID
        public let weapons: [SN3NameImage]
        public let nextHistoryDetail: SN3JustID?
        public let previousHistoryDetail: SN3JustID?
        public let resultWave: Int
        public let coopStage: SN3IDName
        public let afterGrade: SN3IDName
        public let afterGradePoint: Int
        public let gradePointDiff: GradePointDiff
        public let bossResult: BossResult?
        public let myResult: MemberResult
        public let memberResults: [MemberResult]
        public let waveResults: [WaveResult]
        
        public struct GradePointDiff: RawRepresentable, Decodable {
            public let rawValue: String
            public init(rawValue: String) { self.rawValue = rawValue }
            
            public static let down = Self(rawValue: "DOWN")
            public static let keep = Self(rawValue: "KEEP")
            public static let up = Self(rawValue: "UP")
        }
        
        public struct BossResult: Decodable {
            public let hasDefeatBoss: Bool
            public let boss: SN3IDName
        }
        
        public struct MemberResult: Decodable {
            public let deliverCount: Int
            public let goldenDeliverCount: Int
        }
        
        public struct WaveResult: Decodable {
            public let waveNumber: Int
        }
    }
}
