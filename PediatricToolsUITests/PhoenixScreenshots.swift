import XCTest

final class PhoenixScreenshots: ScreenshotTestCase {
    func testPhoenixEmpty() {
        navigateToTool(id: "phoenix")
        takeScreenshot(named: "Phoenix_Empty", subfolder: "Phoenix")
    }

    func testPhoenixFilled() {
        navigateToTool(id: "phoenix")
        sleep(1)
        takeScreenshot(named: "Phoenix_Filled", subfolder: "Phoenix")
    }

    func testInteraction() {
        navigateToTool(id: "phoenix")
        takeScreenshot(named: "Phoenix_Interaction_Start", subfolder: "Phoenix")

        // Initial state: total 0/13
        XCTAssertTrue(app.staticTexts["0/13"].waitForExistence(timeout: 3), "Initial total should be 0/13")

        // Enter PaO2/FiO2 = 80 (score 2 for resp) and dismiss keyboard
        let firstField = app.textFields.firstMatch
        firstField.tap()
        firstField.typeText("80")
        // Dismiss keyboard by tapping Done button in keyboard toolbar
        let doneButton = app.toolbars.buttons.element(boundBy: 1)
        if doneButton.waitForExistence(timeout: 2) {
            doneButton.tap()
        }

        // Toggle invasive ventilation using coordinate tap on right side
        let ventToggle = app.switches.element(boundBy: 0)
        if ventToggle.waitForExistence(timeout: 3) {
            ventToggle.coordinate(withNormalizedOffset: CGVector(dx: 0.95, dy: 0.5)).tap()
        }

        // Respiratory score should now be 3, total 3/13
        XCTAssertTrue(app.staticTexts["3/13"].waitForExistence(timeout: 3),
                       "Total should be 3/13 with resp score 3")

        // Tap Reset
        app.navigationBars.buttons["Reset"].tap()

        // Should go back to 0/13
        XCTAssertTrue(app.staticTexts["0/13"].waitForExistence(timeout: 3),
                       "After reset total should be 0/13")
        takeScreenshot(named: "Phoenix_Interaction_End", subfolder: "Phoenix")
    }
}
