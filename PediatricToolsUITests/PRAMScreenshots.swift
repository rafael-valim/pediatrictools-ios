import XCTest

final class PRAMScreenshots: ScreenshotTestCase {
    func testPRAMEmpty() {
        navigateToTool(id: "pram")
        takeScreenshot(named: "PRAM_Empty", subfolder: "PRAM")
    }

    func testPRAMFilled() {
        navigateToTool(id: "pram")
        sleep(1)
        takeScreenshot(named: "PRAM_Filled", subfolder: "PRAM")
    }
}
