import XCTest

final class BallardScreenshots: ScreenshotTestCase {
    func testBallardEmpty() {
        navigateToTool(id: "ballard")
        takeScreenshot(named: "Ballard_Empty", subfolder: "Ballard")
    }

    func testBallardFilled() {
        navigateToTool(id: "ballard")

        // Tap "4" buttons for the first 3 criteria to get a non-default GA
        let fourButtons = app.buttons.matching(NSPredicate(format: "label BEGINSWITH '4'"))
        if fourButtons.count >= 3 {
            fourButtons.element(boundBy: 0).tap()
            fourButtons.element(boundBy: 1).tap()
            fourButtons.element(boundBy: 2).tap()
        }

        sleep(1)
        takeScreenshot(named: "Ballard_Filled", subfolder: "Ballard")
    }

    func testBallardDetails() {
        navigateToTool(id: "ballard")
        // Ballard has 12 criteria sections — need multiple swipes to reach ToolInfoSection
        let infoButton = app.buttons["tool_info_section"]
        for _ in 0..<10 {
            if infoButton.exists && infoButton.isHittable { break }
            app.swipeUp()
        }
        XCTAssertTrue(infoButton.waitForExistence(timeout: 3), "ToolInfoSection button not found")
        infoButton.tap()
        sleep(1)
        takeScreenshot(named: "Ballard_Details", subfolder: "Ballard")
    }

    func testInteraction() {
        navigateToTool(id: "ballard")
        takeScreenshot(named: "Ballard_Interaction_Start", subfolder: "Ballard")

        let ga24 = app.staticTexts.matching(NSPredicate(format: "label CONTAINS '24'"))
        XCTAssertTrue(ga24.firstMatch.waitForExistence(timeout: 2),
                       "Default all-zero scores should show GA ~24 weeks")

        let fourButtons = app.buttons.matching(NSPredicate(format: "label BEGINSWITH '4'"))

        if fourButtons.count >= 3 {
            fourButtons.element(boundBy: 0).tap()
            fourButtons.element(boundBy: 1).tap()
            fourButtons.element(boundBy: 2).tap()
        }

        let ga28 = app.staticTexts.matching(NSPredicate(format: "label CONTAINS '28'"))
        XCTAssertTrue(ga28.firstMatch.waitForExistence(timeout: 2),
                       "After selecting score 4 for 3 criteria, GA should be ~28 weeks")

        app.navigationBars.buttons["Reset"].tap()

        let ga24After = app.staticTexts.matching(NSPredicate(format: "label CONTAINS '24'"))
        XCTAssertTrue(ga24After.firstMatch.waitForExistence(timeout: 2),
                       "After reset, GA should return to ~24 weeks")
        takeScreenshot(named: "Ballard_Interaction_End", subfolder: "Ballard")
    }
}
