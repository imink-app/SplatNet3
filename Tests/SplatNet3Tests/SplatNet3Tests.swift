import XCTest
@testable import InkMoya
@testable import SplatNet3
@testable import SplatNet3API
@testable import SplatNet3Helper

final class SplatNet3Tests: XCTestCase {
    func testHelper() async throws {
        SN3Helper.session = IMSessionMock()

        let version = try await SN3Helper.getWebViewVersion()
        let versionInformations = version.split(separator: "-")
        XCTAssertEqual(versionInformations.count, 2)
        let prefix = versionInformations[0]
        XCTAssertEqual(prefix, "1.0.0")
        let suffix = versionInformations[1]
        XCTAssertEqual(suffix, "5644e7a2")
    }

    func testClient() async throws {
        SN3Helper.session = IMSessionMock()
        let version = try await SN3Helper.getWebViewVersion()

        let client = try await SN3Client(webVersion: version, gameServiceToken: "", authorizationStorage: AuthorizationMemoryStorage(), session: IMSessionMock())

        let latestBattleHistories = try await client.getLatestBattleHistories()
        XCTAssertEqual(latestBattleHistories.historyGroups.first!.historyDetails.count, 34)

        let regularBattleHistories = try await client.getRegularBattleHistories()
        XCTAssertEqual(regularBattleHistories.historyGroups.first!.historyDetails.count, 1)

        let bankaraBattleHistories = try await client.getBankaraBattleHistories()
        XCTAssertEqual(bankaraBattleHistories.historyGroups.first!.historyDetails.count, 9)

        let privateBattleHistories = try await client.getPrivateBattleHistories()
        XCTAssertEqual(privateBattleHistories.historyGroups.count, 0)

        let vsHistoryDetail = try await client.getVSHistoryDetail(vsResultId: "VnNIaXN0b3J5RGV0YWlsLXUtcXNxaXB5eWllbGpsbXk0Z3RybW06QkFOS0FSQToyMDIyMTAwNFQxNTQzNDdfOTJiODljYTUtODNlYy00OTBhLTlkZDQtNWMyMjY3ZTkwOTI1")
        XCTAssertEqual(vsHistoryDetail.id.rawValue, "VsHistoryDetail-u-qsqipyyieljlmy4gtrmm:BANKARA:20221004T154347_92b89ca5-83ec-490a-9dd4-5c2267e90925")
        XCTAssertEqual(vsHistoryDetail.playedTime.rawValue, "2022-10-04T15:43:47Z")

        let disconnectionVSHistoryDetail = try await client.getVSHistoryDetail(vsResultId: "disconnection")
        XCTAssertTrue(disconnectionVSHistoryDetail.knockout == nil)

        let coopHistory = try await client.getCoopHistory()
        XCTAssertEqual(coopHistory.historyGroups.first!.historyDetails.count, 3)

        let coopHistoryDetail = try await client.getCoopHistoryDetail(coopHistoryDetailId: "Q29vcEhpc3RvcnlEZXRhaWwtdS1xc3FpcHl5aWVsamxteTRndHJtbToyMDIyMTAwNFQxNDQ4MDlfNGNlYWVjZGMtYzQxOS00YzM3LTg3MjgtMmZlN2IzMTQxZmZh")
        XCTAssertEqual(coopHistoryDetail.id, "Q29vcEhpc3RvcnlEZXRhaWwtdS1xc3FpcHl5aWVsamxteTRndHJtbToyMDIyMTAwNFQxNDQ4MDlfNGNlYWVjZGMtYzQxOS00YzM3LTg3MjgtMmZlN2IzMTQxZmZh")
    }
}
