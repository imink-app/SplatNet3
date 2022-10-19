import Foundation

extension SN3Response {
    
    public struct BattleHistories: Decodable {
        public let summary: Summary
        public let historyGroupsOnlyFirst: SN3NodesItem<First>
        public let historyGroups: SN3NodesItem<Group>
    }
}

extension SN3Response.BattleHistories {
    
    public struct Summary: Decodable {
        public let assistAverage: Double
        public let deathAverage: Double
        public let killAverage: Double
        public let lose: Int
        public let perUnitTimeMinute: Int
        public let specialAverage: Double
        public let win: Int
    }
    
    public struct First: Decodable {
        public let historyDetails: SN3NodesItem<Detail>
        
        public struct Detail: Decodable {
            public let id: SN3ID
            public let player: Player
            
            public struct Player: Decodable {
                public let id: SN3ID
                public let weapon: Weapon
                
                public struct Weapon: Decodable {
                    public let id: SN3ID
                    public let specialWeapon: SpecialWeapon
                    
                    public struct SpecialWeapon: Decodable {
                        public let id: SN3ID
                        public let maskingImage: MaskingImage
                        
                        public struct MaskingImage: Decodable {
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
    
    public struct Group: Decodable {
        public let historyDetails: SN3NodesItem<Detail>
        /// nil for bankara battles
        public let lastPlayedTime: Date?
        public let bankaraMatchChallenge: BankaraChallenge?
    }
}

extension SN3Response.BattleHistories.Group {
    
    public struct BankaraChallenge: Decodable {
        public let winCount: Int
        public let loseCount: Int
        public let maxWinCount: Int
        public let maxLoseCount: Int
        public let state: String
        public let isPromo: Bool
        public let isUdemaeUp: Bool?
        public let udemaeAfter: String?
        public let earnedUdemaePoint: Int?
    }
    
    public struct Detail: Decodable {
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
        public let udemae: String?
        /// for bankara only
        public let bankaraMatch: BankaraMatch?
        
        public struct Player: Decodable {
            public let id: SN3ID
            public let weapon: SN3IDNameImage
            /// for fest match only
            public let festGrade: String?
        }
        
        public struct MyTeam: Decodable {
            public let result: TeamResult?
            
            public struct TeamResult: Decodable {
                public let paintPoint: Int?
                public let paintRatio: Double?
                public let score: Int?
            }
        }
        
        public struct BankaraMatch: Decodable {
            public let earnedUdemaePoint: Int?
        }
    }
}
