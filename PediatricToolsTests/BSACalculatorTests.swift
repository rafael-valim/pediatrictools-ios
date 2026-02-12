import XCTest
@testable import PediatricTools

final class BSACalculatorTests: XCTestCase {

    func testMostellerStandardValues() {
        // h=100, w=25 → sqrt(2500/3600) ≈ 0.8333
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
        // h=180, w=70 → sqrt(12600/3600) ≈ 1.8708
        let result = BSACalculator.mosteller(heightCm: 180.0, weightKg: 70.0)
        XCTAssertEqual(result, sqrt(12600.0 / 3600.0), accuracy: 0.001)
    }
}
