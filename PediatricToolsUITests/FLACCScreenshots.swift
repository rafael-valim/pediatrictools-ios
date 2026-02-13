import XCTest

final class FLACCScreenshots: ScreenshotTestCase {
    func testFLACCEmpty() {
        navigateToTool(id: "flacc")
        takeScreenshot(named: "FLACC_Empty", subfolder: "FLACC")
    }

    func testFLACCFilled() {
        navigateToTool(id: "flacc")
        sleep(1)
        takeScreenshot(named: "FLACC_Filled", subfolder: "FLACC")
    }

    func testInteraction() {
        navigateToTool(id: "flacc")

        // FLACC has 5 criteria (Face, Legs, Activity, Cry, Consolability),
        // each with scores 0–2. Initial total should be 0/10.
        XCTAssertTrue(app.staticTexts["0/10"].exists)

        // Tap score "1" buttons for the first three criteria
        let oneButtons = app.buttons.matching(NSPredicate(format: "label BEGINSWITH '1'"))
        if oneButtons.count >= 3 {
            oneButtons.element(boundBy: 0).tap()
            oneButtons.element(boundBy: 1).tap()
            oneButtons.element(boundBy: 2).tap()
        }

        // Total should now be 3/10 (1 + 1 + 1 + 0 + 0)
        XCTAssertTrue(app.staticTexts["3/10"].waitForExistence(timeout: 2))

        // Tap score "2" for the fourth and fifth criteria
        let twoButtons = app.buttons.matching(NSPredicate(format: "label BEGINSWITH '2'"))
        if twoButtons.count >= 5 {
            twoButtons.element(boundBy: 3).tap()
            twoButtons.element(boundBy: 4).tap()
        }

        // Total should now be 7/10 (1 + 1 + 1 + 2 + 2)
        XCTAssertTrue(app.staticTexts["7/10"].waitForExistence(timeout: 2))

        // Reset and verify
        app.navigationBars.buttons["Reset"].tap()
        XCTAssertTrue(app.staticTexts["0/10"].waitForExistence(timeout: 2))
    }
}
