import XCTest
@testable import PediatricTools

final class PRAMScoreTests: XCTestCase {

    func testScore0IsMild() {
        XCTAssertEqual(PRAMCalculator.interpretation(score: 0), "pram_mild")
    }

    func testScore3IsMild() {
        XCTAssertEqual(PRAMCalculator.interpretation(score: 3), "pram_mild")
    }

    func testScore4IsModerate() {
        XCTAssertEqual(PRAMCalculator.interpretation(score: 4), "pram_moderate")
    }

    func testScore7IsModerate() {
        XCTAssertEqual(PRAMCalculator.interpretation(score: 7), "pram_moderate")
    }

    func testScore8IsSevere() {
        XCTAssertEqual(PRAMCalculator.interpretation(score: 8), "pram_severe")
    }

    func testScore12IsSevere() {
        XCTAssertEqual(PRAMCalculator.interpretation(score: 12), "pram_severe")
    }

    func testCriteriaCount() {
        XCTAssertEqual(PRAMCriteria.all.count, 5)
    }

    func testMaxPossibleScore() {
        let maxTotal = PRAMCriteria.all.reduce(0) { $0 + $1.maxScore }
        XCTAssertEqual(maxTotal, 12) // 2 + 2 + 2 + 3 + 3 = 12
    }
}
