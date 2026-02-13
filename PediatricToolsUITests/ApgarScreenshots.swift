import XCTest

final class ApgarScreenshots: ScreenshotTestCase {
    func testApgarEmpty() {
        navigateToTool(id: "apgar")
        takeScreenshot(named: "Apgar_Empty", subfolder: "Apgar")
    }

    func testApgarFilled() {
        navigateToTool(id: "apgar")
        sleep(1)
        takeScreenshot(named: "Apgar_Filled", subfolder: "Apgar")
    }

    func testInteraction() {
        navigateToTool(id: "apgar")
        takeScreenshot(named: "Apgar_Interaction_Start", subfolder: "Apgar")

        // Apgar has 5 criteria, each with scores 0, 1, 2
        // Initial total should be 0/10
        XCTAssertTrue(app.staticTexts["0/10"].exists)

        // Tap score "2" buttons — there should be one per criterion
        // Button labels begin with the score digit followed by description text
        let twoButtons = app.buttons.matching(NSPredicate(format: "label BEGINSWITH '2'"))
        if twoButtons.count >= 3 {
            twoButtons.element(boundBy: 0).tap()
            twoButtons.element(boundBy: 1).tap()
            twoButtons.element(boundBy: 2).tap()
        }

        // After tapping three "2" buttons the total should be 6/10
        XCTAssertTrue(app.staticTexts["6/10"].waitForExistence(timeout: 2))

        // Tap Reset to return to default
        app.navigationBars.buttons["Reset"].tap()

        // Score should be back to 0/10
        XCTAssertTrue(app.staticTexts["0/10"].waitForExistence(timeout: 2))
        takeScreenshot(named: "Apgar_Interaction_End", subfolder: "Apgar")
    }
}
