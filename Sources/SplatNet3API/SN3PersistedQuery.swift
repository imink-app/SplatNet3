public enum SN3PersistedQuery {
    case latestBattleHistories
    case regularBattleHistories
    case bankaraBattleHistories
    case privateBattleHistories
    case vsHistoryDetail(vsResultId: String)
    case coopHistory
    case coopHistoryDetail(coopHistoryDetailId: String)
}

extension SN3PersistedQuery {
    var graphQLName: String {
        switch self {
            case .latestBattleHistories:
                return "LatestBattleHistoriesQuery"
            case .regularBattleHistories:
                return "RegularBattleHistoriesQuery"
            case .bankaraBattleHistories:
                return "BankaraBattleHistoriesQuery"
            case .privateBattleHistories:
                return "PrivateBattleHistoriesQuery"
            case .vsHistoryDetail:
                return "VsHistoryDetailQuery"
            case .coopHistory:
                return "CoopHistoryQuery"
            case .coopHistoryDetail:
                return "CoopHistoryDetailQuery"
        }
    }
}