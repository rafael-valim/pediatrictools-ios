import XCTest

final class DosageScreenshots: ScreenshotTestCase {
    func testDosageEmpty() {
        navigateToTool(id: "dosage")
        takeScreenshot(named: "Dosage_Empty", subfolder: "Dosage")
    }

    func testDosageFilled() {
        navigateToTool(id: "dosage")
        let weightField = app.textFields.firstMatch
        weightField.tap()
        weightField.typeText("15")
        // Tap first medication
        app.cells.element(boundBy: 2).tap()
        takeScreenshot(named: "Dosage_Filled", subfolder: "Dosage")
    }
}
