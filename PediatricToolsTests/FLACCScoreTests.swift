import XCTest
@testable import PediatricTools

final class FLACCScoreTests: XCTestCase {

    // MARK: - Relaxed (0)

    func testScore0IsRelaxed() {
        XCTAssertEqual(FLACCCalculator.interpretation(score: 0), "flacc_relaxed")
    }

    // MARK: - Mild (1–3)

    func testScore1IsMildLowerBoundary() {
        XCTAssertEqual(FLACCCalculator.interpretation(score: 1), "flacc_mild")
    }

    func testScore2IsMildMiddle() {
        XCTAssertEqual(FLACCCalculator.interpretation(score: 2), "flacc_mild")
    }

    func testScore3IsMildUpperBoundary() {
        XCTAssertEqual(FLACCCalculator.interpretation(score: 3), "flacc_mild")
    }

    // MARK: - Moderate (4–6)

    func testScore4IsModerateLowerBoundary() {
        XCTAssertEqual(FLACCCalculator.interpretation(score: 4), "flacc_moderate")
    }

    func testScore5IsModerateMiddle() {
        XCTAssertEqual(FLACCCalculator.interpretation(score: 5), "flacc_moderate")
    }

    func testScore6IsModerateUpperBoundary() {
        XCTAssertEqual(FLACCCalculator.interpretation(score: 6), "flacc_moderate")
    }

    // MARK: - Severe (7–10)

    func testScore7IsSevereLowerBoundary() {
        XCTAssertEqual(FLACCCalculator.interpretation(score: 7), "flacc_severe")
    }

    func testScore8IsSevere() {
        XCTAssertEqual(FLACCCalculator.interpretation(score: 8), "flacc_severe")
    }

    func testScore9IsSevere() {
        XCTAssertEqual(FLACCCalculator.interpretation(score: 9), "flacc_severe")
    }

    func testScore10IsSevereMaximum() {
        XCTAssertEqual(FLACCCalculator.interpretation(score: 10), "flacc_severe")
    }

    // MARK: - Boundary transitions

    func testBoundaryBetweenRelaxedAndMild() {
        XCTAssertEqual(FLACCCalculator.interpretation(score: 0), "flacc_relaxed")
        XCTAssertEqual(FLACCCalculator.interpretation(score: 1), "flacc_mild")
    }

    func testBoundaryBetweenMildAndModerate() {
        XCTAssertEqual(FLACCCalculator.interpretation(score: 3), "flacc_mild")
        XCTAssertEqual(FLACCCalculator.interpretation(score: 4), "flacc_moderate")
    }

    func testBoundaryBetweenModerateAndSevere() {
        XCTAssertEqual(FLACCCalculator.interpretation(score: 6), "flacc_moderate")
        XCTAssertEqual(FLACCCalculator.interpretation(score: 7), "flacc_severe")
    }

    // MARK: - Criteria

    func testCriteriaCount() {
        XCTAssertEqual(FLACCCriteria.all.count, 5)
    }

    func testMaxPossibleScore() {
        // 5 criteria x max 2 each = 10
        let maxTotal = FLACCCriteria.all.count * 2
        XCTAssertEqual(maxTotal, 10)
    }

    func testEachCriterionMaxScoreIs2() {
        for criterion in FLACCCriteria.all {
            XCTAssertEqual(criterion.descriptions.count, 3,
                           "Criterion \(criterion.id) should have 3 score levels (0, 1, 2)")
        }
    }

    func testEachCriterionHasScoresZeroOneTwo() {
        for criterion in FLACCCriteria.all {
            XCTAssertNotNil(criterion.descriptions[0], "Criterion \(criterion.id) missing score 0")
            XCTAssertNotNil(criterion.descriptions[1], "Criterion \(criterion.id) missing score 1")
            XCTAssertNotNil(criterion.descriptions[2], "Criterion \(criterion.id) missing score 2")
        }
    }
}
