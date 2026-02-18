import XCTest

final class AboutScreenshots: ScreenshotTestCase {
    func testAboutDefault() {
        navigateToSettings()
        // NavigationLink with Label("settings_about", ...) — try multiple element types
        let aboutLink = app.descendants(matching: .any).matching(identifier: "settings_about").firstMatch
        if !aboutLink.waitForExistence(timeout: 3) {
            app.swipeUp()
            XCTAssertTrue(aboutLink.waitForExistence(timeout: 3), "About link not found")
        }
        aboutLink.tap()
        sleep(1)
        takeScreenshot(named: "About_Default", subfolder: "About")
    }
}
