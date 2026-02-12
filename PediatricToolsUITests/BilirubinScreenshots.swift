import XCTest

final class BilirubinScreenshots: ScreenshotTestCase {
    func testBilirubinEmpty() {
        navigateToTool(id: "bilirubin")
        takeScreenshot(named: "Bilirubin_Empty", subfolder: "Bilirubin")
    }

    func testBilirubinFilled() {
        navigateToTool(id: "bilirubin")
        sleep(1)
        takeScreenshot(named: "Bilirubin_Filled", subfolder: "Bilirubin")
    }
}
