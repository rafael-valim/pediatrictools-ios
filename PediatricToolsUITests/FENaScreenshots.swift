import XCTest

final class FENaScreenshots: ScreenshotTestCase {
    func testFENaEmpty() {
        navigateToTool(id: "fena")
        takeScreenshot(named: "FENa_Empty", subfolder: "FENa")
    }

    func testFENaFilled() {
        navigateToTool(id: "fena")
        let fields = app.textFields.allElementsBoundByIndex
        if fields.count >= 4 {
            fields[0].tap()
            fields[0].typeText("40")
            fields[1].tap()
            fields[1].typeText("140")
            fields[2].tap()
            fields[2].typeText("80")
            fields[3].tap()
            fields[3].typeText("1.2")
        }
        takeScreenshot(named: "FENa_Filled", subfolder: "FENa")
    }

    func testInteraction() {
        navigateToTool(id: "fena")
        takeScreenshot(named: "FENa_Interaction_Start", subfolder: "FENa")
        let fields = app.textFields.allElementsBoundByIndex
        guard fields.count >= 4 else { XCTFail("Expected 4 text fields"); return }

        // Enter 10, 140, 100, 1.0 → FENa ≈ 0.07% (prerenal)
        fields[0].tap()
        fields[0].typeText("10")
        fields[1].tap()
        fields[1].typeText("140")
        fields[2].tap()
        fields[2].typeText("100")
        fields[3].tap()
        fields[3].typeText("1.0")

        // Result should appear with %
        let resultText = app.staticTexts.matching(NSPredicate(format: "label CONTAINS '%'"))
        XCTAssertTrue(resultText.firstMatch.waitForExistence(timeout: 2))

        // Tap Reset
        app.navigationBars.buttons["Reset"].tap()

        // Enter 80, 140, 40, 2.0 → FENa ≈ 2.86% (intrinsic)
        fields[0].tap()
        fields[0].typeText("80")
        fields[1].tap()
        fields[1].typeText("140")
        fields[2].tap()
        fields[2].typeText("40")
        fields[3].tap()
        fields[3].typeText("2.0")

        // Result should still show
        XCTAssertTrue(resultText.firstMatch.waitForExistence(timeout: 2))
        takeScreenshot(named: "FENa_Interaction_End", subfolder: "FENa")
    }
}
