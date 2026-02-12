import XCTest
@testable import PediatricTools

final class HollidaySegarTests: XCTestCase {

    func testWeight5Kg() {
        let result = HollidaySegarCalculator.calculate(weightKg: 5.0)
        XCTAssertEqual(result.dailyMl, 500.0, accuracy: 0.01)
        XCTAssertEqual(result.hourlyMl, 500.0 / 24.0, accuracy: 0.01)
    }

    func testWeight10Kg() {
        let result = HollidaySegarCalculator.calculate(weightKg: 10.0)
        XCTAssertEqual(result.dailyMl, 1000.0, accuracy: 0.01)
        XCTAssertEqual(result.hourlyMl, 1000.0 / 24.0, accuracy: 0.01)
    }

    func testWeight15Kg() {
        let result = HollidaySegarCalculator.calculate(weightKg: 15.0)
        XCTAssertEqual(result.dailyMl, 1250.0, accuracy: 0.01)
        XCTAssertEqual(result.hourlyMl, 1250.0 / 24.0, accuracy: 0.01)
    }

    func testWeight25Kg() {
        let result = HollidaySegarCalculator.calculate(weightKg: 25.0)
        XCTAssertEqual(result.dailyMl, 1600.0, accuracy: 0.01)
        XCTAssertEqual(result.hourlyMl, 1600.0 / 24.0, accuracy: 0.01)
    }

    func testZeroWeightReturnsAllZeros() {
        let result = HollidaySegarCalculator.calculate(weightKg: 0.0)
        XCTAssertEqual(result.dailyMl, 0.0, accuracy: 0.01)
        XCTAssertEqual(result.hourlyMl, 0.0, accuracy: 0.01)
        XCTAssertEqual(result.dailyPerKg, 0.0, accuracy: 0.01)
    }

    func testHourlyEqualsDailyDividedBy24() {
        let weights = [5.0, 10.0, 15.0, 25.0, 50.0]
        for weight in weights {
            let result = HollidaySegarCalculator.calculate(weightKg: weight)
            XCTAssertEqual(result.hourlyMl, result.dailyMl / 24.0, accuracy: 0.01,
                           "Hourly should equal daily/24 for weight \(weight)kg")
        }
    }
}
