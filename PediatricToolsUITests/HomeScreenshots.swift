import XCTest

final class HomeScreenshots: ScreenshotTestCase {
    func testHomeScreen() {
        takeScreenshot(named: "Home_Default", subfolder: "Home")
    }
}
