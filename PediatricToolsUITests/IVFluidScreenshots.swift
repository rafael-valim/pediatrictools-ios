import XCTest

final class IVFluidScreenshots: ScreenshotTestCase {
    func testIVFluidEmpty() {
        navigateToTool(id: "ivfluid")
        takeScreenshot(named: "IVFluid_Empty", subfolder: "IVFluid")
    }

    func testIVFluidFilled() {
        navigateToTool(id: "ivfluid")
        let weightField = app.textFields.firstMatch
        weightField.tap()
        weightField.typeText("25")
        takeScreenshot(named: "IVFluid_Filled", subfolder: "IVFluid")
    }

    func testInteraction() {
        navigateToTool(id: "ivfluid")

        // Enter weight = 15 kg → maintenance 1250 mL/day
        let weightField = app.textFields.allElementsBoundByIndex[0]
        weightField.tap()
        weightField.typeText("15")

        // Verify result bar shows mL
        let resultBar = app.staticTexts.containing(NSPredicate(format: "label CONTAINS[c] %@", "mL"))
        XCTAssertTrue(resultBar.firstMatch.waitForExistence(timeout: 3), "Result with mL should appear for weight=15")

        // Tap Reset
        app.navigationBars.buttons["Reset"].tap()

        // Enter weight = 50 kg
        let weightFieldAfterReset = app.textFields.allElementsBoundByIndex[0]
        weightFieldAfterReset.tap()
        weightFieldAfterReset.typeText("50")

        // Verify result still shows mL (different value)
        let resultBarAfter = app.staticTexts.containing(NSPredicate(format: "label CONTAINS[c] %@", "mL"))
        XCTAssertTrue(resultBarAfter.firstMatch.waitForExistence(timeout: 3), "Result with mL should appear for weight=50")
    }
}
