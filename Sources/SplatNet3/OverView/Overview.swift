import Foundation

extension SN3EndPoints {
    public typealias OverView = [SN3DataItem<OverviewItem>]
}

public enum OverviewItem: Codable, Hashable {
    /// Turf War
    case regularBattleHistories(BattleHistories)
    /// Anarchy Battles
    case bankaraBattleHistories(BattleHistories)
    /// Private Battles
    case privateBattleHistories(BattleHistories)
    /// Salmon Run
    case coopResult(CoopHistories)
}

extension OverviewItem {
    
    public var regularBattleHistories: BattleHistories? {
        if case .regularBattleHistories(let result) = self {
            return result
        }
        return nil
    }
    
    public var bankaraBattleHistories: BattleHistories? {
        if case .bankaraBattleHistories(let result) = self {
            return result
        }
        return nil
    }
    
    public var privateBattleHistories: BattleHistories? {
        if case .privateBattleHistories(let result) = self {
            return result
        }
        return nil
    }
    
    public var coopResult: CoopHistories? {
        if case .coopResult(let result) = self {
            return result
        }
        return nil
    }
}

extension Array where Element == SN3DataItem<OverviewItem> {
    
    public var regularBattleHistories: BattleHistories? {
        self.lazy.compactMap(\.data.regularBattleHistories).first
    }
    
    public var bankaraBattleHistories: BattleHistories? {
        self.lazy.compactMap(\.data.bankaraBattleHistories).first
    }
    
    public var privateBattleHistories: BattleHistories? {
        self.lazy.compactMap(\.data.privateBattleHistories).first
    }
    
    public var coopResult: CoopHistories? {
        self.lazy.compactMap(\.data.coopResult).first
    }
}
