import XCTest
@testable import PediatricTools

final class ApgarScoreTests: XCTestCase {

    // MARK: - Normal (7–10)

    func testScore10IsNormal() {
        XCTAssertEqual(ApgarCalculator.interpretation(score: 10), "apgar_normal")
    }

    func testScore9IsNormal() {
        XCTAssertEqual(ApgarCalculator.interpretation(score: 9), "apgar_normal")
    }

    func testScore8IsNormal() {
        XCTAssertEqual(ApgarCalculator.interpretation(score: 8), "apgar_normal")
    }

    func testScore7IsNormalLowerBoundary() {
        XCTAssertEqual(ApgarCalculator.interpretation(score: 7), "apgar_normal")
    }

    // MARK: - Moderate (4–6)

    func testScore6IsModerateUpperBoundary() {
        XCTAssertEqual(ApgarCalculator.interpretation(score: 6), "apgar_moderate")
    }

    func testScore5IsModerate() {
        XCTAssertEqual(ApgarCalculator.interpretation(score: 5), "apgar_moderate")
    }

    func testScore4IsModerateLowerBoundary() {
        XCTAssertEqual(ApgarCalculator.interpretation(score: 4), "apgar_moderate")
    }

    // MARK: - Severe (0–3)

    func testScore3IsSevereUpperBoundary() {
        XCTAssertEqual(ApgarCalculator.interpretation(score: 3), "apgar_severe")
    }

    func testScore2IsSevere() {
        XCTAssertEqual(ApgarCalculator.interpretation(score: 2), "apgar_severe")
    }

    func testScore1IsSevere() {
        XCTAssertEqual(ApgarCalculator.interpretation(score: 1), "apgar_severe")
    }

    func testScore0IsSevere() {
        XCTAssertEqual(ApgarCalculator.interpretation(score: 0), "apgar_severe")
    }

    // MARK: - Boundary transitions

    func testBoundaryBetweenSevereAndModerate() {
        XCTAssertEqual(ApgarCalculator.interpretation(score: 3), "apgar_severe")
        XCTAssertEqual(ApgarCalculator.interpretation(score: 4), "apgar_moderate")
    }

    func testBoundaryBetweenModerateAndNormal() {
        XCTAssertEqual(ApgarCalculator.interpretation(score: 6), "apgar_moderate")
        XCTAssertEqual(ApgarCalculator.interpretation(score: 7), "apgar_normal")
    }

    // MARK: - Criteria

    func testCriteriaCount() {
        XCTAssertEqual(ApgarCriteria.all.count, 5)
    }

    func testEachCriterionHasThreeScoreLevels() {
        for criterion in ApgarCriteria.all {
            XCTAssertEqual(criterion.descriptions.count, 3, "Criterion \(criterion.id) should have 3 score levels")
        }
    }

    func testMaxPossibleScore() {
        // 5 criteria x max 2 each = 10
        let maxTotal = ApgarCriteria.all.count * 2
        XCTAssertEqual(maxTotal, 10)
    }
}
