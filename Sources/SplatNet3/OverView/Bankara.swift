import Foundation

public struct BankaraBattleHistories: Codable, Hashable {
    public let summary: BattleHistoriesSummary
    public let historyGroupsOnlyFirst: SN3NodesItem<BattleHistoryGroupFirst>
    public let historyGroups: SN3NodesItem<BankaraBattleHistoryItem>
}

public struct BankaraBattleHistoryItem: Codable, Hashable {
    public let bankaraMatchChallenge: BankaraMatchChallenge?
    public let historyDetails: SN3NodesItem<BattleHistoryDetail>
    
    public struct BankaraMatchChallenge: Codable, Hashable {
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
}
