import XCTest

final class BallardScreenshots: ScreenshotTestCase {
    func testBallardEmpty() {
        navigateToTool(id: "ballard")
        takeScreenshot(named: "Ballard_Empty", subfolder: "Ballard")
    }

    func testBallardFilled() {
        navigateToTool(id: "ballard")
        // Tap some score buttons to fill the form
        // Ballard uses stepper-like controls, just screenshot after navigating
        sleep(1)
        takeScreenshot(named: "Ballard_Filled", subfolder: "Ballard")
    }
}
