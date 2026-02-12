import XCTest

final class ETTScreenshots: ScreenshotTestCase {
    func testETTEmpty() {
        navigateToTool(id: "ett")
        takeScreenshot(named: "ETT_Empty", subfolder: "ETT")
    }

    func testETTFilled() {
        navigateToTool(id: "ett")
        let ageField = app.textFields.firstMatch
        ageField.tap()
        ageField.typeText("6")
        takeScreenshot(named: "ETT_Filled", subfolder: "ETT")
    }
}
