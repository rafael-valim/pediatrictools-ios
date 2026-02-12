import XCTest

final class QTcScreenshots: ScreenshotTestCase {
    func testQTcEmpty() {
        navigateToTool(id: "qtc")
        takeScreenshot(named: "QTc_Empty", subfolder: "QTc")
    }

    func testQTcFilled() {
        navigateToTool(id: "qtc")
        sleep(1)
        takeScreenshot(named: "QTc_Filled", subfolder: "QTc")
    }
}
