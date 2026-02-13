import XCTest
@testable import PediatricTools

final class SchwartzGFRTests: XCTestCase {

    func testKnownCalculation() {
        // height=100cm, creatinine=0.5 → 0.413 × (100/0.5) = 82.6
        let result = SchwartzGFR.calculate(heightCm: 100, serumCreatinine: 0.5)
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.eGFR, 82.6, accuracy: 0.1)
    }

    func testNormalGFR() {
        // height=150cm, creatinine=0.6 → 0.413 × (150/0.6) = 103.25
        let result = SchwartzGFR.calculate(heightCm: 150, serumCreatinine: 0.6)
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.interpretationKey, "gfr_normal")
    }

    func testMildDecreaseGFR() {
        // height=100cm, creatinine=0.5 → 82.6 (60-89)
        let result = SchwartzGFR.calculate(heightCm: 100, serumCreatinine: 0.5)
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.interpretationKey, "gfr_mild")
    }

    func testModerateDecreaseGFR() {
        // height=100cm, creatinine=1.0 → 41.3 (30-59)
        let result = SchwartzGFR.calculate(heightCm: 100, serumCreatinine: 1.0)
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.interpretationKey, "gfr_moderate")
    }

    func testSevereDecreaseGFR() {
        // height=100cm, creatinine=2.0 → 20.65 (15-29)
        let result = SchwartzGFR.calculate(heightCm: 100, serumCreatinine: 2.0)
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.interpretationKey, "gfr_severe")
    }

    func testKidneyFailureGFR() {
        // height=100cm, creatinine=5.0 → 8.26 (<15)
        let result = SchwartzGFR.calculate(heightCm: 100, serumCreatinine: 5.0)
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.interpretationKey, "gfr_kidney_failure")
    }

    func testZeroHeightReturnsNil() {
        let result = SchwartzGFR.calculate(heightCm: 0, serumCreatinine: 0.5)
        XCTAssertNil(result)
    }

    func testZeroCreatinineReturnsNil() {
        let result = SchwartzGFR.calculate(heightCm: 100, serumCreatinine: 0)
        XCTAssertNil(result)
    }

    func testVeryLowCreatinine() {
        // height=100cm, creatinine=0.01 → 0.413 × 10000 = 4130
        let result = SchwartzGFR.calculate(heightCm: 100, serumCreatinine: 0.01)
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.interpretationKey, "gfr_normal")
    }

    // MARK: - Exact boundary tests

    func testExactBoundaryGFR90() {
        // eGFR = 0.413 × h / Cr = 90 → at h=100, Cr = 0.413 * 100 / 90 ≈ 0.4589
        // eGFR = 0.413 * 100 / 0.4589 ≈ 90.0 → "gfr_normal" (90... range)
        let cr = 0.413 * 100.0 / 90.0
        let result = SchwartzGFR.calculate(heightCm: 100, serumCreatinine: cr)
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.eGFR, 90.0, accuracy: 0.01)
        XCTAssertEqual(result!.interpretationKey, "gfr_normal")
    }

    func testExactBoundaryGFR60() {
        // eGFR = 0.413 × 100 / Cr = 60 → Cr = 0.413 * 100 / 60 ≈ 0.6883
        // eGFR = 60.0 → "gfr_mild" (60..<90 range)
        let cr = 0.413 * 100.0 / 60.0
        let result = SchwartzGFR.calculate(heightCm: 100, serumCreatinine: cr)
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.eGFR, 60.0, accuracy: 0.01)
        XCTAssertEqual(result!.interpretationKey, "gfr_mild")
    }

    func testExactBoundaryGFR30() {
        // eGFR = 0.413 × 100 / Cr = 30 → Cr = 0.413 * 100 / 30 ≈ 1.3767
        // eGFR = 30.0 → "gfr_moderate" (30..<60 range)
        let cr = 0.413 * 100.0 / 30.0
        let result = SchwartzGFR.calculate(heightCm: 100, serumCreatinine: cr)
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.eGFR, 30.0, accuracy: 0.01)
        XCTAssertEqual(result!.interpretationKey, "gfr_moderate")
    }

    func testExactBoundaryGFR15() {
        // eGFR = 0.413 × 100 / Cr = 15 → Cr = 0.413 * 100 / 15 ≈ 2.7533
        // eGFR = 15.0 → "gfr_severe" (15..<30 range)
        let cr = 0.413 * 100.0 / 15.0
        let result = SchwartzGFR.calculate(heightCm: 100, serumCreatinine: cr)
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.eGFR, 15.0, accuracy: 0.01)
        XCTAssertEqual(result!.interpretationKey, "gfr_severe")
    }

    func testGFRJustBelow15IsKidneyFailure() {
        // eGFR = 0.413 × 100 / Cr = 14.9 → Cr = 0.413 * 100 / 14.9 ≈ 2.772
        // eGFR = 14.9 → "gfr_kidney_failure" (default / <15)
        let cr = 0.413 * 100.0 / 14.9
        let result = SchwartzGFR.calculate(heightCm: 100, serumCreatinine: cr)
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.eGFR, 14.9, accuracy: 0.01)
        XCTAssertEqual(result!.interpretationKey, "gfr_kidney_failure")
    }

    // MARK: - Negative input tests

    func testNegativeHeightReturnsNil() {
        let result = SchwartzGFR.calculate(heightCm: -50, serumCreatinine: 0.5)
        XCTAssertNil(result)
    }

    func testNegativeCreatinineReturnsNil() {
        let result = SchwartzGFR.calculate(heightCm: 100, serumCreatinine: -0.5)
        XCTAssertNil(result)
    }

    // MARK: - Known clinical scenario

    func testClinicalScenario120cmCr05() {
        // height=120cm, Cr=0.5 → 0.413 × (120/0.5) = 0.413 × 240 = 99.12
        let result = SchwartzGFR.calculate(heightCm: 120, serumCreatinine: 0.5)
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.eGFR, 99.12, accuracy: 0.1)
        XCTAssertEqual(result!.interpretationKey, "gfr_normal")
    }
}
