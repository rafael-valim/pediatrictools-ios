import XCTest

final class BilirubinScreenshots: ScreenshotTestCase {
    /// Wait for at least 2 text fields and return them, or fail.
    private func waitForTextFields() -> [XCUIElement]? {
        // On iPad, form layout may delay field availability — wait and retry
        for _ in 0..<5 {
            let fields = app.textFields.allElementsBoundByIndex
            if fields.count >= 2 { return fields }
            sleep(1)
        }
        XCTFail("Expected at least 2 text fields")
        return nil
    }

    func testBilirubinEmpty() {
        navigateToTool(id: "bilirubin")
        takeScreenshot(named: "Bilirubin_Empty", subfolder: "Bilirubin")
    }

    func testBilirubinFilled() {
        navigateToTool(id: "bilirubin")
        guard let fields = waitForTextFields() else { return }

        // Enter TSB = 15, postnatal age = 48 hours
        fields[0].tap(); fields[0].typeText("15")
        fields[1].tap(); fields[1].typeText("48")
        app.swipeDown()

        let resultText = app.staticTexts.matching(NSPredicate(format: "label CONTAINS 'mg/dL'"))
        XCTAssertTrue(resultText.firstMatch.waitForExistence(timeout: 3),
                       "Result bar should show threshold values in mg/dL")

        takeScreenshot(named: "Bilirubin_Filled", subfolder: "Bilirubin")
    }

    func testBilirubinDetails() {
        navigateToTool(id: "bilirubin")
        app.swipeUp()
        let infoButton = app.buttons["tool_info_section"]
        XCTAssertTrue(infoButton.waitForExistence(timeout: 3), "ToolInfoSection button not found")
        infoButton.tap()
        sleep(1)
        takeScreenshot(named: "Bilirubin_Details", subfolder: "Bilirubin")
    }

    func testInteraction() {
        navigateToTool(id: "bilirubin")
        takeScreenshot(named: "Bilirubin_Interaction_Start", subfolder: "Bilirubin")
        guard let fields = waitForTextFields() else { return }

        fields[0].tap(); fields[0].typeText("15")
        fields[1].tap(); fields[1].typeText("48")
        app.swipeDown()

        let resultText = app.staticTexts.matching(NSPredicate(format: "label CONTAINS 'mg/dL'"))
        XCTAssertTrue(resultText.firstMatch.waitForExistence(timeout: 3),
                       "Result bar should show threshold values in mg/dL")

        app.navigationBars.buttons["Reset"].tap()

        fields[0].tap(); fields[0].typeText("5")
        fields[1].tap(); fields[1].typeText("24")
        app.swipeDown()

        XCTAssertTrue(resultText.firstMatch.waitForExistence(timeout: 3),
                       "Result bar should reappear with new values")
        takeScreenshot(named: "Bilirubin_Interaction_End", subfolder: "Bilirubin")
    }
}
