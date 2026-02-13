import XCTest
@testable import PediatricTools

final class DehydrationTests: XCTestCase {

    // MARK: - Existing tests

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

    // MARK: - All 3 severity levels at 10 kg

    func testTenKgMild5Percent() {
        // deficit = 10 * 5 * 10 = 500, maintenance = 1000, total = 1500
        let result = DehydrationCalculator.calculate(weightKg: 10.0, dehydrationPercent: 5.0)
        XCTAssertEqual(result.deficitMl, 500.0, accuracy: 0.01)
        XCTAssertEqual(result.maintenanceMlPerDay, 1000.0, accuracy: 0.01)
        XCTAssertEqual(result.totalFirst24hMl, 1500.0, accuracy: 0.01)
    }

    func testTenKgModerate7_5Percent() {
        // deficit = 10 * 7.5 * 10 = 750, maintenance = 1000, total = 1750
        let result = DehydrationCalculator.calculate(weightKg: 10.0, dehydrationPercent: 7.5)
        XCTAssertEqual(result.deficitMl, 750.0, accuracy: 0.01)
        XCTAssertEqual(result.maintenanceMlPerDay, 1000.0, accuracy: 0.01)
        XCTAssertEqual(result.totalFirst24hMl, 1750.0, accuracy: 0.01)
    }

    func testTenKgSevere10Percent() {
        // deficit = 10 * 10 * 10 = 1000, maintenance = 1000, total = 2000
        let result = DehydrationCalculator.calculate(weightKg: 10.0, dehydrationPercent: 10.0)
        XCTAssertEqual(result.deficitMl, 1000.0, accuracy: 0.01)
        XCTAssertEqual(result.maintenanceMlPerDay, 1000.0, accuracy: 0.01)
        XCTAssertEqual(result.totalFirst24hMl, 2000.0, accuracy: 0.01)
    }

    // MARK: - Custom low percentage

    func testTenKg3Percent() {
        // deficit = 10 * 3 * 10 = 300, maintenance = 1000, total = 1300
        let result = DehydrationCalculator.calculate(weightKg: 10.0, dehydrationPercent: 3.0)
        XCTAssertEqual(result.deficitMl, 300.0, accuracy: 0.01)
        XCTAssertEqual(result.maintenanceMlPerDay, 1000.0, accuracy: 0.01)
        XCTAssertEqual(result.totalFirst24hMl, 1300.0, accuracy: 0.01)
    }

    // MARK: - Larger weight: 25 kg

    func testTwentyFiveKg5Percent() {
        // deficit = 25 * 5 * 10 = 1250
        // maintenance (HollidaySegar 25kg): 1000 + 50*10 + 20*5 = 1000 + 500 + 100 = 1600
        // total = 1250 + 1600 = 2850
        let result = DehydrationCalculator.calculate(weightKg: 25.0, dehydrationPercent: 5.0)
        XCTAssertEqual(result.deficitMl, 1250.0, accuracy: 0.01)
        XCTAssertEqual(result.maintenanceMlPerDay, 1600.0, accuracy: 0.01)
        XCTAssertEqual(result.totalFirst24hMl, 2850.0, accuracy: 0.01)
    }

    // MARK: - 20 kg at 10%

    func testTwentyKg10Percent() {
        // deficit = 20 * 10 * 10 = 2000
        // maintenance (HollidaySegar 20kg): 1000 + 50*10 = 1500
        // total = 2000 + 1500 = 3500
        let result = DehydrationCalculator.calculate(weightKg: 20.0, dehydrationPercent: 10.0)
        XCTAssertEqual(result.deficitMl, 2000.0, accuracy: 0.01)
        XCTAssertEqual(result.maintenanceMlPerDay, 1500.0, accuracy: 0.01)
        XCTAssertEqual(result.totalFirst24hMl, 3500.0, accuracy: 0.01)
    }

    // MARK: - Deficit formula verification

    func testDeficitFormulaIsWeightTimesPercentTimes10() {
        let testCases: [(weight: Double, percent: Double)] = [
            (5.0, 3.0), (8.0, 5.0), (12.0, 7.5), (15.0, 10.0), (30.0, 6.0)
        ]
        for tc in testCases {
            let result = DehydrationCalculator.calculate(weightKg: tc.weight, dehydrationPercent: tc.percent)
            let expectedDeficit = tc.weight * tc.percent * 10.0
            XCTAssertEqual(result.deficitMl, expectedDeficit, accuracy: 0.01,
                           "Deficit should be weight * percent * 10 for \(tc.weight)kg at \(tc.percent)%")
        }
    }

    // MARK: - Total = deficit + maintenance

    func testTotalEqualsSumOfDeficitAndMaintenance() {
        let testCases: [(weight: Double, percent: Double)] = [
            (5.0, 5.0), (10.0, 7.5), (15.0, 10.0), (25.0, 3.0), (50.0, 5.0)
        ]
        for tc in testCases {
            let result = DehydrationCalculator.calculate(weightKg: tc.weight, dehydrationPercent: tc.percent)
            XCTAssertEqual(result.totalFirst24hMl, result.deficitMl + result.maintenanceMlPerDay, accuracy: 0.01,
                           "Total should equal deficit + maintenance for \(tc.weight)kg at \(tc.percent)%")
        }
    }

    // MARK: - Maintenance matches Holliday-Segar

    func testMaintenanceMatchesHollidaySegar() {
        let weights = [5.0, 10.0, 15.0, 20.0, 25.0, 50.0]
        for weight in weights {
            let dehydrationResult = DehydrationCalculator.calculate(weightKg: weight, dehydrationPercent: 5.0)
            let hsResult = HollidaySegarCalculator.calculate(weightKg: weight)
            XCTAssertEqual(dehydrationResult.maintenanceMlPerDay, hsResult.dailyMl, accuracy: 0.01,
                           "Maintenance should match Holliday-Segar daily for \(weight)kg")
        }
    }

    // MARK: - Zero percent dehydration

    func testZeroPercentReturnsAllZeros() {
        // guard clause requires dehydrationPercent > 0
        let result = DehydrationCalculator.calculate(weightKg: 10.0, dehydrationPercent: 0.0)
        XCTAssertEqual(result.deficitMl, 0.0, accuracy: 0.01)
        XCTAssertEqual(result.maintenanceMlPerDay, 0.0, accuracy: 0.01)
        XCTAssertEqual(result.totalFirst24hMl, 0.0, accuracy: 0.01)
    }

    // MARK: - Small infant weight

    func testSmallInfant3Kg5Percent() {
        // deficit = 3 * 5 * 10 = 150
        // maintenance (HollidaySegar 3kg) = 300
        // total = 450
        let result = DehydrationCalculator.calculate(weightKg: 3.0, dehydrationPercent: 5.0)
        XCTAssertEqual(result.deficitMl, 150.0, accuracy: 0.01)
        XCTAssertEqual(result.maintenanceMlPerDay, 300.0, accuracy: 0.01)
        XCTAssertEqual(result.totalFirst24hMl, 450.0, accuracy: 0.01)
    }
}
