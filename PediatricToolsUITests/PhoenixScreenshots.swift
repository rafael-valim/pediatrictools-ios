import XCTest

final class PhoenixScreenshots: ScreenshotTestCase {
    func testPhoenixEmpty() {
        navigateToTool(id: "phoenix")
        takeScreenshot(named: "Phoenix_Empty", subfolder: "Phoenix")
    }

    func testPhoenixFilled() {
        navigateToTool(id: "phoenix")
        sleep(1)
        takeScreenshot(named: "Phoenix_Filled", subfolder: "Phoenix")
    }
}
