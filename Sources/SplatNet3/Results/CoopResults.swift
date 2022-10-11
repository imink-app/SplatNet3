import Foundation

extension EndPoints {
    public typealias CoopResults = [SN3DataItem<CoopResultsItem>]
}

public struct CoopResultsItem: Codable, Hashable {
    public let coopHistoryDetail: CoopHistoryDetail
}

public struct CoopHistoryDetail: Codable, Hashable {
    public let __typename: String
    public let afterGrade: SN3IDName
    public let afterGradePoint: Int
    public let bossResult: BossResult?
    public let coopStage: SN3IDNameImage
    public let dangerRate: Double
    public let enemyResults: [EnemyResult]
    public let id: String
    public let jobBonus: Int
    public let jobPoint: Int
    public let jobRate: Double
    public let jobScore: Int
    public let memberResults: [MyResultElement]
    public let myResult: MyResultElement
    public let nextHistoryDetail: SN3JustID
    public let playedTime: Date
    public let previousHistoryDetail: SN3JustID?
    public let resultWave: Int
    public let rule: Rule
    public let scale: Scale?
    // TODO: ?
//    public let scenarioCode: Never?
    public let smellMeter: Int
    public let waveResults: [WaveResult]
    public let weapons: [SN3NameImage]
}

extension CoopHistoryDetail {
    
    public struct BossResult: Codable, Hashable {
        public let boss: SN3IDNameImage
        public let hasDefeatBoss: Bool
    }
    
    public struct EnemyResult: Codable, Hashable {
        public let defeatCount: Int
        public let enemy: SN3IDNameImage
        public let popCount: Int
        public let teamDefeatCount: Int
    }
    
    public struct MyResultElement: Codable, Hashable {
        public let defeatEnemyCount: Int
        public let deliverCount: Int
        public let goldenAssistCount: Int
        public let goldenDeliverCount: Int
        public let player: Player
        public let rescueCount: Int
        public let rescuedCount: Int
        public let specialWeapon: SN3IDNameImage
        public let weapons: [SN3NameImage]
    }
    
    public struct Player: Codable, Hashable {
        public let __isPlayer: String
        public let byname: String
        public let id: String
        public let isMyself: Bool
        public let name: String
        public let nameId: String
        public let nameplate: Nameplate
        public let species: SquidSpecies
        public let uniform: SN3IDNameImage
    }
    
    public struct Rule: RawRepresentable, Codable, Hashable {
        
        public let rawValue: String
        public init(rawValue: String) {
            self.rawValue = rawValue
        }
        
        public static let regular = Self(rawValue: "REGULAR")
    }
    
    public struct Scale: Codable, Hashable {
        public let bronze: Int
        public let gold: Int
        public let silver: Int
    }
    
    public struct WaveResult: Codable, Hashable {
        public let deliverNorm: Int?
        public let eventWave: SN3IDName?
        public let goldenPopCount: Int
        public let specialWeapons: [SN3IDNameImage]
        public let teamDeliverCount: Int?
        public let waterLevel: Int
        public let waveNumber: Int
    }
}
