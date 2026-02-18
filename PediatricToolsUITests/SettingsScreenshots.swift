import XCTest

final class SettingsScreenshots: ScreenshotTestCase {
    func testSettingsDefault() {
        navigateToSettings()
        takeScreenshot(named: "Settings_Default", subfolder: "Settings")
    }

    func testSettingsFontSize() {
        navigateToSettings()
        // The font size picker is a navigation-style Picker — find it by its localized label
        let fontSizePicker = app.buttons.matching(NSPredicate(
            format: "label CONTAINS[c] 'font' OR label CONTAINS[c] 'tamanho' OR label CONTAINS[c] 'taille' OR label CONTAINS[c] 'tamano'"
        )).firstMatch
        XCTAssertTrue(fontSizePicker.waitForExistence(timeout: 3), "Font size picker not found")
        fontSizePicker.tap()
        sleep(1)
        // Select "Large" option from the picker list
        let largeOption = app.buttons.matching(NSPredicate(
            format: "label CONTAINS[c] 'large' OR label CONTAINS[c] 'grande' OR label CONTAINS[c] 'grand'"
        )).firstMatch
        if largeOption.waitForExistence(timeout: 3) {
            largeOption.tap()
        }
        sleep(1)
        navigateBack()
        sleep(1)
        takeScreenshot(named: "Settings_FontSize", subfolder: "Settings")
    }

    func testSettingsPortraitLockOn() {
        navigateToSettings()
        let toggle = app.switches["settings_portrait_lock"]
        XCTAssertTrue(toggle.waitForExistence(timeout: 3), "Portrait lock toggle not found")
        toggle.tap()
        takeScreenshot(named: "Settings_PortraitLockOn", subfolder: "Settings")
    }
}
