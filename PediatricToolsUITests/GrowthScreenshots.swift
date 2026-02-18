import XCTest

final class GrowthScreenshots: ScreenshotTestCase {
    func testGrowthEmpty() {
        navigateToTool(id: "growth")
        takeScreenshot(named: "Growth_Empty", subfolder: "Growth")
    }

    func testGrowthFilled() {
        navigateToTool(id: "growth")
        let fields = app.textFields.allElementsBoundByIndex
        if fields.count >= 2 {
            fields[0].tap()
            fields[0].typeText("6")
            fields[1].tap()
            fields[1].typeText("7.5")
        }
        takeScreenshot(named: "Growth_Filled", subfolder: "Growth")
    }

    func testGrowthDetails() {
        navigateToTool(id: "growth")
        let infoButton = app.buttons["tool_info_section"]
        for _ in 0..<5 {
            if infoButton.exists && infoButton.isHittable { break }
            app.swipeUp()
        }
        XCTAssertTrue(infoButton.waitForExistence(timeout: 3), "ToolInfoSection button not found")
        infoButton.tap()
        sleep(1)
        takeScreenshot(named: "Growth_Details", subfolder: "Growth")
    }

    func testInteraction() {
        navigateToTool(id: "growth")
        takeScreenshot(named: "Growth_Interaction_Start", subfolder: "Growth")

        let fields = app.textFields.allElementsBoundByIndex

        // Enter age = 6 months, value = 7.5
        fields[0].tap()
        fields[0].typeText("6")
        fields[1].tap()
        fields[1].typeText("7.5")

        // Verify result appears (look for percentile indicator)
        let resultPercent = app.staticTexts.containing(NSPredicate(format: "label CONTAINS[c] %@", "%"))
        let resultPercentile = app.staticTexts.containing(NSPredicate(format: "label CONTAINS[c] %@", "percentile"))
        let hasResult = resultPercent.firstMatch.waitForExistence(timeout: 3)
            || resultPercentile.firstMatch.waitForExistence(timeout: 1)
        XCTAssertTrue(hasResult, "Result with % or percentile should appear for age=6, value=7.5")

        // Tap Reset
        app.navigationBars.buttons["Reset"].tap()

        // Enter different values: age = 12, value = 10
        let fieldsAfterReset = app.textFields.allElementsBoundByIndex
        fieldsAfterReset[0].tap()
        fieldsAfterReset[0].typeText("12")
        fieldsAfterReset[1].tap()
        fieldsAfterReset[1].typeText("10")

        // Verify result appears again
        let resultAfter = app.staticTexts.containing(NSPredicate(format: "label CONTAINS[c] %@", "%"))
        let resultAfterPercentile = app.staticTexts.containing(NSPredicate(format: "label CONTAINS[c] %@", "percentile"))
        let hasResultAfter = resultAfter.firstMatch.waitForExistence(timeout: 3)
            || resultAfterPercentile.firstMatch.waitForExistence(timeout: 1)
        XCTAssertTrue(hasResultAfter, "Result with % or percentile should appear for age=12, value=10")
        takeScreenshot(named: "Growth_Interaction_End", subfolder: "Growth")
    }
}
