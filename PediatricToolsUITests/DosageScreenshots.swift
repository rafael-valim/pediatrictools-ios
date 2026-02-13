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

    func testInteraction() {
        navigateToTool(id: "dosage")
        takeScreenshot(named: "Dosage_Interaction_Start", subfolder: "Dosage")

        // Enter weight = 10 kg and dismiss keyboard
        let weightField = app.textFields.firstMatch
        weightField.tap()
        weightField.typeText("10\n")
        // Swipe down to dismiss keyboard if still visible
        app.swipeDown()

        // Tap second medication cell (first is weight row at index 0, meds start at 1)
        let medicationCell = app.cells.element(boundBy: 1)
        XCTAssertTrue(medicationCell.waitForExistence(timeout: 3), "Medication cell should exist")
        medicationCell.tap()

        // Verify result bar appears with dose info (contains "mg")
        let resultText = app.staticTexts.matching(NSPredicate(format: "label CONTAINS[c] 'mg'"))
        XCTAssertTrue(resultText.firstMatch.waitForExistence(timeout: 3), "Result with mg should appear")

        // Tap Reset
        app.navigationBars.buttons["Reset"].tap()
        takeScreenshot(named: "Dosage_Interaction_End", subfolder: "Dosage")
    }
}
