import XCTest
@testable import PediatricTools

final class DehydrationTests: XCTestCase {

    func testTenKg5Percent() {
        // deficit = 10 * 5 * 10 = 500 mL
        // maintenance (HollidaySegar 10kg) = 1000 mL/day
        // total = 500 + 1000 = 1500 mL
        let result = DehydrationCalculator.calculate(weightKg: 10.0, dehydrationPercent: 5.0)
        XCTAssertEqual(result.deficitMl, 500.0, accuracy: 0.01)
        XCTAssertEqual(result.maintenanceMlPerDay, 1000.0, accuracy: 0.01)
        XCTAssertEqual(result.totalFirst24hMl, 1500.0, accuracy: 0.01)
    }

    func testZeroWeightReturnsAllZeros() {
        let result = DehydrationCalculator.calculate(weightKg: 0.0, dehydrationPercent: 5.0)
        XCTAssertEqual(result.deficitMl, 0.0, accuracy: 0.01)
        XCTAssertEqual(result.maintenanceMlPerDay, 0.0, accuracy: 0.01)
        XCTAssertEqual(result.totalFirst24hMl, 0.0, accuracy: 0.01)
    }
}
