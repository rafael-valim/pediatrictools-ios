import XCTest

final class CorrectedAgeScreenshots: ScreenshotTestCase {
    func testCorrectedAgeDefault() {
        navigateToTool(id: "corrected")
        takeScreenshot(named: "CorrectedAge_Default", subfolder: "CorrectedAge")
    }
}
