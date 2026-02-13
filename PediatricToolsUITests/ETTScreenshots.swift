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

    func testInteraction() {
        navigateToTool(id: "ett")

        // Enter age = 4 → uncuffed 5.0 (formats as "5"), cuffed 4.5
        let ageField = app.textFields.firstMatch
        ageField.tap()
        ageField.typeText("4\n")

        // Verify result appears — cuffed size 4.5 is a reliable match
        let resultBar = app.staticTexts.matching(NSPredicate(format: "label == '4.5'"))
        XCTAssertTrue(resultBar.firstMatch.waitForExistence(timeout: 3), "Cuffed size 4.5 should appear for age=4")

        // Tap Reset
        app.navigationBars.buttons["Reset"].tap()

        // Enter age = 8 → uncuffed 6 (formats as "6"), cuffed 5.5
        ageField.tap()
        ageField.typeText("8\n")

        // Verify result changes — cuffed size 5.5
        let resultBarAfter = app.staticTexts.matching(NSPredicate(format: "label == '5.5'"))
        XCTAssertTrue(resultBarAfter.firstMatch.waitForExistence(timeout: 3), "Cuffed size 5.5 should appear for age=8")
    }
}
