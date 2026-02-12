import XCTest
@testable import PediatricTools

final class BPPercentileTests: XCTestCase {

    func testNormalBPFor10YearOldMale() {
        // 10yo male, 50th height, sys=100 dia=60 → should be normal
        let result = BPPercentileCalculator.calculate(
            systolic: 100, diastolic: 60, ageYears: 10, sex: .male, heightPercentile: .p50
        )
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.classification, .normal)
    }

    func testElevatedBP() {
        // 10yo male, 50th height, sys=113 (near 90th) → elevated or stage1
        let result = BPPercentileCalculator.calculate(
            systolic: 112, diastolic: 60, ageYears: 10, sex: .male, heightPercentile: .p50
        )
        XCTAssertNotNil(result)
        XCTAssertTrue(result!.classification == .elevated || result!.classification == .stageOneHTN)
    }

    func testStage2HTN() {
        // Very high BP → stage 2
        let result = BPPercentileCalculator.calculate(
            systolic: 140, diastolic: 95, ageYears: 10, sex: .male, heightPercentile: .p50
        )
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.classification, .stageTwoHTN)
    }

    func testAgeOutOfRangeLowReturnsNil() {
        let result = BPPercentileCalculator.calculate(
            systolic: 100, diastolic: 60, ageYears: 0, sex: .male, heightPercentile: .p50
        )
        XCTAssertNil(result)
    }

    func testAgeOutOfRangeHighReturnsNil() {
        let result = BPPercentileCalculator.calculate(
            systolic: 100, diastolic: 60, ageYears: 18, sex: .male, heightPercentile: .p50
        )
        XCTAssertNil(result)
    }

    func testZeroBPReturnsNil() {
        let result = BPPercentileCalculator.calculate(
            systolic: 0, diastolic: 60, ageYears: 10, sex: .male, heightPercentile: .p50
        )
        XCTAssertNil(result)
    }

    func testFemaleNormalBP() {
        let result = BPPercentileCalculator.calculate(
            systolic: 98, diastolic: 59, ageYears: 10, sex: .female, heightPercentile: .p50
        )
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.classification, .normal)
    }

    func testPercentileRange() {
        let result = BPPercentileCalculator.calculate(
            systolic: 100, diastolic: 60, ageYears: 10, sex: .male, heightPercentile: .p50
        )
        XCTAssertNotNil(result)
        XCTAssertGreaterThan(result!.systolicPercentile, 0)
        XCTAssertLessThan(result!.systolicPercentile, 100)
        XCTAssertGreaterThan(result!.diastolicPercentile, 0)
        XCTAssertLessThan(result!.diastolicPercentile, 100)
    }

    func testDifferentHeightPercentilesAffectResult() {
        let resultP5 = BPPercentileCalculator.calculate(
            systolic: 105, diastolic: 65, ageYears: 10, sex: .male, heightPercentile: .p5
        )
        let resultP95 = BPPercentileCalculator.calculate(
            systolic: 105, diastolic: 65, ageYears: 10, sex: .male, heightPercentile: .p95
        )
        XCTAssertNotNil(resultP5)
        XCTAssertNotNil(resultP95)
        // Same BP at shorter height should yield a higher percentile
        XCTAssertGreaterThan(resultP5!.systolicPercentile, resultP95!.systolicPercentile)
    }
}
