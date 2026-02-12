import XCTest

final class DehydrationScreenshots: ScreenshotTestCase {
    func testDehydrationEmpty() {
        navigateToTool(id: "dehydration")
        takeScreenshot(named: "Dehydration_Empty", subfolder: "Dehydration")
    }

    func testDehydrationFilled() {
        navigateToTool(id: "dehydration")
        let weightField = app.textFields.firstMatch
        weightField.tap()
        weightField.typeText("10")
        takeScreenshot(named: "Dehydration_Filled", subfolder: "Dehydration")
    }
}
