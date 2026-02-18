import XCTest

final class DehydrationScreenshots: ScreenshotTestCase {
    func testDehydrationEmpty() {
        navigateToTool(id: "dehydration")
        takeScreenshot(named: "Dehydration_Empty", subfolder: "Dehydration")
    }

    func testDehydrationFilled() {
        navigateToTool(id: "dehydration")
        let weightField = app.textFields.firstMatch
        weightField.tap()
        weightField.typeText("10")
        takeScreenshot(named: "Dehydration_Filled", subfolder: "Dehydration")
    }

    func testDehydrationDetails() {
        navigateToTool(id: "dehydration")
        let infoButton = app.buttons["tool_info_section"]
        for _ in 0..<5 {
            if infoButton.exists && infoButton.isHittable { break }
            app.swipeUp()
        }
        XCTAssertTrue(infoButton.waitForExistence(timeout: 3), "ToolInfoSection button not found")
        infoButton.tap()
        sleep(1)
        takeScreenshot(named: "Dehydration_Details", subfolder: "Dehydration")
    }

    func testInteraction() {
        navigateToTool(id: "dehydration")
        takeScreenshot(named: "Dehydration_Interaction_Start", subfolder: "Dehydration")

        // Enter weight = 10 kg
        let weightField = app.textFields.allElementsBoundByIndex[0]
        weightField.tap()
        weightField.typeText("10")

        // Verify result bar shows mL
        let resultBar = app.staticTexts.containing(NSPredicate(format: "label CONTAINS[c] %@", "mL"))
        XCTAssertTrue(resultBar.firstMatch.waitForExistence(timeout: 3), "Result with mL should appear for weight=10")

        // Tap Reset
        app.navigationBars.buttons["Reset"].tap()

        // Enter weight = 25 kg
        let weightFieldAfterReset = app.textFields.allElementsBoundByIndex[0]
        weightFieldAfterReset.tap()
        weightFieldAfterReset.typeText("25")

        // Verify result appears
        let resultBarAfter = app.staticTexts.containing(NSPredicate(format: "label CONTAINS[c] %@", "mL"))
        XCTAssertTrue(resultBarAfter.firstMatch.waitForExistence(timeout: 3), "Result with mL should appear for weight=25")
        takeScreenshot(named: "Dehydration_Interaction_End", subfolder: "Dehydration")
    }
}
