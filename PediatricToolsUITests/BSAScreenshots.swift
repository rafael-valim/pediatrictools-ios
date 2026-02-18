import XCTest

final class BSAScreenshots: ScreenshotTestCase {
    func testBSAEmpty() {
        navigateToTool(id: "bsa")
        takeScreenshot(named: "BSA_Empty", subfolder: "BSA")
    }

    func testBSAFilled() {
        navigateToTool(id: "bsa")
        let fields = app.textFields.allElementsBoundByIndex
        if fields.count >= 2 {
            fields[0].tap()
            fields[0].typeText("25")
            fields[1].tap()
            fields[1].typeText("120")
        }
        takeScreenshot(named: "BSA_Filled", subfolder: "BSA")
    }

    func testBSADetails() {
        navigateToTool(id: "bsa")
        let infoButton = app.buttons["tool_info_section"]
        for _ in 0..<3 {
            if infoButton.exists && infoButton.isHittable { break }
            app.swipeUp()
        }
        XCTAssertTrue(infoButton.waitForExistence(timeout: 3), "ToolInfoSection button not found")
        infoButton.tap()
        sleep(1)
        takeScreenshot(named: "BSA_Details", subfolder: "BSA")
    }

    func testInteraction() {
        navigateToTool(id: "bsa")
        takeScreenshot(named: "BSA_Interaction_Start", subfolder: "BSA")
        let fields = app.textFields.allElementsBoundByIndex
        guard fields.count >= 2 else { XCTFail("Expected 2 text fields"); return }

        fields[0].tap()
        fields[0].typeText("70")
        fields[1].tap()
        fields[1].typeText("170")

        // Result should appear with m²
        let resultText = app.staticTexts.matching(NSPredicate(format: "label CONTAINS 'm²'"))
        XCTAssertTrue(resultText.firstMatch.waitForExistence(timeout: 2))

        // Tap Reset
        app.navigationBars.buttons["Reset"].tap()

        // Fields should be cleared - enter new values
        fields[0].tap()
        fields[0].typeText("30")
        fields[1].tap()
        fields[1].typeText("130")

        // Result should still show
        XCTAssertTrue(resultText.firstMatch.waitForExistence(timeout: 2))
        takeScreenshot(named: "BSA_Interaction_End", subfolder: "BSA")
    }
}
