import Foundation

public struct VSPlayerSelf: Codable, Hashable {
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

public struct VSPlayer: Codable, Hashable {
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
    public let festDragonCert: String
    public let __isPlayer: String
    public let __typename: String
    
    public struct PlayerResult: Codable, Hashable {
        public let kill: Int
        public let assist: Int
        public let death: Int
        public let special: Int
        // TODO: ?
//        public let noroshiTry: Never?
    }
    
    public struct Weapon: Codable, Hashable {
        public let id: SN3ID
        public let name: String
        public let subWeapon: WeaponImage
        public let specialWeapon: WeaponImage
        public let image: SN3Image
        public let image2D: SN3Image
        public let image3D: SN3Image
        public let image2DThumbnail: SN3Image
        public let image3DThumbnail: SN3Image
        
        public struct WeaponImage: Codable, Hashable {
            public let id: SN3ID
            public let image: SN3Image
            public let name: String
            public let maskingImage: SN3MaskingImage
        }
    }
    
    public struct FestDragonCert: RawRepresentable, Codable, Hashable {
        public let rawValue: String
        public init(rawValue: String) {
            self.rawValue = rawValue
        }
        
        public static let dragon = Self(rawValue: "DRAGON")
        public static let none = Self(rawValue: "NONE")
    }
}

// MARK: -

public struct VSGear: Codable, Hashable {
    public let name: String
    public let brand: Brand
    public let image: SN3Image?
    public let originalImage: SN3Image
    public let thumbnailImage: SN3Image
    public let primaryGearPower: SN3NameImage
    public let additionalGearPowers: [SN3NameImage]
    public let __isGear: GearType
    
    public struct GearType: RawRepresentable, Codable, Hashable {
        public let rawValue: String
        public init(rawValue: String) {
            self.rawValue = rawValue
        }
        
        public static let clothing = Self(rawValue: "ClothingGear")
        public static let head = Self(rawValue: "HeadGear")
        public static let shoes = Self(rawValue: "ShoesGear")
    }
    
    public struct Brand: Codable, Hashable {
        public let id: SN3ID
        public let name: String
        public let image: SN3Image
        public let maskingImage: SN3MaskingImage
        public let usualGearPower: UsualGearPower
        
        public struct UsualGearPower: Codable, Hashable {
            public let name: String
            public let image: SN3Image
            public let isEmptySlot: Bool
            public let desc: String
        }
    }
}
