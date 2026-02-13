import XCTest

final class BPScreenshots: ScreenshotTestCase {
    func testBPEmpty() {
        navigateToTool(id: "bp")
        takeScreenshot(named: "BP_Empty", subfolder: "BP")
    }

    func testBPFilled() {
        navigateToTool(id: "bp")
        sleep(1)
        takeScreenshot(named: "BP_Filled", subfolder: "BP")
    }

    func testInteraction() {
        navigateToTool(id: "bp")
        let fields = app.textFields.allElementsBoundByIndex
        guard fields.count >= 2 else { XCTFail("Expected 2 text fields"); return }

        // Enter sys=100, dia=60
        fields[0].tap()
        fields[0].typeText("100")
        fields[1].tap()
        fields[1].typeText("60")

        // Result should appear with percentile values
        let resultText = app.staticTexts.matching(NSPredicate(format: "label CONTAINS '%'"))
        XCTAssertTrue(resultText.firstMatch.waitForExistence(timeout: 2))

        // Tap Reset
        app.navigationBars.buttons["Reset"].tap()

        // Enter sys=160, dia=100 (should show higher classification)
        fields[0].tap()
        fields[0].typeText("160")
        fields[1].tap()
        fields[1].typeText("100")

        // Result should still show
        XCTAssertTrue(resultText.firstMatch.waitForExistence(timeout: 2))
    }
}
