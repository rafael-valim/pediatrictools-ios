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

    // MARK: - Age boundary tests

    func testAgeBoundary1IsValid() {
        // Age 1 is the lowest valid age (guard: ageYears >= 1)
        let result = BPPercentileCalculator.calculate(
            systolic: 85, diastolic: 40, ageYears: 1, sex: .male, heightPercentile: .p50
        )
        XCTAssertNotNil(result)
    }

    func testAgeBoundary17IsValid() {
        // Age 17 is the highest valid age (guard: ageYears <= 17)
        let result = BPPercentileCalculator.calculate(
            systolic: 115, diastolic: 65, ageYears: 17, sex: .male, heightPercentile: .p50
        )
        XCTAssertNotNil(result)
    }

    // MARK: - Young child normal BP

    func testAge2MaleNormalBP() {
        // sys=90 dia=50 for a 2yo male should be normal
        let result = BPPercentileCalculator.calculate(
            systolic: 90, diastolic: 50, ageYears: 2, sex: .male, heightPercentile: .p50
        )
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.classification, .normal)
    }

    // MARK: - All height percentile categories return non-nil

    func testAllHeightPercentileCategoriesReturnNonNil() {
        let categories: [HeightPercentileCategory] = [.p5, .p10, .p25, .p50, .p75, .p90, .p95]
        for hp in categories {
            let result = BPPercentileCalculator.calculate(
                systolic: 100, diastolic: 60, ageYears: 10, sex: .male, heightPercentile: hp
            )
            XCTAssertNotNil(result, "Expected non-nil result for height percentile \(hp.rawValue)")
        }
    }

    // MARK: - Zero diastolic returns nil

    func testZeroDiastolicReturnsNil() {
        let result = BPPercentileCalculator.calculate(
            systolic: 100, diastolic: 0, ageYears: 10, sex: .male, heightPercentile: .p50
        )
        XCTAssertNil(result)
    }

    // MARK: - Female stage 1 HTN

    func testFemaleStage1HTN() {
        // For 10yo female at p50 height: sysMean=99, sysSD=8
        // p95Sys = 99 + 1.645*8 = 112.16
        // systolic=113 should be >= p95Sys → stage 1 HTN
        let result = BPPercentileCalculator.calculate(
            systolic: 113, diastolic: 60, ageYears: 10, sex: .female, heightPercentile: .p50
        )
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.classification, .stageOneHTN)
    }

    // MARK: - Systolic-only hypertension

    func testSystolicOnlyHypertension() {
        // High systolic with normal diastolic
        // For 10yo male at p50: sysMean=101, sysSD=8, diaMean=61, diaSD=5
        // p95Sys = 101 + 1.645*8 = 114.16
        // systolic=115 should exceed p95 → at least stage 1 HTN
        // diastolic=55 is well below p90Dia = 61 + 1.282*5 = 67.41
        let result = BPPercentileCalculator.calculate(
            systolic: 115, diastolic: 55, ageYears: 10, sex: .male, heightPercentile: .p50
        )
        XCTAssertNotNil(result)
        XCTAssertTrue(
            result!.classification == .stageOneHTN || result!.classification == .stageTwoHTN,
            "Expected stage 1 or stage 2 HTN from elevated systolic alone"
        )
    }

    // MARK: - Diastolic-only elevation

    func testDiastolicOnlyElevation() {
        // Normal systolic with elevated diastolic
        // For 10yo male at p50: diaMean=61, diaSD=5
        // p90Dia = 61 + 1.282*5 = 67.41
        // diastolic=90 should exceed p95Dia = 61 + 1.645*5 = 69.225
        // systolic=95 is well below p90Sys = 101 + 1.282*8 = 111.256
        let result = BPPercentileCalculator.calculate(
            systolic: 95, diastolic: 90, ageYears: 10, sex: .male, heightPercentile: .p50
        )
        XCTAssertNotNil(result)
        XCTAssertTrue(
            result!.classification == .stageOneHTN || result!.classification == .stageTwoHTN,
            "Expected HTN classification from elevated diastolic alone"
        )
    }
}
