import XCTest
@testable import InkMoya
@testable import SplatNet3
@testable import SplatNet3API
@testable import SplatNet3Helper

final class SplatNet3Tests: XCTestCase {
    func testHelper() async throws {
        // SN3Helper.session = IMSessionMock()

        let webViewData = try await SN3Helper.getWebViewData()
        let versionInformations = webViewData.version.split(separator: "-")
        XCTAssertEqual(versionInformations.count, 2)
        let prefix = versionInformations[0]
        XCTAssertEqual(prefix.split(separator: ".").count, 3)
        let suffix = versionInformations[1]
        XCTAssertEqual(suffix.count, 8)

        let graphQLAPIs = webViewData.graphql.hashMap
        XCTAssert(graphQLAPIs.keys.count > 0)
    }

    func testClientInit() async throws {
        SplatNet3.setLogLevel(.trace)
        let webviewData = try await SN3Helper.getWebViewData()
        let _ = try await SN3Client(webVersion: webviewData.version, graphQLHashMap: webviewData.graphql.hashMap, gameServiceToken: "", session: IMSessionMock())
    }

    func testClient() async throws {
        SplatNet3.setLogLevel(.trace)

        SN3Helper.session = IMSessionMock()

        let webviewData = try await SN3Helper.getWebViewData()
        let client = try await SN3Client(webVersion: webviewData.version, graphQLHashMap: webviewData.graphql.hashMap, gameServiceToken: "", session: IMSessionMock())

        let latestBattleHistories = try await client.graphQL(.latestBattleHistories)
        XCTAssertEqual(latestBattleHistories.historyGroups.first!.historyDetails.count, 34)

        let regularBattleHistories = try await client.graphQL(.regularBattleHistories)
        XCTAssertEqual(regularBattleHistories.historyGroups.first!.historyDetails.count, 1)

        let bankaraBattleHistories = try await client.graphQL(.bankaraBattleHistories)
        XCTAssertEqual(bankaraBattleHistories.historyGroups.first!.historyDetails.count, 9)

        let privateBattleHistories = try await client.graphQL(.privateBattleHistories)
        XCTAssertEqual(privateBattleHistories.historyGroups.count, 0)

        let vsHistoryDetail = try await client.graphQL(.vsHistoryDetail(id: "VnNIaXN0b3J5RGV0YWlsLXUtcXNxaXB5eWllbGpsbXk0Z3RybW06QkFOS0FSQToyMDIyMTAwNFQxNTQzNDdfOTJiODljYTUtODNlYy00OTBhLTlkZDQtNWMyMjY3ZTkwOTI1"))
        XCTAssertEqual(vsHistoryDetail.id.id, "VsHistoryDetail-u-qsqipyyieljlmy4gtrmm:BANKARA:20221004T154347_92b89ca5-83ec-490a-9dd4-5c2267e90925")
        XCTAssertEqual(vsHistoryDetail.playedTime.rawValue, "2022-10-04T15:43:47Z")

        let disconnectionVSHistoryDetail = try await client.graphQL(.vsHistoryDetail(id: "disconnection"))
        XCTAssertTrue(disconnectionVSHistoryDetail.knockout == nil)

        let coopHistory = try await client.graphQL(.coopHistory)
        XCTAssertEqual(coopHistory.historyGroups.first!.historyDetails.count, 3)

        let coopHistoryDetail = try await client.graphQL(.coopHistoryDetail(id: "Q29vcEhpc3RvcnlEZXRhaWwtdS1xc3FpcHl5aWVsamxteTRndHJtbToyMDIyMTAwNFQxNDQ4MDlfNGNlYWVjZGMtYzQxOS00YzM3LTg3MjgtMmZlN2IzMTQxZmZh"))
        XCTAssertEqual(coopHistoryDetail.id, "Q29vcEhpc3RvcnlEZXRhaWwtdS1xc3FpcHl5aWVsamxteTRndHJtbToyMDIyMTAwNFQxNDQ4MDlfNGNlYWVjZGMtYzQxOS00YzM3LTg3MjgtMmZlN2IzMTQxZmZh")
    }
}
