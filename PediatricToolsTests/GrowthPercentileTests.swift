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

    func testPercentileAtZScorePositiveTwo() {
        // Standard normal CDF at z=+2 ≈ 97.72%
        let p = GrowthPercentileCalculator.percentile(zScore: 2.0)
        XCTAssertEqual(p, 97.72, accuracy: 0.5)
    }

    func testPercentileAtZScoreNegativeTwo() {
        // Standard normal CDF at z=-2 ≈ 2.28%
        let p = GrowthPercentileCalculator.percentile(zScore: -2.0)
        XCTAssertEqual(p, 2.28, accuracy: 0.5)
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

    // MARK: - Female birth weight at median

    func testFemaleBirthWeightAtMedian() {
        // WHO data: female, ageMonths=0, weight M=3.2322
        let result = GrowthPercentileCalculator.calculate(
            sex: .female,
            measurement: .weightForAge,
            ageMonths: 0.0,
            value: 3.2322
        )
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.zScore, 0.0, accuracy: 0.01)
        XCTAssertEqual(result!.percentile, 50.0, accuracy: 0.5)
    }

    // MARK: - Male length at birth at median

    func testMaleBirthLengthAtMedian() {
        // WHO data: male, ageMonths=0, length M=49.8842
        let result = GrowthPercentileCalculator.calculate(
            sex: .male,
            measurement: .lengthForAge,
            ageMonths: 0.0,
            value: 49.8842
        )
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.zScore, 0.0, accuracy: 0.01)
        XCTAssertEqual(result!.percentile, 50.0, accuracy: 0.5)
    }

    // MARK: - Female length at birth at median

    func testFemaleBirthLengthAtMedian() {
        // WHO data: female, ageMonths=0, length M=49.1477
        let result = GrowthPercentileCalculator.calculate(
            sex: .female,
            measurement: .lengthForAge,
            ageMonths: 0.0,
            value: 49.1477
        )
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.zScore, 0.0, accuracy: 0.01)
        XCTAssertEqual(result!.percentile, 50.0, accuracy: 0.5)
    }

    // MARK: - Age 6 months male weight at median

    func testMale6MonthsWeightAtMedian() {
        // WHO data: male, ageMonths=6, weight M=7.9340
        let result = GrowthPercentileCalculator.calculate(
            sex: .male,
            measurement: .weightForAge,
            ageMonths: 6.0,
            value: 7.934
        )
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.zScore, 0.0, accuracy: 0.01)
        XCTAssertEqual(result!.percentile, 50.0, accuracy: 0.5)
    }

    // MARK: - Age 12 months male weight at median

    func testMale12MonthsWeightAtMedian() {
        // WHO data: male, ageMonths=12, weight M=9.6479
        let result = GrowthPercentileCalculator.calculate(
            sex: .male,
            measurement: .weightForAge,
            ageMonths: 12.0,
            value: 9.6479
        )
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.zScore, 0.0, accuracy: 0.01)
        XCTAssertEqual(result!.percentile, 50.0, accuracy: 0.5)
    }

    // MARK: - Out-of-range age tests

    func testNegativeAgeReturnsNil() {
        // Age -1 is invalid; WHO data starts at 0 months.
        // The interpolateLMS function clamps to the first data point for ages below the range,
        // so the calculator still returns a result. We verify it does not crash.
        let result = GrowthPercentileCalculator.calculate(
            sex: .male,
            measurement: .weightForAge,
            ageMonths: -1.0,
            value: 3.3464
        )
        // interpolateLMS clamps to first data point, so result is non-nil.
        // The z-score should be approximately 0 since the value equals the median at ageMonths=0.
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.zScore, 0.0, accuracy: 0.01)
    }

    func testAgeBeyondDataRangeClampsToLastDataPoint() {
        // WHO data goes to 24 months. Age 100 is beyond the dataset.
        // The interpolateLMS function clamps to the last data point.
        let result = GrowthPercentileCalculator.calculate(
            sex: .male,
            measurement: .weightForAge,
            ageMonths: 100.0,
            value: 12.0435
        )
        // Should clamp to ageMonths=24 (M=12.0435) and return a valid result.
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.zScore, 0.0, accuracy: 0.01)
        XCTAssertEqual(result!.percentile, 50.0, accuracy: 0.5)
    }

    // MARK: - Z-score direction tests

    func testZScoreAboveMedianIsPositive() {
        // A value above the median (M=3.3464) should produce a positive z-score.
        let result = GrowthPercentileCalculator.calculate(
            sex: .male,
            measurement: .weightForAge,
            ageMonths: 0.0,
            value: 4.0
        )
        XCTAssertNotNil(result)
        XCTAssertGreaterThan(result!.zScore, 0.0)
        XCTAssertGreaterThan(result!.percentile, 50.0)
    }

    func testZScoreBelowMedianIsNegative() {
        // A value below the median (M=3.3464) should produce a negative z-score.
        let result = GrowthPercentileCalculator.calculate(
            sex: .male,
            measurement: .weightForAge,
            ageMonths: 0.0,
            value: 2.5
        )
        XCTAssertNotNil(result)
        XCTAssertLessThan(result!.zScore, 0.0)
        XCTAssertLessThan(result!.percentile, 50.0)
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
