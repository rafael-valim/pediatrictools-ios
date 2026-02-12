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
}
