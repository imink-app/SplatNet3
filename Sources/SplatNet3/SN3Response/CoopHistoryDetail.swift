import Foundation

extension SN3Response {
    
    public struct CoopHistoryDetail: Decodable {
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
        public let memberResults: [MemberResult]
        public let myResult: MemberResult
        public let nextHistoryDetail: SN3JustID
        public let playedTime: Date
        public let previousHistoryDetail: SN3JustID?
        public let resultWave: Int
        public let rule: Rule
        public let scale: Scale?
        // TODO: ?
//        public let scenarioCode: Never?
        public let smellMeter: Int
        public let waveResults: [WaveResult]
        public let weapons: [SN3NameImage]
    }
}

extension SN3Response.CoopHistoryDetail {
    
    public struct BossResult: Decodable {
        public let boss: SN3IDNameImage
        public let hasDefeatBoss: Bool
    }
    
    public struct EnemyResult: Decodable {
        public let defeatCount: Int
        public let enemy: SN3IDNameImage
        public let popCount: Int
        public let teamDefeatCount: Int
    }
    
    public struct MemberResult: Decodable {
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
    
    public struct Rule: RawRepresentable, Decodable {
        public let rawValue: String
        public init(rawValue: String) { self.rawValue = rawValue }
        
        public static let regular = Self(rawValue: "REGULAR")
    }
    
    public struct Scale: Decodable {
        public let bronze: Int
        public let gold: Int
        public let silver: Int
    }
    
    public struct WaveResult: Decodable {
        public let deliverNorm: Int?
        public let eventWave: SN3IDName?
        public let goldenPopCount: Int
        public let specialWeapons: [SN3IDNameImage]
        public let teamDeliverCount: Int?
        public let waterLevel: Int
        public let waveNumber: Int
    }
}

extension SN3Response.CoopHistoryDetail.MemberResult {
    
    public struct Player: Decodable {
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
}
