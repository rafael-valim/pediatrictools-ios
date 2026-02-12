import XCTest

final class GCSScreenshots: ScreenshotTestCase {
    func testGCSEmpty() {
        navigateToTool(id: "gcs")
        takeScreenshot(named: "GCS_Empty", subfolder: "GCS")
    }

    func testGCSFilled() {
        navigateToTool(id: "gcs")
        sleep(1)
        takeScreenshot(named: "GCS_Filled", subfolder: "GCS")
    }
}
