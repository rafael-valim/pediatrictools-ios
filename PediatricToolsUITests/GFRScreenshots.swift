import XCTest

final class GFRScreenshots: ScreenshotTestCase {
    func testGFREmpty() {
        navigateToTool(id: "gfr")
        takeScreenshot(named: "GFR_Empty", subfolder: "GFR")
    }

    func testGFRFilled() {
        navigateToTool(id: "gfr")
        sleep(1)
        takeScreenshot(named: "GFR_Filled", subfolder: "GFR")
    }
}
