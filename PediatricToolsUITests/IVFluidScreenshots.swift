import XCTest

final class IVFluidScreenshots: ScreenshotTestCase {
    func testIVFluidEmpty() {
        navigateToTool(id: "ivfluid")
        takeScreenshot(named: "IVFluid_Empty", subfolder: "IVFluid")
    }

    func testIVFluidFilled() {
        navigateToTool(id: "ivfluid")
        let weightField = app.textFields.firstMatch
        weightField.tap()
        weightField.typeText("25")
        takeScreenshot(named: "IVFluid_Filled", subfolder: "IVFluid")
    }
}
