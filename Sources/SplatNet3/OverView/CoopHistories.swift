import Foundation

public struct CoopHistories: Codable, Hashable {
    
    public let historyGroupsOnlyFirst: SN3NodesItem<First>
    public let regularAverageClearWave: Double
    public let regularGrade: SN3IDName
    public let regularGradePoint: Int
    public let monthlyGear: MonthlyGear
    public let scale: Scale
    public let pointCard: PointCard
    public let historyGroups: SN3NodesItem<Group>
}

extension CoopHistories {
    
    public struct First: Codable, Hashable {
        public let historyDetails: SN3NodesItem<SN3JustID>
    }
    
    public struct MonthlyGear: Codable, Hashable {
        public let name: String
        public let image: SN3Image
        public let __typename: String
    }
    
    public struct Scale: Codable, Hashable {
        public let gold: Int
        public let silver: Int
        public let bronze: Int
    }
    
    public struct PointCard: Codable, Hashable {
        public let defeatBossCount: Int
        public let deliverCount: Int
        public let goldenDeliverCount: Int
        public let playCount: Int
        public let rescueCount: Int
        public let regularPoint: Int
        public let totalPoint: Int
    }
    
    public struct Group: Codable, Hashable {
        public let startTime: Date
        public let endTime: Date
        public let mode: String
        public let rule: String
        public let highestResult: HighestResult
        public let historyDetails: SN3NodesItem<Detail>
    }
}

extension CoopHistories.Group {
    
    public struct HighestResult: Codable, Hashable {
        public let grade: SN3IDName
        public let gradePoint: Int
        public let jobScore: Int
    }
    
    public struct Detail: Codable, Hashable {
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
        
        public struct GradePointDiff: RawRepresentable, Codable, Hashable {
            public let rawValue: String
            public init(rawValue: String) {
                self.rawValue = rawValue
            }
            
            public static let down = Self(rawValue: "DOWN")
            public static let keep = Self(rawValue: "KEEP")
            public static let up = Self(rawValue: "UP")
        }
        
        public struct BossResult: Codable, Hashable {
            public let hasDefeatBoss: Bool
            public let boss: SN3IDName
        }
        
        public struct MemberResult: Codable, Hashable {
            public let deliverCount: Int
            public let goldenDeliverCount: Int
        }
        
        public struct WaveResult: Codable, Hashable {
            public let waveNumber: Int
        }
    }
}
