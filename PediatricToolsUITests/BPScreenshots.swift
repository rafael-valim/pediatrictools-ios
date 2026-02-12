import XCTest

final class BPScreenshots: ScreenshotTestCase {
    func testBPEmpty() {
        navigateToTool(id: "bp")
        takeScreenshot(named: "BP_Empty", subfolder: "BP")
    }

    func testBPFilled() {
        navigateToTool(id: "bp")
        sleep(1)
        takeScreenshot(named: "BP_Filled", subfolder: "BP")
    }
}
