import Foundation

public enum SN3Response: Codable, Hashable {
    // Singular
    case latestBattleHistories(SN3DataItem<BattleHistories>)
    case regularBattleHistories(SN3DataItem<BattleHistories>)
    case bankaraBattleHistories(SN3DataItem<BattleHistories>)
    case privateBattleHistories(SN3DataItem<BattleHistories>)
    case coopHistory(SN3DataItem<CoopHistory>)
    
    // Plural
    case vsHistoryDetail(SN3DataItem<VSHistoryDetail>)
    case coopHistoryDetail(SN3DataItem<CoopHistoryDetail>)
}
