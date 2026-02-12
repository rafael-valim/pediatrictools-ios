import XCTest

final class SettingsScreenshots: ScreenshotTestCase {
    func testSettingsDefault() {
        navigateToSettings()
        takeScreenshot(named: "Settings_Default", subfolder: "Settings")
    }

    func testSettingsPortraitLockOn() {
        navigateToSettings()
        let toggle = app.switches["settings_portrait_lock"]
        XCTAssertTrue(toggle.waitForExistence(timeout: 3), "Portrait lock toggle not found")
        toggle.tap()
        takeScreenshot(named: "Settings_PortraitLockOn", subfolder: "Settings")
    }
}
