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
}
