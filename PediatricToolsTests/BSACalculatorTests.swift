import XCTest
@testable import PediatricTools

final class BSACalculatorTests: XCTestCase {

    // MARK: - Existing standard cases

    func testMostellerStandardValues() {
        // h=100, w=25 -> sqrt(2500/3600) ~ 0.8333
        let result = BSACalculator.mosteller(heightCm: 100.0, weightKg: 25.0)
        XCTAssertEqual(result, sqrt(2500.0 / 3600.0), accuracy: 0.001)
    }

    func testMostellerZeroHeightReturnsZero() {
        let result = BSACalculator.mosteller(heightCm: 0.0, weightKg: 25.0)
        XCTAssertEqual(result, 0.0, accuracy: 0.001)
    }

    func testMostellerZeroWeightReturnsZero() {
        let result = BSACalculator.mosteller(heightCm: 100.0, weightKg: 0.0)
        XCTAssertEqual(result, 0.0, accuracy: 0.001)
    }

    func testMostellerAdultValues() {
        // h=180, w=70 -> sqrt(12600/3600) ~ 1.8708
        let result = BSACalculator.mosteller(heightCm: 180.0, weightKg: 70.0)
        XCTAssertEqual(result, sqrt(12600.0 / 3600.0), accuracy: 0.001)
    }

    // MARK: - Infant values

    func testMostellerInfantValues() {
        // h=50, w=3.5 -> sqrt(175/3600) ~ 0.2205
        let result = BSACalculator.mosteller(heightCm: 50.0, weightKg: 3.5)
        let expected = sqrt(50.0 * 3.5 / 3600.0) // sqrt(175/3600) ~ 0.2205
        XCTAssertEqual(result, expected, accuracy: 0.001)
    }

    // MARK: - Known clinical reference (standard adult BSA ~ 1.73 m2)

    func testMostellerStandardAdultBSA() {
        // Standard adult BSA ~ 1.73 m2 corresponds to approximately h=170, w=63.3
        // sqrt(170 * 63.3 / 3600) = sqrt(10761/3600) = sqrt(2.989...) ~ 1.729
        let result = BSACalculator.mosteller(heightCm: 170.0, weightKg: 63.3)
        XCTAssertEqual(result, sqrt(170.0 * 63.3 / 3600.0), accuracy: 0.001)
        // Verify it is close to the canonical 1.73 m2
        XCTAssertEqual(result, 1.73, accuracy: 0.02)
    }

    // MARK: - Negative inputs

    func testMostellerNegativeHeightReturnsZero() {
        // Guard clause: heightCm <= 0 returns 0
        let result = BSACalculator.mosteller(heightCm: -100.0, weightKg: 25.0)
        XCTAssertEqual(result, 0.0, accuracy: 0.001)
    }

    func testMostellerNegativeWeightReturnsZero() {
        // Guard clause: weightKg <= 0 returns 0
        let result = BSACalculator.mosteller(heightCm: 100.0, weightKg: -10.0)
        XCTAssertEqual(result, 0.0, accuracy: 0.001)
    }

    func testMostellerBothNegativeReturnsZero() {
        let result = BSACalculator.mosteller(heightCm: -50.0, weightKg: -5.0)
        XCTAssertEqual(result, 0.0, accuracy: 0.001)
    }

    // MARK: - Large values

    func testMostellerLargeValues() {
        // h=200, w=150 -> sqrt(30000/3600) = sqrt(8.333) ~ 2.887
        let result = BSACalculator.mosteller(heightCm: 200.0, weightKg: 150.0)
        let expected = sqrt(200.0 * 150.0 / 3600.0)
        XCTAssertEqual(result, expected, accuracy: 0.001)
    }

    // MARK: - Both zero

    func testMostellerBothZeroReturnsZero() {
        let result = BSACalculator.mosteller(heightCm: 0.0, weightKg: 0.0)
        XCTAssertEqual(result, 0.0, accuracy: 0.001)
    }

    // MARK: - Very small values (neonate)

    func testMostellerSmallNeonate() {
        // Premature infant: h=35, w=1.0 -> sqrt(35/3600) ~ 0.0986
        let result = BSACalculator.mosteller(heightCm: 35.0, weightKg: 1.0)
        let expected = sqrt(35.0 / 3600.0)
        XCTAssertEqual(result, expected, accuracy: 0.001)
    }
}
