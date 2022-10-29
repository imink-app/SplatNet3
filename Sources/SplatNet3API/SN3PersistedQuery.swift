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
    var hash: String {
        switch self {
            case .latestBattleHistories:
                return "7d8b560e31617e981cf7c8aa1ca13a00"
            case .regularBattleHistories:
                return "f6e7e0277e03ff14edfef3b41f70cd33"
            case .bankaraBattleHistories:
                return "c1553ac75de0a3ea497cdbafaa93e95b"
            case .privateBattleHistories:
                return "38e0529de8bc77189504d26c7a14e0b8"
            case .vsHistoryDetail:
                return "2b085984f729cd51938fc069ceef784a"
            case .coopHistory:
                return "817618ce39bcf5570f52a97d73301b30"
            case .coopHistoryDetail:
                return "f3799a033f0a7ad4b1b396f9a3bafb1e"
        }
    }
}