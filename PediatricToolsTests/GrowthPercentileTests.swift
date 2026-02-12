import XCTest
@testable import PediatricTools

final class GrowthPercentileTests: XCTestCase {

    // MARK: - zScore tests

    func testZScoreWithKnownLMS() {
        // When value equals M (median) the z-score should be 0
        let z = GrowthPercentileCalculator.zScore(value: 10.0, L: 1.0, M: 10.0, S: 0.1)
        XCTAssertEqual(z, 0.0, accuracy: 0.01)
    }

    // MARK: - Percentile tests

    func testPercentileAtZScoreZero() {
        let p = GrowthPercentileCalculator.percentile(zScore: 0.0)
        XCTAssertEqual(p, 50.0, accuracy: 0.5)
    }

    func testPercentileAtZScorePositiveOne() {
        let p = GrowthPercentileCalculator.percentile(zScore: 1.0)
        XCTAssertEqual(p, 84.13, accuracy: 0.5)
    }

    func testPercentileAtZScoreNegativeOne() {
        let p = GrowthPercentileCalculator.percentile(zScore: -1.0)
        XCTAssertEqual(p, 15.87, accuracy: 0.5)
    }

    // MARK: - Full calculation (male, birth, weight at median)

    func testMaleBirthWeightAtMedian() {
        // WHO data: male, ageMonths=0, weight M=3.3464
        // z-score should be approximately 0, percentile approximately 50
        let result = GrowthPercentileCalculator.calculate(
            sex: .male,
            measurement: .weightForAge,
            ageMonths: 0.0,
            value: 3.3464
        )
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.zScore, 0.0, accuracy: 0.01)
        XCTAssertEqual(result!.percentile, 50.0, accuracy: 0.5)
    }

    // MARK: - Percentile bounds

    func testPercentileBoundedAtLowerEnd() {
        // Very negative z-score should be clamped to 0.1
        let p = GrowthPercentileCalculator.percentile(zScore: -10.0)
        XCTAssertGreaterThanOrEqual(p, 0.1)
    }

    func testPercentileBoundedAtUpperEnd() {
        // Very positive z-score should be clamped to 99.9
        let p = GrowthPercentileCalculator.percentile(zScore: 10.0)
        XCTAssertLessThanOrEqual(p, 99.9)
    }
}
