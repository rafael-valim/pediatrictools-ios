import XCTest

final class PRAMScreenshots: ScreenshotTestCase {
    func testPRAMEmpty() {
        navigateToTool(id: "pram")
        takeScreenshot(named: "PRAM_Empty", subfolder: "PRAM")
    }

    func testPRAMFilled() {
        navigateToTool(id: "pram")
        sleep(1)
        takeScreenshot(named: "PRAM_Filled", subfolder: "PRAM")
    }

    func testInteraction() {
        navigateToTool(id: "pram")

        // PRAM has 5 criteria:
        //   O2 Sat (0–2), Suprasternal (0–2), Scalene (0–2),
        //   Air Entry (0–3), Wheezing (0–3)
        // Initial total should be 0/12
        XCTAssertTrue(app.staticTexts["0/12"].exists)

        // Tap score "2" for the first three criteria (O2 Sat, Suprasternal, Scalene)
        let twoButtons = app.buttons.matching(NSPredicate(format: "label BEGINSWITH '2'"))
        if twoButtons.count >= 3 {
            twoButtons.element(boundBy: 0).tap()
            twoButtons.element(boundBy: 1).tap()
            twoButtons.element(boundBy: 2).tap()
        }

        // Total should now be 6/12 (2 + 2 + 2 + 0 + 0)
        XCTAssertTrue(app.staticTexts["6/12"].waitForExistence(timeout: 2))

        // Tap score "3" for Air Entry and Wheezing (the last two criteria)
        // "3" buttons appear in Air Entry and Wheezing rows
        let threeButtons = app.buttons.matching(NSPredicate(format: "label BEGINSWITH '3'"))
        if threeButtons.count >= 2 {
            threeButtons.element(boundBy: 0).tap()
            threeButtons.element(boundBy: 1).tap()
        }

        // Total should now be 12/12 (2 + 2 + 2 + 3 + 3)
        XCTAssertTrue(app.staticTexts["12/12"].waitForExistence(timeout: 2))

        // Reset and verify
        app.navigationBars.buttons["Reset"].tap()
        XCTAssertTrue(app.staticTexts["0/12"].waitForExistence(timeout: 2))
    }
}
