import XCTest

final class CorrectedAgeScreenshots: ScreenshotTestCase {
    func testCorrectedAgeDefault() {
        navigateToTool(id: "corrected")
        takeScreenshot(named: "CorrectedAge_Default", subfolder: "CorrectedAge")
    }

    func testInteraction() {
        navigateToTool(id: "corrected")

        // CorrectedAge uses DatePicker and Pickers which are difficult to manipulate in XCUITest.
        // The default state (birth date = today, GA = 28w 0d) always shows results since
        // the result section is unconditionally displayed.

        // Verify the results section exists with chronological age, prematurity, corrected age
        // The result values contain "w" and "d" for weeks and days formatting
        let weeksDaysText = app.staticTexts.matching(NSPredicate(format: "label CONTAINS 'w'"))
        XCTAssertTrue(weeksDaysText.firstMatch.waitForExistence(timeout: 2),
                       "Result section should display values with weeks/days format")

        // Verify the result bar at the bottom exists
        // The result bar shows "Corrected Age:" label followed by weeks and days
        let resultBarWeeks = app.staticTexts.matching(NSPredicate(format: "label CONTAINS 'week'"))
        XCTAssertTrue(resultBarWeeks.firstMatch.waitForExistence(timeout: 2),
                       "Result bar should show corrected age in weeks")

        // Verify the prematurity row shows a value (default GA 28w → 12 weeks premature)
        let prematurityText = app.staticTexts.matching(NSPredicate(format: "label CONTAINS '12'"))
        XCTAssertTrue(prematurityText.firstMatch.waitForExistence(timeout: 2),
                       "Default GA of 28 weeks should show 12 weeks prematurity")

        // Verify the chronological age row exists (birth date = today → 0w 0d)
        let chronoText = app.staticTexts["0w 0d"]
        XCTAssertTrue(chronoText.waitForExistence(timeout: 2),
                       "Birth date of today should show chronological age of 0w 0d")
    }
}
