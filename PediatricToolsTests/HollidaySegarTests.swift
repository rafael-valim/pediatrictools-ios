import XCTest
@testable import PediatricTools

final class HollidaySegarTests: XCTestCase {

    // MARK: - Basic weight tiers

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

    // MARK: - Exact breakpoints

    func testExactBreakpoint10Kg() {
        // First 10 kg at 100 mL/kg/day = 1000 mL
        let result = HollidaySegarCalculator.calculate(weightKg: 10.0)
        XCTAssertEqual(result.dailyMl, 1000.0, accuracy: 0.01)
    }

    func testExactBreakpoint20Kg() {
        // First 10 kg: 1000 mL + next 10 kg at 50 mL/kg: 500 mL = 1500 mL
        let result = HollidaySegarCalculator.calculate(weightKg: 20.0)
        XCTAssertEqual(result.dailyMl, 1500.0, accuracy: 0.01)
        XCTAssertEqual(result.hourlyMl, 1500.0 / 24.0, accuracy: 0.01)
    }

    // MARK: - Fractional weights

    func testFractionalWeight10_5Kg() {
        // 10 kg tier: 1000 mL + 0.5 kg at 50 mL/kg = 1025 mL
        let result = HollidaySegarCalculator.calculate(weightKg: 10.5)
        XCTAssertEqual(result.dailyMl, 1025.0, accuracy: 0.01)
        XCTAssertEqual(result.hourlyMl, 1025.0 / 24.0, accuracy: 0.01)
    }

    // MARK: - Large weights

    func testLargeWeight50Kg() {
        // First 10 kg: 1000 + next 10 kg: 500 + 30 kg at 20 mL/kg: 600 = 2100 mL
        let result = HollidaySegarCalculator.calculate(weightKg: 50.0)
        XCTAssertEqual(result.dailyMl, 2100.0, accuracy: 0.01)
        XCTAssertEqual(result.hourlyMl, 2100.0 / 24.0, accuracy: 0.01)
    }

    func testVeryLargeWeight100Kg() {
        // First 10 kg: 1000 + next 10 kg: 500 + 80 kg at 20 mL/kg: 1600 = 3100 mL
        let result = HollidaySegarCalculator.calculate(weightKg: 100.0)
        XCTAssertEqual(result.dailyMl, 3100.0, accuracy: 0.01)
        XCTAssertEqual(result.hourlyMl, 3100.0 / 24.0, accuracy: 0.01)
    }

    // MARK: - dailyPerKg consistency

    func testDailyPerKgEqualsDailyDividedByWeight() {
        let weights = [3.0, 5.0, 8.0, 10.0, 10.5, 15.0, 20.0, 25.0, 50.0, 100.0]
        for weight in weights {
            let result = HollidaySegarCalculator.calculate(weightKg: weight)
            XCTAssertEqual(result.dailyPerKg, result.dailyMl / weight, accuracy: 0.01,
                           "dailyPerKg should equal dailyMl/weight for \(weight)kg")
        }
    }

    func testDailyPerKgFirstTierIs100() {
        // For weights <= 10 kg, daily per kg should always be 100 mL/kg/day
        let weights = [1.0, 3.0, 5.0, 7.5, 10.0]
        for weight in weights {
            let result = HollidaySegarCalculator.calculate(weightKg: weight)
            XCTAssertEqual(result.dailyPerKg, 100.0, accuracy: 0.01,
                           "dailyPerKg should be 100 for weight \(weight)kg (first tier)")
        }
    }

    // MARK: - Negative weight

    func testNegativeWeightReturnsAllZeros() {
        let result = HollidaySegarCalculator.calculate(weightKg: -5.0)
        XCTAssertEqual(result.dailyMl, 0.0, accuracy: 0.01)
        XCTAssertEqual(result.hourlyMl, 0.0, accuracy: 0.01)
        XCTAssertEqual(result.dailyPerKg, 0.0, accuracy: 0.01)
    }
}
