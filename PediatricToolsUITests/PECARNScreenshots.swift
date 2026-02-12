import XCTest

final class PECARNScreenshots: ScreenshotTestCase {
    func testPECARNEmpty() {
        navigateToTool(id: "pecarn")
        takeScreenshot(named: "PECARN_Empty", subfolder: "PECARN")
    }

    func testPECARNFilled() {
        navigateToTool(id: "pecarn")
        sleep(1)
        takeScreenshot(named: "PECARN_Filled", subfolder: "PECARN")
    }
}
