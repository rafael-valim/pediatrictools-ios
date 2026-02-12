import XCTest

final class GrowthScreenshots: ScreenshotTestCase {
    func testGrowthEmpty() {
        navigateToTool(id: "growth")
        takeScreenshot(named: "Growth_Empty", subfolder: "Growth")
    }

    func testGrowthFilled() {
        navigateToTool(id: "growth")
        let fields = app.textFields.allElementsBoundByIndex
        if fields.count >= 2 {
            fields[0].tap()
            fields[0].typeText("6")
            fields[1].tap()
            fields[1].typeText("7.5")
        }
        takeScreenshot(named: "Growth_Filled", subfolder: "Growth")
    }
}
