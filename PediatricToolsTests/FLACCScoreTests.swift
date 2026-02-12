import XCTest
@testable import PediatricTools

final class FLACCScoreTests: XCTestCase {

    func testScore0IsRelaxed() {
        XCTAssertEqual(FLACCCalculator.interpretation(score: 0), "flacc_relaxed")
    }

    func testScore1IsMild() {
        XCTAssertEqual(FLACCCalculator.interpretation(score: 1), "flacc_mild")
    }

    func testScore3IsMild() {
        XCTAssertEqual(FLACCCalculator.interpretation(score: 3), "flacc_mild")
    }

    func testScore4IsModerate() {
        XCTAssertEqual(FLACCCalculator.interpretation(score: 4), "flacc_moderate")
    }

    func testScore6IsModerate() {
        XCTAssertEqual(FLACCCalculator.interpretation(score: 6), "flacc_moderate")
    }

    func testScore7IsSevere() {
        XCTAssertEqual(FLACCCalculator.interpretation(score: 7), "flacc_severe")
    }

    func testScore10IsSevere() {
        XCTAssertEqual(FLACCCalculator.interpretation(score: 10), "flacc_severe")
    }

    func testCriteriaCount() {
        XCTAssertEqual(FLACCCriteria.all.count, 5)
    }
}
