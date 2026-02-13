import XCTest

final class GFRScreenshots: ScreenshotTestCase {
    func testGFREmpty() {
        navigateToTool(id: "gfr")
        takeScreenshot(named: "GFR_Empty", subfolder: "GFR")
    }

    func testGFRFilled() {
        navigateToTool(id: "gfr")
        sleep(1)
        takeScreenshot(named: "GFR_Filled", subfolder: "GFR")
    }

    func testInteraction() {
        navigateToTool(id: "gfr")
        let fields = app.textFields.allElementsBoundByIndex
        guard fields.count >= 2 else { XCTFail("Expected 2 text fields"); return }

        // Enter height=100, creatinine=0.5
        fields[0].tap()
        fields[0].typeText("100")
        fields[1].tap()
        fields[1].typeText("0.5")

        // Result should appear with mL
        let resultText = app.staticTexts.matching(NSPredicate(format: "label CONTAINS 'mL'"))
        XCTAssertTrue(resultText.firstMatch.waitForExistence(timeout: 2))

        // Tap Reset
        app.navigationBars.buttons["Reset"].tap()

        // Enter height=150, creatinine=0.6
        fields[0].tap()
        fields[0].typeText("150")
        fields[1].tap()
        fields[1].typeText("0.6")

        // Result should still show
        XCTAssertTrue(resultText.firstMatch.waitForExistence(timeout: 2))
    }
}
