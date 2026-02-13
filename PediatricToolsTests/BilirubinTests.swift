import XCTest
@testable import PediatricTools

final class BilirubinTests: XCTestCase {

    // MARK: - Risk Category Tests

    func testTermNoRiskIsLowRisk() {
        XCTAssertEqual(
            BilirubinCalculator.riskCategory(ga: .term, hasRiskFactors: false),
            .lowRisk
        )
    }

    func testTermWithRiskIsMediumRisk() {
        XCTAssertEqual(
            BilirubinCalculator.riskCategory(ga: .term, hasRiskFactors: true),
            .mediumRisk
        )
    }

    func testLatePreTermNoRiskIsMediumRisk() {
        XCTAssertEqual(
            BilirubinCalculator.riskCategory(ga: .latePreterm, hasRiskFactors: false),
            .mediumRisk
        )
    }

    func testLatePreTermWithRiskIsHighRisk() {
        XCTAssertEqual(
            BilirubinCalculator.riskCategory(ga: .latePreterm, hasRiskFactors: true),
            .highRisk
        )
    }

    // MARK: - Threshold Tests

    func testLowRiskAt24Hours() {
        let result = BilirubinCalculator.calculate(
            bilirubinMgDL: 5.0, postnatalAgeHours: 24,
            gaCategory: .term, hasRiskFactors: false
        )
        XCTAssertNotNil(result)
        // At 24h, low risk phototherapy threshold = 11.0
        XCTAssertEqual(result!.phototherapyThreshold, 11.0, accuracy: 0.1)
    }

    func testMediumRiskAt48Hours() {
        let result = BilirubinCalculator.calculate(
            bilirubinMgDL: 5.0, postnatalAgeHours: 48,
            gaCategory: .term, hasRiskFactors: true
        )
        XCTAssertNotNil(result)
        // At 48h, medium risk phototherapy threshold = 13.0
        XCTAssertEqual(result!.phototherapyThreshold, 13.0, accuracy: 0.1)
    }

    func testHighRiskAt72Hours() {
        let result = BilirubinCalculator.calculate(
            bilirubinMgDL: 5.0, postnatalAgeHours: 72,
            gaCategory: .latePreterm, hasRiskFactors: true
        )
        XCTAssertNotNil(result)
        // At 72h, high risk phototherapy threshold = 12.5
        XCTAssertEqual(result!.phototherapyThreshold, 12.5, accuracy: 0.1)
    }

    // MARK: - Interpretation Tests

    func testBelowThreshold() {
        let result = BilirubinCalculator.calculate(
            bilirubinMgDL: 5.0, postnatalAgeHours: 48,
            gaCategory: .term, hasRiskFactors: false
        )
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.interpretationKey, "bili_below_threshold")
        XCTAssertFalse(result!.exceedsPhototherapy)
    }

    func testExceedsPhototherapy() {
        let result = BilirubinCalculator.calculate(
            bilirubinMgDL: 16.0, postnatalAgeHours: 48,
            gaCategory: .term, hasRiskFactors: false
        )
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.interpretationKey, "bili_exceeds_photo")
        XCTAssertTrue(result!.exceedsPhototherapy)
        XCTAssertFalse(result!.exceedsExchange)
    }

    func testExceedsExchange() {
        let result = BilirubinCalculator.calculate(
            bilirubinMgDL: 25.0, postnatalAgeHours: 48,
            gaCategory: .term, hasRiskFactors: false
        )
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.interpretationKey, "bili_exceeds_exchange")
        XCTAssertTrue(result!.exceedsExchange)
    }

    // MARK: - Interpolation Tests

    func testInterpolationBetweenDataPoints() {
        // At 36h for low risk, threshold should be between 11.0 (24h) and 13.5 (36h)
        // Actually 36h is a data point itself = 13.5
        let result = BilirubinCalculator.calculate(
            bilirubinMgDL: 5.0, postnatalAgeHours: 30,
            gaCategory: .term, hasRiskFactors: false
        )
        XCTAssertNotNil(result)
        // 30h is halfway between 24h (11.0) and 36h (13.5) → 12.25
        XCTAssertEqual(result!.phototherapyThreshold, 12.25, accuracy: 0.1)
    }

    // MARK: - Edge Cases

    func testZeroHours() {
        let result = BilirubinCalculator.calculate(
            bilirubinMgDL: 3.0, postnatalAgeHours: 0,
            gaCategory: .term, hasRiskFactors: false
        )
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.phototherapyThreshold, 5.0, accuracy: 0.1)
    }

    func testBeyond120Hours() {
        let result = BilirubinCalculator.calculate(
            bilirubinMgDL: 5.0, postnatalAgeHours: 150,
            gaCategory: .term, hasRiskFactors: false
        )
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.phototherapyThreshold, 21.0, accuracy: 0.1)
    }

    // MARK: - Low-risk phototherapy threshold data point verification

    func testLowRiskAt0Hours() {
        let result = BilirubinCalculator.calculate(
            bilirubinMgDL: 1.0, postnatalAgeHours: 0,
            gaCategory: .term, hasRiskFactors: false
        )
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.phototherapyThreshold, 5.0, accuracy: 0.1)
    }

    func testLowRiskAt12Hours() {
        let result = BilirubinCalculator.calculate(
            bilirubinMgDL: 1.0, postnatalAgeHours: 12,
            gaCategory: .term, hasRiskFactors: false
        )
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.phototherapyThreshold, 8.0, accuracy: 0.1)
    }

    func testLowRiskAt36Hours() {
        let result = BilirubinCalculator.calculate(
            bilirubinMgDL: 1.0, postnatalAgeHours: 36,
            gaCategory: .term, hasRiskFactors: false
        )
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.phototherapyThreshold, 13.5, accuracy: 0.1)
    }

    func testLowRiskAt48Hours() {
        let result = BilirubinCalculator.calculate(
            bilirubinMgDL: 1.0, postnatalAgeHours: 48,
            gaCategory: .term, hasRiskFactors: false
        )
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.phototherapyThreshold, 15.5, accuracy: 0.1)
    }

    func testLowRiskAt60Hours() {
        let result = BilirubinCalculator.calculate(
            bilirubinMgDL: 1.0, postnatalAgeHours: 60,
            gaCategory: .term, hasRiskFactors: false
        )
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.phototherapyThreshold, 17.0, accuracy: 0.1)
    }

    func testLowRiskAt72Hours() {
        let result = BilirubinCalculator.calculate(
            bilirubinMgDL: 1.0, postnatalAgeHours: 72,
            gaCategory: .term, hasRiskFactors: false
        )
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.phototherapyThreshold, 18.5, accuracy: 0.1)
    }

    func testLowRiskAt84Hours() {
        let result = BilirubinCalculator.calculate(
            bilirubinMgDL: 1.0, postnatalAgeHours: 84,
            gaCategory: .term, hasRiskFactors: false
        )
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.phototherapyThreshold, 19.5, accuracy: 0.1)
    }

    func testLowRiskAt96Hours() {
        let result = BilirubinCalculator.calculate(
            bilirubinMgDL: 1.0, postnatalAgeHours: 96,
            gaCategory: .term, hasRiskFactors: false
        )
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.phototherapyThreshold, 20.5, accuracy: 0.1)
    }

    func testLowRiskAt108Hours() {
        let result = BilirubinCalculator.calculate(
            bilirubinMgDL: 1.0, postnatalAgeHours: 108,
            gaCategory: .term, hasRiskFactors: false
        )
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.phototherapyThreshold, 21.0, accuracy: 0.1)
    }

    func testLowRiskAt120Hours() {
        let result = BilirubinCalculator.calculate(
            bilirubinMgDL: 1.0, postnatalAgeHours: 120,
            gaCategory: .term, hasRiskFactors: false
        )
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.phototherapyThreshold, 21.0, accuracy: 0.1)
    }

    // MARK: - High-risk phototherapy threshold data point verification

    func testHighRiskPhotoThresholdAt24Hours() {
        let result = BilirubinCalculator.calculate(
            bilirubinMgDL: 1.0, postnatalAgeHours: 24,
            gaCategory: .latePreterm, hasRiskFactors: true
        )
        XCTAssertNotNil(result)
        // High risk at 24h → 7.0
        XCTAssertEqual(result!.phototherapyThreshold, 7.0, accuracy: 0.1)
    }

    func testHighRiskPhotoThresholdAt48Hours() {
        let result = BilirubinCalculator.calculate(
            bilirubinMgDL: 1.0, postnatalAgeHours: 48,
            gaCategory: .latePreterm, hasRiskFactors: true
        )
        XCTAssertNotNil(result)
        // High risk at 48h → 10.0
        XCTAssertEqual(result!.phototherapyThreshold, 10.0, accuracy: 0.1)
    }

    func testHighRiskPhotoThresholdAt72Hours() {
        let result = BilirubinCalculator.calculate(
            bilirubinMgDL: 1.0, postnatalAgeHours: 72,
            gaCategory: .latePreterm, hasRiskFactors: true
        )
        XCTAssertNotNil(result)
        // High risk at 72h → 12.5
        XCTAssertEqual(result!.phototherapyThreshold, 12.5, accuracy: 0.1)
    }

    // MARK: - Medium-risk 24h threshold

    func testMediumRiskAt24Hours() {
        let result = BilirubinCalculator.calculate(
            bilirubinMgDL: 1.0, postnatalAgeHours: 24,
            gaCategory: .term, hasRiskFactors: true
        )
        XCTAssertNotNil(result)
        // Medium risk at 24h → 9.0
        XCTAssertEqual(result!.phototherapyThreshold, 9.0, accuracy: 0.1)
    }

    // MARK: - Interpolation at 42h (between 36h and 48h)

    func testInterpolationAt42Hours() {
        // Low risk: 36h→13.5, 48h→15.5
        // 42h is halfway between 36h and 48h → (13.5 + 15.5) / 2 = 14.5
        let result = BilirubinCalculator.calculate(
            bilirubinMgDL: 1.0, postnatalAgeHours: 42,
            gaCategory: .term, hasRiskFactors: false
        )
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.phototherapyThreshold, 14.5, accuracy: 0.1)
    }

    // MARK: - Just above/below phototherapy threshold

    func testJustAbovePhototherapyAt24HoursLowRisk() {
        // Low risk at 24h: phototherapy threshold = 11.0
        // Bilirubin 11.1 should exceed phototherapy
        let result = BilirubinCalculator.calculate(
            bilirubinMgDL: 11.1, postnatalAgeHours: 24,
            gaCategory: .term, hasRiskFactors: false
        )
        XCTAssertNotNil(result)
        XCTAssertTrue(result!.exceedsPhototherapy)
        XCTAssertEqual(result!.interpretationKey, "bili_exceeds_photo")
    }

    func testJustBelowPhototherapyAt24HoursLowRisk() {
        // Low risk at 24h: phototherapy threshold = 11.0
        // Bilirubin 10.9 should be below threshold
        let result = BilirubinCalculator.calculate(
            bilirubinMgDL: 10.9, postnatalAgeHours: 24,
            gaCategory: .term, hasRiskFactors: false
        )
        XCTAssertNotNil(result)
        XCTAssertFalse(result!.exceedsPhototherapy)
        XCTAssertEqual(result!.interpretationKey, "bili_below_threshold")
    }

    func testExactlyAtPhototherapyThresholdExceeds() {
        // Low risk at 24h: phototherapy threshold = 11.0
        // Bilirubin exactly at 11.0 → exceedsPhoto = bilirubinMgDL >= photoThreshold → true
        let result = BilirubinCalculator.calculate(
            bilirubinMgDL: 11.0, postnatalAgeHours: 24,
            gaCategory: .term, hasRiskFactors: false
        )
        XCTAssertNotNil(result)
        XCTAssertTrue(result!.exceedsPhototherapy)
    }

    // MARK: - Exchange threshold tests

    func testLowRiskExchangeAt24Hours() {
        // Low risk exchange at 24h → 16.0
        let result = BilirubinCalculator.calculate(
            bilirubinMgDL: 1.0, postnatalAgeHours: 24,
            gaCategory: .term, hasRiskFactors: false
        )
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.exchangeThreshold, 16.0, accuracy: 0.1)
    }

    func testLowRiskExchangeAt48Hours() {
        // Low risk exchange at 48h → 21.5
        let result = BilirubinCalculator.calculate(
            bilirubinMgDL: 1.0, postnatalAgeHours: 48,
            gaCategory: .term, hasRiskFactors: false
        )
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.exchangeThreshold, 21.5, accuracy: 0.1)
    }

    func testHighRiskExchangeAt72Hours() {
        // High risk exchange at 72h → 17.5
        let result = BilirubinCalculator.calculate(
            bilirubinMgDL: 1.0, postnatalAgeHours: 72,
            gaCategory: .latePreterm, hasRiskFactors: true
        )
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.exchangeThreshold, 17.5, accuracy: 0.1)
    }

    func testExceedsExchangeAtLowRisk48Hours() {
        // Low risk exchange at 48h → 21.5
        // Bilirubin 22.0 should exceed exchange
        let result = BilirubinCalculator.calculate(
            bilirubinMgDL: 22.0, postnatalAgeHours: 48,
            gaCategory: .term, hasRiskFactors: false
        )
        XCTAssertNotNil(result)
        XCTAssertTrue(result!.exceedsExchange)
        XCTAssertTrue(result!.exceedsPhototherapy)
        XCTAssertEqual(result!.interpretationKey, "bili_exceeds_exchange")
    }

    // MARK: - Negative bilirubin returns nil

    func testNegativeBilirubinReturnsNil() {
        let result = BilirubinCalculator.calculate(
            bilirubinMgDL: -1.0, postnatalAgeHours: 24,
            gaCategory: .term, hasRiskFactors: false
        )
        XCTAssertNil(result)
    }

    // MARK: - Negative hours returns nil

    func testNegativeHoursReturnsNil() {
        let result = BilirubinCalculator.calculate(
            bilirubinMgDL: 5.0, postnatalAgeHours: -1,
            gaCategory: .term, hasRiskFactors: false
        )
        XCTAssertNil(result)
    }
}
