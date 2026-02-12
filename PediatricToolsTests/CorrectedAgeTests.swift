import XCTest
@testable import PediatricTools

final class CorrectedAgeTests: XCTestCase {

    private let calendar = Calendar.current

    func testFullTermGACorrectedEqualsChronological() {
        // 40 weeks GA → prematurity = 0, corrected = chronological
        let birthDate = Date()
        let currentDate = calendar.date(byAdding: .day, value: 100, to: birthDate)!

        let result = CorrectedAgeCalculator.calculate(
            birthDate: birthDate,
            currentDate: currentDate,
            gestationalAgeWeeks: 40,
            gestationalAgeDays: 0
        )

        XCTAssertEqual(result.prematurityWeeks, 0)
        XCTAssertEqual(result.correctedAgeWeeks, result.chronologicalAgeWeeks)
        XCTAssertEqual(result.correctedAgeDays, result.chronologicalAgeDays)
    }

    func testPreterm28WeeksAt140DaysOld() {
        // 28 weeks GA, 140 days old
        // prematurityDays = 40*7 - 28*7 = 280 - 196 = 84 days = 12 weeks
        // correctedDays = 140 - 84 = 56 days = 8 weeks 0 days
        let birthDate = Date()
        let currentDate = calendar.date(byAdding: .day, value: 140, to: birthDate)!

        let result = CorrectedAgeCalculator.calculate(
            birthDate: birthDate,
            currentDate: currentDate,
            gestationalAgeWeeks: 28,
            gestationalAgeDays: 0
        )

        XCTAssertEqual(result.prematurityWeeks, 12)
        XCTAssertEqual(result.correctedAgeWeeks, 8)
        XCTAssertEqual(result.correctedAgeDays, 0)
        XCTAssertEqual(result.chronologicalAgeWeeks, 20)
        XCTAssertEqual(result.chronologicalAgeDays, 0)
    }

    func testSameDayBirthReturnsZeros() {
        let birthDate = Date()

        let result = CorrectedAgeCalculator.calculate(
            birthDate: birthDate,
            currentDate: birthDate,
            gestationalAgeWeeks: 32,
            gestationalAgeDays: 0
        )

        XCTAssertEqual(result.chronologicalAgeWeeks, 0)
        XCTAssertEqual(result.chronologicalAgeDays, 0)
        XCTAssertEqual(result.correctedAgeWeeks, 0)
        XCTAssertEqual(result.correctedAgeDays, 0)
    }
}
