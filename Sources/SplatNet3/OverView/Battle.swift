import Foundation

public struct BattleHistories: Codable, Hashable {
    public let summary: BattleHistoriesSummary
    public let historyGroupsOnlyFirst: SN3NodesItem<BattleHistoryGroupFirst>
    public let historyGroups: SN3NodesItem<BattleHistoryItem>
}

public struct BattleHistoriesSummary: Codable, Hashable {
    public let assistAverage: Double
    public let deathAverage: Double
    public let killAverage: Double
    public let lose: Int
    public let perUnitTimeMinute: Int
    public let specialAverage: Double
    public let win: Int
}

public struct BattleHistoryGroupFirst: Codable, Hashable {
    public let historyDetails: SN3NodesItem<Detail>
    
    public struct Detail: Codable, Hashable {
        public let id: SN3ID
        public let player: Player
        
        public struct Player: Codable, Hashable {
            public let id: SN3ID
            public let weapon: Weapon
            
            public struct Weapon: Codable, Hashable {
                public let id: SN3ID
                public let specialWeapon: SpecialWeapon
                
                public struct SpecialWeapon: Codable, Hashable {
                    public let id: SN3ID
                    public let maskingImage: MaskingImage
                    
                    public struct MaskingImage: Codable, Hashable {
                        public let width: Int
                        public let height: Int
                        public let maskImageUrl: String
                        public let overlayImageUrl: String
                    }
                }
            }
        }
    }
}

public struct BattleHistoryItem: Codable, Hashable {
    public let lastPlayedTime: Date
    public let historyDetails: SN3NodesItem<BattleHistoryDetail>
}

public struct BattleHistoryDetail: Codable, Hashable {
    public let id: SN3ID
    public let vsMode: VSMode
    public let vsRule: SN3IDName
    public let vsStage: SN3IDNameImage
    public let judgement: VSJudgement
    public let player: Player
    public let knockout: VSKnockout?
    public let myTeam: MyTeam
    public let nextHistoryDetail: SN3JustID?
    public let previousHistoryDetail: SN3JustID?
    
    /// for bankara only
    public let udemae: Udemae?
    /// for bankara only
    public let bankaraMatch: BankaraMatch?
    
    public struct Player: Codable, Hashable {
        
        public let id: SN3ID
        public let weapon: SN3IDNameImage
        
        public let festGrade: String?
    }
    
    public struct MyTeam: Codable, Hashable {
        public let result: TeamResult?
        
        public struct TeamResult: Codable, Hashable {
            public let paintPoint: Int?
            public let paintRatio: Double?
            public let score: Int?
        }
    }
    
    public struct BankaraMatch: Codable, Hashable {
        public let earnedUdemaePoint: Int?
    }
}

public struct Udemae: RawRepresentable, Codable, Hashable {
    public let rawValue: String
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
    
    /// S
    public static let s = Self(rawValue: "S")
    /// S+0
    public static let s0 = Self(rawValue: "S+0")
}
