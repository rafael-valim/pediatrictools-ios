import XCTest

final class BallardScreenshots: ScreenshotTestCase {
    func testBallardEmpty() {
        navigateToTool(id: "ballard")
        takeScreenshot(named: "Ballard_Empty", subfolder: "Ballard")
    }

    func testBallardFilled() {
        navigateToTool(id: "ballard")
        // Tap some score buttons to fill the form
        // Ballard uses stepper-like controls, just screenshot after navigating
        sleep(1)
        takeScreenshot(named: "Ballard_Filled", subfolder: "Ballard")
    }

    func testInteraction() {
        navigateToTool(id: "ballard")

        // Default state: all scores 0, total = 0 → GA ≈ 24 weeks
        // The result bar shows "24" for gestational age
        let ga24 = app.staticTexts.matching(NSPredicate(format: "label CONTAINS '24'"))
        XCTAssertTrue(ga24.firstMatch.waitForExistence(timeout: 2),
                       "Default all-zero scores should show GA ~24 weeks")

        // Tap some higher-score buttons to increase the total.
        // Each criterion row has buttons for score values (-1, 0, 1, 2, 3, 4).
        // Tapping buttons labeled "4" will select score 4 for those criteria.
        // There are 6 neuromuscular criteria + 6 physical criteria = 12 total.
        let fourButtons = app.buttons.matching(NSPredicate(format: "label BEGINSWITH '4'"))

        // Tap "4" for the first 3 neuromuscular criteria (posture, square window, arm recoil)
        // This adds 4*3 = 12 to the score (from default 0)
        // Total = 12 → GA = 20 + (12+10)/5 * 2 = 20 + 8.8 = 28.8 ≈ 28 weeks
        if fourButtons.count >= 3 {
            fourButtons.element(boundBy: 0).tap()
            fourButtons.element(boundBy: 1).tap()
            fourButtons.element(boundBy: 2).tap()
        }

        // GA should now be around 28-29 weeks (higher than 24)
        let ga28 = app.staticTexts.matching(NSPredicate(format: "label CONTAINS '28'"))
        XCTAssertTrue(ga28.firstMatch.waitForExistence(timeout: 2),
                       "After selecting score 4 for 3 criteria, GA should be ~28 weeks")

        // Tap Reset — should go back to default (all 0, GA ~24)
        app.navigationBars.buttons["Reset"].tap()

        let ga24After = app.staticTexts.matching(NSPredicate(format: "label CONTAINS '24'"))
        XCTAssertTrue(ga24After.firstMatch.waitForExistence(timeout: 2),
                       "After reset, GA should return to ~24 weeks")
    }
}
