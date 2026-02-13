import XCTest
@testable import PediatricTools

final class CorrectedAgeTests: XCTestCase {

    private let calendar = Calendar.current

    // MARK: - Existing tests

    func testFullTermGACorrectedEqualsChronological() {
        // 40 weeks GA -> prematurity = 0, corrected = chronological
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

    // MARK: - GA with days component

    func testGA32Weeks4DaysAt100DaysOld() {
        // GA = 32w 4d = 228 days
        // prematurityDays = 280 - 228 = 52 days = 7 weeks 3 days
        // prematurityWeeks (integer division) = 52 / 7 = 7
        // chronoDays = 100 -> 14w 2d
        // correctedDays = 100 - 52 = 48 days = 6w 6d
        let birthDate = Date()
        let currentDate = calendar.date(byAdding: .day, value: 100, to: birthDate)!

        let result = CorrectedAgeCalculator.calculate(
            birthDate: birthDate,
            currentDate: currentDate,
            gestationalAgeWeeks: 32,
            gestationalAgeDays: 4
        )

        XCTAssertEqual(result.prematurityWeeks, 7) // 52 / 7 = 7
        XCTAssertEqual(result.chronologicalAgeWeeks, 14)
        XCTAssertEqual(result.chronologicalAgeDays, 2)
        XCTAssertEqual(result.correctedAgeWeeks, 6)  // 48 / 7 = 6
        XCTAssertEqual(result.correctedAgeDays, 6)   // 48 % 7 = 6
    }

    // MARK: - Post-term (GA >= 40 weeks)

    func testPostTerm41WeeksCorrectedEqualsChronological() {
        // GA = 41w 0d = 287 days
        // prematurityDays = max(0, 280 - 287) = 0
        // So corrected == chronological
        let birthDate = Date()
        let currentDate = calendar.date(byAdding: .day, value: 60, to: birthDate)!

        let result = CorrectedAgeCalculator.calculate(
            birthDate: birthDate,
            currentDate: currentDate,
            gestationalAgeWeeks: 41,
            gestationalAgeDays: 0
        )

        XCTAssertEqual(result.prematurityWeeks, 0)
        XCTAssertEqual(result.correctedAgeWeeks, result.chronologicalAgeWeeks)
        XCTAssertEqual(result.correctedAgeDays, result.chronologicalAgeDays)
        XCTAssertEqual(result.chronologicalAgeWeeks, 8)
        XCTAssertEqual(result.chronologicalAgeDays, 4)
    }

    // MARK: - Very preterm (22 weeks)

    func testVeryPreterm22WeeksAt200DaysOld() {
        // GA = 22w 0d = 154 days
        // prematurityDays = 280 - 154 = 126 days = 18 weeks
        // chronoDays = 200 -> 28w 4d
        // correctedDays = 200 - 126 = 74 days = 10w 4d
        let birthDate = Date()
        let currentDate = calendar.date(byAdding: .day, value: 200, to: birthDate)!

        let result = CorrectedAgeCalculator.calculate(
            birthDate: birthDate,
            currentDate: currentDate,
            gestationalAgeWeeks: 22,
            gestationalAgeDays: 0
        )

        XCTAssertEqual(result.prematurityWeeks, 18)
        XCTAssertEqual(result.chronologicalAgeWeeks, 28)
        XCTAssertEqual(result.chronologicalAgeDays, 4)
        XCTAssertEqual(result.correctedAgeWeeks, 10)
        XCTAssertEqual(result.correctedAgeDays, 4)
    }

    // MARK: - Full-term newborn at 7 days old

    func testFullTerm40WeeksAt7DaysOld() {
        // GA = 40w 0d, prematurity = 0
        // chronoDays = 7 -> 1w 0d
        // corrected = chronological
        let birthDate = Date()
        let currentDate = calendar.date(byAdding: .day, value: 7, to: birthDate)!

        let result = CorrectedAgeCalculator.calculate(
            birthDate: birthDate,
            currentDate: currentDate,
            gestationalAgeWeeks: 40,
            gestationalAgeDays: 0
        )

        XCTAssertEqual(result.prematurityWeeks, 0)
        XCTAssertEqual(result.chronologicalAgeWeeks, 1)
        XCTAssertEqual(result.chronologicalAgeDays, 0)
        XCTAssertEqual(result.correctedAgeWeeks, 1)
        XCTAssertEqual(result.correctedAgeDays, 0)
    }

    // MARK: - Late preterm (36 weeks) at 70 days

    func testLatePreterm36WeeksAt70DaysOld() {
        // GA = 36w 0d = 252 days
        // prematurityDays = 280 - 252 = 28 days = 4 weeks
        // chronoDays = 70 -> 10w 0d
        // correctedDays = 70 - 28 = 42 days = 6w 0d
        let birthDate = Date()
        let currentDate = calendar.date(byAdding: .day, value: 70, to: birthDate)!

        let result = CorrectedAgeCalculator.calculate(
            birthDate: birthDate,
            currentDate: currentDate,
            gestationalAgeWeeks: 36,
            gestationalAgeDays: 0
        )

        XCTAssertEqual(result.prematurityWeeks, 4)
        XCTAssertEqual(result.chronologicalAgeWeeks, 10)
        XCTAssertEqual(result.chronologicalAgeDays, 0)
        XCTAssertEqual(result.correctedAgeWeeks, 6)
        XCTAssertEqual(result.correctedAgeDays, 0)
    }

    // MARK: - Chronological age breakdown verification

    func testChronologicalAge100DaysIs14Weeks2Days() {
        let birthDate = Date()
        let currentDate = calendar.date(byAdding: .day, value: 100, to: birthDate)!

        let result = CorrectedAgeCalculator.calculate(
            birthDate: birthDate,
            currentDate: currentDate,
            gestationalAgeWeeks: 40,
            gestationalAgeDays: 0
        )

        // 100 / 7 = 14 weeks remainder 2 days
        XCTAssertEqual(result.chronologicalAgeWeeks, 14)
        XCTAssertEqual(result.chronologicalAgeDays, 2)
    }

    // MARK: - Corrected age clamps to zero when prematurity > chronological

    func testCorrectedAgeDoesNotGoNegative() {
        // 24 week preemie at 1 day old
        // prematurityDays = 280 - 168 = 112 days
        // chronoDays = 1
        // correctedDays = max(0, 1 - 112) = 0
        let birthDate = Date()
        let currentDate = calendar.date(byAdding: .day, value: 1, to: birthDate)!

        let result = CorrectedAgeCalculator.calculate(
            birthDate: birthDate,
            currentDate: currentDate,
            gestationalAgeWeeks: 24,
            gestationalAgeDays: 0
        )

        XCTAssertEqual(result.prematurityWeeks, 16) // 112 / 7 = 16
        XCTAssertEqual(result.correctedAgeWeeks, 0)
        XCTAssertEqual(result.correctedAgeDays, 0)
    }

    // MARK: - GA with days: 37 weeks 3 days

    func testGA37Weeks3DaysAt50DaysOld() {
        // GA = 37w 3d = 262 days
        // prematurityDays = 280 - 262 = 18 days = 2 weeks (18/7 = 2)
        // chronoDays = 50 -> 7w 1d
        // correctedDays = 50 - 18 = 32 days = 4w 4d
        let birthDate = Date()
        let currentDate = calendar.date(byAdding: .day, value: 50, to: birthDate)!

        let result = CorrectedAgeCalculator.calculate(
            birthDate: birthDate,
            currentDate: currentDate,
            gestationalAgeWeeks: 37,
            gestationalAgeDays: 3
        )

        XCTAssertEqual(result.prematurityWeeks, 2) // 18 / 7 = 2
        XCTAssertEqual(result.chronologicalAgeWeeks, 7)
        XCTAssertEqual(result.chronologicalAgeDays, 1)
        XCTAssertEqual(result.correctedAgeWeeks, 4)  // 32 / 7 = 4
        XCTAssertEqual(result.correctedAgeDays, 4)   // 32 % 7 = 4
    }
}
