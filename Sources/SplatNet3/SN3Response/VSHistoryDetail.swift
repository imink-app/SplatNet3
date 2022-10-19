import Foundation

extension SN3Response {
    
    public struct VSHistoryDetail: Decodable {
        public let __typename: String
        public let id: SN3ID
        public let playedTime: Date
        public let duration: Int
        public let vsMode: VSMode
        public let vsRule: VSRule
        public let vsStage: SN3IDNameImage
        public let judgement: VSJudgement
        public let knockout: VSKnockout
        public let player: PlayerSelf
        public let awards: [Award]
        public let myTeam: Team
        public let otherTeams: [Team]
        
        public let bankaraMatch: BankaraMatch?
        public let leagueMatch: SN3Response.Unknown?
        public let xMatch: SN3Response.Unknown?
        public let festMatch: FestMatch?
        
        public let previousHistoryDetail: SN3JustID?
        public let nextHistoryDetail: SN3JustID?
    }
}

extension SN3Response.VSHistoryDetail {
    
    public struct Award: Decodable {
        public let name: String
        public let rank: Rank
        
        public struct Rank: RawRepresentable, Decodable {
            public let rawValue: String
            public init(rawValue: String) { self.rawValue = rawValue }
            
            public static let gold = Rank(rawValue: "GOLD")
            public static let silver = Rank(rawValue: "SILVER")
        }
    }
    
    public struct BankaraMatch: Decodable {
        public let earnedUdemaePoint: Int?
        public let mode: Mode
        
        public struct Mode: RawRepresentable, Decodable {
            public let rawValue: String
            public init(rawValue: String) { self.rawValue = rawValue }
            
            public static let open = Self(rawValue: "OPEN")
            public static let challenge = Self(rawValue: "CHALLENGE")
        }
    }
    
    public struct FestMatch: Decodable {
        public let contribution: Int
        public let dragonMatchType: String
        public let jewel: Int
        public let myFestPower: Double
        
        public struct DragonMatchType: RawRepresentable, Decodable {
            public let rawValue: String
            public init(rawValue: String) { self.rawValue = rawValue }
            
            public static let normal = Self(rawValue: "NORMAL")
            /// 10x
            public static let decuple = Self(rawValue: "DECUPLE")
            /// 100x
            public static let dragon = Self(rawValue: "DRAGON")
            /// 333x
            public static let doubleDragon = Self(rawValue: "DOUBLE_DRAGON")
        }
    }
    
    public struct PlayerSelf: Decodable {
        public let id: SN3ID
        public let name: String
        public let byname: String
        public let nameId: String
        public let nameplate: Nameplate
        public let paint: Int
        public let headGear: VSGear
        public let clothingGear: VSGear
        public let shoesGear: VSGear
        public let __isPlayer: String
    }
    
    public struct Team: Decodable {
        public let color: SN3Color
        public let festTeamName: String?
        public let judgement: VSJudgement
        public let order: Int
        public let players: [Player]
        public let result: TeamResult
        public let tricolorRole: TricolorRole?
    }
}

extension SN3Response.VSHistoryDetail.Team {
    
    public struct Player: Decodable {
        public let id: SN3ID
        public let name: String
        public let nameId: String
        public let nameplate: Nameplate
        public let byname: String
        public let species: SquidSpecies
        public let isMyself: Bool
        public let paint: Int
        public let result: PlayerResult
        
        public let weapon: Weapon
        public let headGear: VSGear
        public let clothingGear: VSGear
        public let shoesGear: VSGear
        public let festDragonCert: FestDragonCert
        public let __isPlayer: String
        public let __typename: String
    }
    
    public struct TeamResult: Decodable {
        public let paintRatio: Double
        public let score: Int?
        public let noroshi: Int?
    }
    
    public struct TricolorRole: RawRepresentable, Decodable {
        public let rawValue: String
        public init(rawValue: String) { self.rawValue = rawValue }
        
        public static let attack1 = Self(rawValue: "ATTACK1")
        public static let attack2 = Self(rawValue: "ATTACK2")
        public static let defense = Self(rawValue: "DEFENSE")
    }
}


extension SN3Response.VSHistoryDetail.Team.Player {
    
    public struct PlayerResult: Decodable {
        public let kill: Int
        public let assist: Int
        public let death: Int
        public let special: Int
        public let noroshiTry: Int?
    }
    
    public struct Weapon: Decodable {
        public let id: SN3ID
        public let name: String
        public let subWeapon: WeaponImage
        public let specialWeapon: WeaponImage
        public let image: SN3Image
        public let image2D: SN3Image
        public let image3D: SN3Image
        public let image2DThumbnail: SN3Image
        public let image3DThumbnail: SN3Image
        
        public struct WeaponImage: Decodable {
            public let id: SN3ID
            public let image: SN3Image
            public let name: String
            public let maskingImage: SN3MaskingImage
        }
    }
    
    public struct FestDragonCert: RawRepresentable, Decodable {
        public let rawValue: String
        public init(rawValue: String) { self.rawValue = rawValue }
        
        public static let none = Self(rawValue: "NONE")
        /// 100x
        public static let dragon = Self(rawValue: "DRAGON")
        /// 333x
        public static let doubleDragon = Self(rawValue: "DOUBLE_DRAGON")
    }
}

public struct VSGear: Decodable {
    public let name: String
    public let brand: Brand
    public let image: SN3Image?
    public let originalImage: SN3Image
    public let thumbnailImage: SN3Image
    public let primaryGearPower: SN3NameImage
    public let additionalGearPowers: [SN3NameImage]
    public let __isGear: GearType
    
    public struct GearType: RawRepresentable, Decodable {
        public let rawValue: String
        public init(rawValue: String) { self.rawValue = rawValue }
        
        public static let head = Self(rawValue: "HeadGear")
        public static let clothing = Self(rawValue: "ClothingGear")
        public static let shoes = Self(rawValue: "ShoesGear")
    }
    
    public struct Brand: Decodable {
        public let id: SN3ID
        public let name: String
        public let image: SN3Image
        public let maskingImage: SN3MaskingImage
        public let usualGearPower: UsualGearPower
        
        public struct UsualGearPower: Decodable {
            public let name: String
            public let image: SN3Image
            public let isEmptySlot: Bool
            public let desc: String
        }
    }
}

