import XCTest

final class PECARNScreenshots: ScreenshotTestCase {
    func testPECARNEmpty() {
        navigateToTool(id: "pecarn")
        takeScreenshot(named: "PECARN_Empty", subfolder: "PECARN")
    }

    func testPECARNFilled() {
        navigateToTool(id: "pecarn")
        sleep(1)
        takeScreenshot(named: "PECARN_Filled", subfolder: "PECARN")
    }

    func testPECARNDetails() {
        navigateToTool(id: "pecarn")
        let infoButton = app.buttons["tool_info_section"]
        for _ in 0..<5 {
            if infoButton.exists && infoButton.isHittable { break }
            app.swipeUp()
        }
        XCTAssertTrue(infoButton.waitForExistence(timeout: 3), "ToolInfoSection button not found")
        infoButton.tap()
        sleep(1)
        takeScreenshot(named: "PECARN_Details", subfolder: "PECARN")
    }

    func testInteraction() {
        navigateToTool(id: "pecarn")
        takeScreenshot(named: "PECARN_Interaction_Start", subfolder: "PECARN")

        // Default: no criteria selected → Very Low Risk
        let veryLowPredicate = NSPredicate(format: "label CONTAINS[c] 'Very Low'")
        XCTAssertTrue(app.staticTexts.matching(veryLowPredicate).firstMatch.waitForExistence(timeout: 3),
                       "Initial state should show Very Low Risk")

        // Toggle the first criterion switch using coordinate tap on right side
        let firstSwitch = app.switches.element(boundBy: 0)
        XCTAssertTrue(firstSwitch.waitForExistence(timeout: 3), "Expected toggle switch")
        // Tap the right side of the switch to ensure we hit the toggle control
        firstSwitch.coordinate(withNormalizedOffset: CGVector(dx: 0.95, dy: 0.5)).tap()

        let higherPredicate = NSPredicate(format: "label CONTAINS[c] 'Higher'")
        XCTAssertTrue(app.staticTexts.matching(higherPredicate).firstMatch.waitForExistence(timeout: 3),
                       "Toggling AMS should show Higher Risk")

        // Tap Reset
        app.navigationBars.buttons["Reset"].tap()
        XCTAssertTrue(app.staticTexts.matching(veryLowPredicate).firstMatch.waitForExistence(timeout: 3),
                       "After reset should return to Very Low Risk")
        takeScreenshot(named: "PECARN_Interaction_End", subfolder: "PECARN")
    }
}
