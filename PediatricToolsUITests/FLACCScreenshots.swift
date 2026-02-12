import XCTest

final class FLACCScreenshots: ScreenshotTestCase {
    func testFLACCEmpty() {
        navigateToTool(id: "flacc")
        takeScreenshot(named: "FLACC_Empty", subfolder: "FLACC")
    }

    func testFLACCFilled() {
        navigateToTool(id: "flacc")
        sleep(1)
        takeScreenshot(named: "FLACC_Filled", subfolder: "FLACC")
    }
}
