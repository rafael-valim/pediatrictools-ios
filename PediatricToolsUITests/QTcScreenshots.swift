import XCTest

final class QTcScreenshots: ScreenshotTestCase {
    func testQTcEmpty() {
        navigateToTool(id: "qtc")
        takeScreenshot(named: "QTc_Empty", subfolder: "QTc")
    }

    func testQTcFilled() {
        navigateToTool(id: "qtc")
        sleep(1)
        takeScreenshot(named: "QTc_Filled", subfolder: "QTc")
    }

    func testQTcDetails() {
        navigateToTool(id: "qtc")
        let infoButton = app.buttons["tool_info_section"]
        for _ in 0..<3 {
            if infoButton.exists && infoButton.isHittable { break }
            app.swipeUp()
        }
        XCTAssertTrue(infoButton.waitForExistence(timeout: 3), "ToolInfoSection button not found")
        infoButton.tap()
        sleep(1)
        takeScreenshot(named: "QTc_Details", subfolder: "QTc")
    }

    func testInteraction() {
        navigateToTool(id: "qtc")
        takeScreenshot(named: "QTc_Interaction_Start", subfolder: "QTc")
        let fields = app.textFields.allElementsBoundByIndex
        guard fields.count >= 2 else { XCTFail("Expected 2 text fields"); return }

        // Enter QT=400, HR=60 → QTc should be 400ms
        fields[0].tap()
        fields[0].typeText("400")
        fields[1].tap()
        fields[1].typeText("60")

        // Result should appear with ms
        let resultText = app.staticTexts.matching(NSPredicate(format: "label CONTAINS 'ms'"))
        XCTAssertTrue(resultText.firstMatch.waitForExistence(timeout: 2))

        // Tap Reset
        app.navigationBars.buttons["Reset"].tap()

        // Enter QT=500, HR=60 → QTc=500ms (prolonged)
        fields[0].tap()
        fields[0].typeText("500")
        fields[1].tap()
        fields[1].typeText("60")

        // Result should still show
        XCTAssertTrue(resultText.firstMatch.waitForExistence(timeout: 2))
        takeScreenshot(named: "QTc_Interaction_End", subfolder: "QTc")
    }
}
