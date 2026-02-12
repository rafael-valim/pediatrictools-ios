import XCTest

final class ApgarScreenshots: ScreenshotTestCase {
    func testApgarEmpty() {
        navigateToTool(id: "apgar")
        takeScreenshot(named: "Apgar_Empty", subfolder: "Apgar")
    }

    func testApgarFilled() {
        navigateToTool(id: "apgar")
        sleep(1)
        takeScreenshot(named: "Apgar_Filled", subfolder: "Apgar")
    }
}
