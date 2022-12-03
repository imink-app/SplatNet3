import Foundation

public struct SN3Response<Content: Decodable>: Decodable {
    public let data: Content
}

// placeholder for unknown structure
public struct SN3Unknown: Decodable {}

public struct SN3LatestBattleHistoriesData: Decodable {
    let currentFest: SN3Unknown?
    public let latestBattleHistories: BattleHistories
}

public struct SN3RegularBattleHistoriesData: Decodable {
    public let regularBattleHistories: BattleHistories
}

public struct SN3BankaraBattleHistoriesData: Decodable {
    public let bankaraBattleHistories: BattleHistories
}

public struct SN3PrivateBattleHistoriesData: Decodable {
    public let privateBattleHistories: BattleHistories
}

public struct SN3VSHistoryDetailData: Decodable {
    public let vsHistoryDetail: VSHistoryDetail
}

public struct SN3CoopHistoryData: Decodable {
    public let coopResult: CoopHistory
}

public struct SN3CoopHistoryDetailData: Decodable {
    public let coopHistoryDetail: CoopHistoryDetail
}
