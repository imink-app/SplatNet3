import Foundation

extension SN3EndPoints {
    
    public struct Overview: Codable, Hashable {
        
        public let regularBattleHistories: BattleHistories
        public let bankaraBattleHistories: BankaraBattleHistories
        public let privateBattleHistories: BattleHistories
        public let coopResult: CoopResult
        
        func encode(to encoder: Encoder) throws {
            let items = [
                __OverviewItem(
                    regularBattleHistories: regularBattleHistories,
                    bankaraBattleHistories: nil,
                    privateBattleHistories: nil,
                    coopResult: nil),
                __OverviewItem(
                    regularBattleHistories: nil,
                    bankaraBattleHistories: bankaraBattleHistories,
                    privateBattleHistories: nil,
                    coopResult: nil),
                __OverviewItem(
                    regularBattleHistories: nil,
                    bankaraBattleHistories: nil,
                    privateBattleHistories: privateBattleHistories,
                    coopResult: nil),
                __OverviewItem(
                    regularBattleHistories: nil,
                    bankaraBattleHistories: nil,
                    privateBattleHistories: nil,
                    coopResult: coopResult),
            ].map(SN3DataItem<__OverviewItem>.init(data:))
            try items.encode(to: encoder)
        }
        
        public init(from decoder: Decoder) throws {
            let __overview = try [SN3DataItem<__OverviewItem>].init(from: decoder)
            var regularBattleHistories: BattleHistories?
            var bankaraBattleHistories: BankaraBattleHistories?
            var privateBattleHistories: BattleHistories?
            var coopResult: CoopResult?
            for item in __overview {
                func merge<T>(_ a: T?, into b: inout T?) {
                    if b == nil { b = a }
                }
                merge(item.data.regularBattleHistories, into: &regularBattleHistories)
                merge(item.data.bankaraBattleHistories, into: &bankaraBattleHistories)
                merge(item.data.privateBattleHistories, into: &privateBattleHistories)
                merge(item.data.coopResult, into: &coopResult)
            }
            guard let regularBattleHistories = regularBattleHistories,
                  let bankaraBattleHistories = bankaraBattleHistories,
                  let privateBattleHistories = privateBattleHistories,
                  let coopResult = coopResult else {
                // TODO: error
                throw DecodingError.valueNotFound(Never.self, .init(codingPath: decoder.codingPath, debugDescription: ""))
            }
            self.regularBattleHistories = regularBattleHistories
            self.bankaraBattleHistories = bankaraBattleHistories
            self.privateBattleHistories = privateBattleHistories
            self.coopResult = coopResult
        }
    }
}

struct __OverviewItem: Codable, Hashable {
    let regularBattleHistories: BattleHistories?
    let bankaraBattleHistories: BankaraBattleHistories?
    let privateBattleHistories: BattleHistories?
    let coopResult: CoopResult?
}


