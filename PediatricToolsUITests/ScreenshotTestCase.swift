import XCTest

class ScreenshotTestCase: XCTestCase {
    var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func takeScreenshot(named name: String, subfolder: String) {
        let deviceName = UIDevice.current.name
            .replacingOccurrences(of: " ", with: "_")
        let fileName = "\(name)_\(deviceName)"

        let screenshot = XCUIScreen.main.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = fileName
        attachment.lifetime = .keepAlways
        add(attachment)

        // Save to disk — use source file path to locate project root
        let projectDir = URL(fileURLWithPath: #file)
            .deletingLastPathComponent()   // PediatricToolsUITests/
            .deletingLastPathComponent()   // project root
        let dir = projectDir.appendingPathComponent("Screenshots").path
        let folder = "\(dir)/\(subfolder)"
        try? FileManager.default.createDirectory(atPath: folder, withIntermediateDirectories: true)
        let path = "\(folder)/\(fileName).png"
        try? screenshot.pngRepresentation.write(to: URL(fileURLWithPath: path))
    }

    func navigateToTool(id: String) {
        let link = app.descendants(matching: .any).matching(identifier: id).firstMatch
        if !link.waitForExistence(timeout: 3) {
            // Element may be off-screen — swipe up to reveal it
            app.swipeUp()
            XCTAssertTrue(link.waitForExistence(timeout: 5), "Tool \(id) not found")
        }
        link.tap()
    }

    func navigateToSettings() {
        app.navigationBars.buttons["gearshape"].tap()
    }

    func navigateBack() {
        app.navigationBars.buttons.element(boundBy: 0).tap()
    }
}
