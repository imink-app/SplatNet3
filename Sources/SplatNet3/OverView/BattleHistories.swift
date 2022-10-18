import Foundation

public struct BattleHistories: Codable, Hashable {
    
    public let summary: Summary
    public let historyGroupsOnlyFirst: SN3NodesItem<First>
    public let historyGroups: SN3NodesItem<Group>
}

extension BattleHistories {
    
    public struct Summary: Codable, Hashable {
        public let assistAverage: Double
        public let deathAverage: Double
        public let killAverage: Double
        public let lose: Int
        public let perUnitTimeMinute: Int
        public let specialAverage: Double
        public let win: Int
    }
    
    public struct First: Codable, Hashable {
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
    
    public struct Group: Codable, Hashable {
        
        public let historyDetails: SN3NodesItem<Detail>
        /// nil for bankara battles
        public let lastPlayedTime: Date?
        public let bankaraMatchChallenge: BankaraChallenge?
    }
}

extension BattleHistories.Group {
    
    public struct BankaraChallenge: Codable, Hashable {
        public let winCount: Int
        public let loseCount: Int
        public let maxWinCount: Int
        public let maxLoseCount: Int
        public let state: String
        public let isPromo: Bool
        public let isUdemaeUp: Bool?
        public let udemaeAfter: Udemae?
        public let earnedUdemaePoint: Int?
    }
    
    public struct Detail: Codable, Hashable {
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
            
            /// for fest match only
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
}

public struct Udemae: RawRepresentable, Codable, Hashable {
    
    public let rawValue: String
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
    
    public var sPlusNumber: Int? {
        if rawValue.hasPrefix("S+") {
            let num = Int(rawValue.dropFirst(2))
            assert(num != nil)
            return num
        }
        return nil
    }
    
    public static func s(plus: Int? = nil) -> Udemae {
        if let plus {
            return Udemae(rawValue: "S+\(plus)")
        } else {
            return Udemae(rawValue: "S")
        }
    }
}
