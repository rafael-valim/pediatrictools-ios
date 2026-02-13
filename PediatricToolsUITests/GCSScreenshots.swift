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

    func testInteraction() {
        navigateToTool(id: "gcs")
        takeScreenshot(named: "GCS_Interaction_Start", subfolder: "GCS")

        // GCS has 3 criteria: Eye (1–4), Verbal (1–5), Motor (1–6)
        // Default scores are the minimum values (1, 1, 1) = total 3/15
        XCTAssertTrue(app.staticTexts["3/15"].exists)

        // Tap score "4" for Eye (the max eye score — there is exactly one "4" button in eye row)
        let fourButtons = app.buttons.matching(NSPredicate(format: "label BEGINSWITH '4'"))
        if fourButtons.count >= 1 {
            fourButtons.element(boundBy: 0).tap()
        }

        // Total should now be 6/15 (4 + 1 + 1)
        XCTAssertTrue(app.staticTexts["6/15"].waitForExistence(timeout: 2))

        // Tap score "5" for Verbal (max verbal score)
        let fiveButtons = app.buttons.matching(NSPredicate(format: "label BEGINSWITH '5'"))
        if fiveButtons.count >= 1 {
            fiveButtons.element(boundBy: 0).tap()
        }

        // Total should now be 10/15 (4 + 5 + 1)
        XCTAssertTrue(app.staticTexts["10/15"].waitForExistence(timeout: 2))

        // Tap score "6" for Motor (max motor score — the only "6" button)
        let sixButtons = app.buttons.matching(NSPredicate(format: "label BEGINSWITH '6'"))
        if sixButtons.count >= 1 {
            sixButtons.element(boundBy: 0).tap()
        }

        // Total should now be 15/15 (4 + 5 + 6)
        XCTAssertTrue(app.staticTexts["15/15"].waitForExistence(timeout: 2))

        // Reset and verify default total returns to 3/15
        app.navigationBars.buttons["Reset"].tap()
        XCTAssertTrue(app.staticTexts["3/15"].waitForExistence(timeout: 2))

        // Test switching age group picker — tap Infant segment
        // The segmented picker has Child and Infant options
        let infantButton = app.buttons.matching(
            NSPredicate(format: "label CONTAINS[c] 'infant' OR label CONTAINS[c] 'lactente' OR label CONTAINS[c] 'nourrisson' OR label CONTAINS[c] 'lactante'")
        ).firstMatch
        if infantButton.waitForExistence(timeout: 2) {
            infantButton.tap()
        }

        // After switching age group, verbal score resets to min (1),
        // so total should still be 3/15 (1 + 1 + 1)
        XCTAssertTrue(app.staticTexts["3/15"].waitForExistence(timeout: 2))
        takeScreenshot(named: "GCS_Interaction_End", subfolder: "GCS")
    }
}
