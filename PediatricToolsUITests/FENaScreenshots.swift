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
}
