import Foundation

// MARK: - Basic

public struct SN3Image: Codable, Hashable {
    public let url: URL
}

public struct SN3JustID: Codable, Hashable {
    public let id: SN3ID
}

public struct SN3IDName: Codable, Hashable {
    public let id: SN3ID
    public let name: String
}

public struct SN3IDImage: Codable, Hashable {
    public let id: SN3ID
    public let image: SN3Image
}

public struct SN3NameImage: Codable, Hashable {
    public let name: String
    public let image: SN3Image
}

public struct SN3IDNameImage: Codable, Hashable {
    public let id: SN3ID
    public let name: String
    public let image: SN3Image
}

public struct SN3MaskingImage: Codable, Hashable {
    public let width: Int
    public let height: Int
    public let maskImageUrl: String
    public let overlayImageUrl: String
}

public struct SN3Color: Codable, Hashable {
    public let r: Double
    public let g: Double
    public let b: Double
    public let a: Double
}

// MARK: -

public struct SquidSpecies: RawRepresentable, Codable, Hashable {
    
    public let rawValue: String
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
    
    public static let inkling = Self(rawValue: "INKLING")
    public static let octoling = Self(rawValue: "OCTOLING")
}

public struct Nameplate: Codable, Hashable {
    public let background: Background
    /// consists of 3 optioanl badge
    public let badges: [SN3IDImage?]
    
    public struct Background: Codable, Hashable {
        public let id: SN3ID
        public let image: SN3Image
        public let textColor: SN3Color
    }
}

// MARK: - VS

public struct VSJudgement: RawRepresentable, Codable, Hashable {
    public let rawValue: String
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
    
    public static let win = Self(rawValue: "WIN")
    public static let lose = Self(rawValue: "LOSE")
    public static let draw = Self(rawValue: "DRAW")
    public static let exemptedLose = Self(rawValue: "EXEMPTED_LOSE")
    public static let deemedLose = Self(rawValue: "DEEMED_LOSE")
}

public struct VSKnockout: RawRepresentable, Codable, Hashable {
    public let rawValue: String
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
    
    public static let win = Self(rawValue: "WIN")
    public static let lose = Self(rawValue: "LOSE")
    public static let neither = Self(rawValue: "NEITHER")
}

public struct VSMode: Codable, Hashable {
    
    public let id: SN3ID
    public let mode: Mode
    
    public struct Mode: RawRepresentable, Codable, Hashable {
        public let rawValue: String
        public init(rawValue: String) {
            self.rawValue = rawValue
        }
        
        public static let bankara = Self(rawValue: "BANKARA")
        public static let fest = Self(rawValue: "FEST")
        public static let `private` = Self(rawValue: "PRIVATE")
    }
}

public struct VSRule: Codable, Hashable {
    public let id: SN3ID
    public let name: String
    public let rule: String
    
    public struct Rule: RawRepresentable, Codable, Hashable {
        public let rawValue: String
        public init(rawValue: String) {
            self.rawValue = rawValue
        }
        
        public static let turfWar = Self(rawValue: "TURF_WAR")
        public static let splatZones = Self(rawValue: "AREA")
        public static let towerControl = Self(rawValue: "LOFT")
        public static let rainMaker = Self(rawValue: "GOAL")
        public static let clamBlitz = Self(rawValue: "CLAM")
    }
}
