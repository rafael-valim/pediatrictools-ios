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
}
