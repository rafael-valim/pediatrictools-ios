import XCTest

final class PEWSScreenshots: ScreenshotTestCase {
    func testPEWSEmpty() {
        navigateToTool(id: "pews")
        takeScreenshot(named: "PEWS_Empty", subfolder: "PEWS")
    }

    func testPEWSFilled() {
        navigateToTool(id: "pews")
        sleep(1)
        takeScreenshot(named: "PEWS_Filled", subfolder: "PEWS")
    }

    func testInteraction() {
        navigateToTool(id: "pews")
        takeScreenshot(named: "PEWS_Interaction_Start", subfolder: "PEWS")

        // PEWS has 3 criteria (Behavior, Cardiovascular, Respiratory),
        // each with scores 0–3. Initial total should be 0/9.
        XCTAssertTrue(app.staticTexts["0/9"].exists)

        // Tap score "2" buttons for the first two criteria
        let twoButtons = app.buttons.matching(NSPredicate(format: "label BEGINSWITH '2'"))
        if twoButtons.count >= 2 {
            twoButtons.element(boundBy: 0).tap()
            twoButtons.element(boundBy: 1).tap()
        }

        // Total should now be 4/9 (2 + 2 + 0)
        XCTAssertTrue(app.staticTexts["4/9"].waitForExistence(timeout: 2))

        // Tap score "3" for the third criterion
        let threeButtons = app.buttons.matching(NSPredicate(format: "label BEGINSWITH '3'"))
        if threeButtons.count >= 1 {
            threeButtons.element(boundBy: threeButtons.count - 1).tap()
        }

        // Total should now be 7/9 (2 + 2 + 3)
        XCTAssertTrue(app.staticTexts["7/9"].waitForExistence(timeout: 2))

        // Reset and verify
        app.navigationBars.buttons["Reset"].tap()
        XCTAssertTrue(app.staticTexts["0/9"].waitForExistence(timeout: 2))
        takeScreenshot(named: "PEWS_Interaction_End", subfolder: "PEWS")
    }
}
