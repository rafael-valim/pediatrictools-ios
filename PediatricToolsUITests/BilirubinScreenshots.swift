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

    func testInteraction() {
        navigateToTool(id: "bilirubin")
        takeScreenshot(named: "Bilirubin_Interaction_Start", subfolder: "Bilirubin")
        let fields = app.textFields.allElementsBoundByIndex
        guard fields.count >= 2 else { XCTFail("Expected at least 2 text fields"); return }

        // Enter TSB = 15, postnatal age = 48 hours
        fields[0].tap()
        fields[0].typeText("15")
        fields[1].tap()
        fields[1].typeText("48")
        // Dismiss keyboard
        app.swipeDown()

        // Result bar should appear with mg/dL thresholds
        let resultText = app.staticTexts.matching(NSPredicate(format: "label CONTAINS 'mg/dL'"))
        XCTAssertTrue(resultText.firstMatch.waitForExistence(timeout: 3),
                       "Result bar should show threshold values in mg/dL")

        // Tap Reset
        app.navigationBars.buttons["Reset"].tap()

        // Enter different values
        fields[0].tap()
        fields[0].typeText("5")
        fields[1].tap()
        fields[1].typeText("24")
        app.swipeDown()

        // Result bar should reappear
        XCTAssertTrue(resultText.firstMatch.waitForExistence(timeout: 3),
                       "Result bar should reappear with new values")
        takeScreenshot(named: "Bilirubin_Interaction_End", subfolder: "Bilirubin")
    }
}
