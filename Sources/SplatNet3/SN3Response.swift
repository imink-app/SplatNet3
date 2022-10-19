import Foundation

public enum SN3Response: Decodable {
    case latestBattleHistories(SN3DataItem<BattleHistories>)
    case regularBattleHistories(SN3DataItem<BattleHistories>)
    case bankaraBattleHistories(SN3DataItem<BattleHistories>)
    case privateBattleHistories(SN3DataItem<BattleHistories>)
    case coopHistory(SN3DataItem<CoopHistory>)
    case vsHistoryDetail(SN3DataItem<VSHistoryDetail>)
    case coopHistoryDetail(SN3DataItem<CoopHistoryDetail>)
    
    // placeholder for unknown structure
    public struct Unknown: Decodable {}
}

extension SN3Response {
    
    public var latestBattleHistories: BattleHistories? {
        if case .latestBattleHistories(let resp) = self {
            return resp.data
        }
        return nil
    }
    
    public var regularBattleHistories: BattleHistories? {
        if case .regularBattleHistories(let resp) = self {
            return resp.data
        }
        return nil
    }
    
    public var bankaraBattleHistories: BattleHistories? {
        if case .bankaraBattleHistories(let resp) = self {
            return resp.data
        }
        return nil
    }
    
    public var privateBattleHistories: BattleHistories? {
        if case .privateBattleHistories(let resp) = self {
            return resp.data
        }
        return nil
    }
    
    public var coopHistory: CoopHistory? {
        if case .coopHistory(let resp) = self {
            return resp.data
        }
        return nil
    }
    
    public var vsHistoryDetail: VSHistoryDetail? {
        if case .vsHistoryDetail(let resp) = self {
            return resp.data
        }
        return nil
    }
    
    public var coopHistoryDetail: CoopHistoryDetail? {
        if case .coopHistoryDetail(let resp) = self {
            return resp.data
        }
        return nil
    }
}
