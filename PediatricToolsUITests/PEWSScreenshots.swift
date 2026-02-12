import XCTest

final class PEWSScreenshots: ScreenshotTestCase {
    func testPEWSEmpty() {
        navigateToTool(id: "pews")
        takeScreenshot(named: "PEWS_Empty", subfolder: "PEWS")
    }

    func testPEWSFilled() {
        navigateToTool(id: "pews")
        sleep(1)
        takeScreenshot(named: "PEWS_Filled", subfolder: "PEWS")
    }
}
