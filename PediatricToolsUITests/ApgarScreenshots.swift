import XCTest

final class ApgarScreenshots: ScreenshotTestCase {
    func testApgarEmpty() {
        navigateToTool(id: "apgar")
        takeScreenshot(named: "Apgar_Empty", subfolder: "Apgar")
    }

    func testApgarFilled() {
        navigateToTool(id: "apgar")

        // Tap all five "2" buttons for a perfect 10/10 score
        let twoButtons = app.buttons.matching(NSPredicate(format: "label BEGINSWITH '2'"))
        for i in 0..<min(twoButtons.count, 5) {
            twoButtons.element(boundBy: i).tap()
        }
        XCTAssertTrue(app.staticTexts["10/10"].waitForExistence(timeout: 2))

        takeScreenshot(named: "Apgar_Filled", subfolder: "Apgar")
    }

    func testApgarDetails() {
        navigateToTool(id: "apgar")
        app.swipeUp()
        let infoButton = app.buttons["tool_info_section"]
        XCTAssertTrue(infoButton.waitForExistence(timeout: 3), "ToolInfoSection button not found")
        infoButton.tap()
        sleep(1)
        takeScreenshot(named: "Apgar_Details", subfolder: "Apgar")
    }

    func testInteraction() {
        navigateToTool(id: "apgar")
        takeScreenshot(named: "Apgar_Interaction_Start", subfolder: "Apgar")

        XCTAssertTrue(app.staticTexts["0/10"].exists)

        let twoButtons = app.buttons.matching(NSPredicate(format: "label BEGINSWITH '2'"))
        if twoButtons.count >= 3 {
            twoButtons.element(boundBy: 0).tap()
            twoButtons.element(boundBy: 1).tap()
            twoButtons.element(boundBy: 2).tap()
        }

        XCTAssertTrue(app.staticTexts["6/10"].waitForExistence(timeout: 2))

        app.navigationBars.buttons["Reset"].tap()

        XCTAssertTrue(app.staticTexts["0/10"].waitForExistence(timeout: 2))
        takeScreenshot(named: "Apgar_Interaction_End", subfolder: "Apgar")
    }
}
