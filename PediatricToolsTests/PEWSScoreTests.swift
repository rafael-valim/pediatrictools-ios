import XCTest
@testable import PediatricTools

final class PEWSScoreTests: XCTestCase {

    // MARK: - Low risk (0–2)

    func testScore0IsLowRisk() {
        XCTAssertEqual(PEWSCalculator.interpretation(score: 0), "pews_low_risk")
    }

    func testScore1IsLowRisk() {
        XCTAssertEqual(PEWSCalculator.interpretation(score: 1), "pews_low_risk")
    }

    func testScore2IsLowRiskUpperBoundary() {
        XCTAssertEqual(PEWSCalculator.interpretation(score: 2), "pews_low_risk")
    }

    // MARK: - Moderate risk (3–4)

    func testScore3IsModerateRiskLowerBoundary() {
        XCTAssertEqual(PEWSCalculator.interpretation(score: 3), "pews_moderate_risk")
    }

    func testScore4IsModerateRiskUpperBoundary() {
        XCTAssertEqual(PEWSCalculator.interpretation(score: 4), "pews_moderate_risk")
    }

    // MARK: - High risk (5+)

    func testScore5IsHighRiskLowerBoundary() {
        XCTAssertEqual(PEWSCalculator.interpretation(score: 5), "pews_high_risk")
    }

    func testScore6IsHighRisk() {
        XCTAssertEqual(PEWSCalculator.interpretation(score: 6), "pews_high_risk")
    }

    func testScore7IsHighRisk() {
        XCTAssertEqual(PEWSCalculator.interpretation(score: 7), "pews_high_risk")
    }

    func testScore8IsHighRisk() {
        XCTAssertEqual(PEWSCalculator.interpretation(score: 8), "pews_high_risk")
    }

    func testScore9IsHighRiskMaximum() {
        XCTAssertEqual(PEWSCalculator.interpretation(score: 9), "pews_high_risk")
    }

    // MARK: - Boundary transitions

    func testBoundaryBetweenLowAndModerate() {
        XCTAssertEqual(PEWSCalculator.interpretation(score: 2), "pews_low_risk")
        XCTAssertEqual(PEWSCalculator.interpretation(score: 3), "pews_moderate_risk")
    }

    func testBoundaryBetweenModerateAndHigh() {
        XCTAssertEqual(PEWSCalculator.interpretation(score: 4), "pews_moderate_risk")
        XCTAssertEqual(PEWSCalculator.interpretation(score: 5), "pews_high_risk")
    }

    // MARK: - Criteria

    func testCriteriaCount() {
        XCTAssertEqual(PEWSCriteria.all.count, 3)
    }

    func testMaxPossibleScore() {
        // 3 criteria x max 3 each = 9
        let maxTotal = PEWSCriteria.all.reduce(0) { $0 + $1.maxScore }
        XCTAssertEqual(maxTotal, 9)
    }

    func testEachCriterionMaxScoreIs3() {
        for criterion in PEWSCriteria.all {
            XCTAssertEqual(criterion.maxScore, 3, "Criterion \(criterion.id) should have maxScore 3")
        }
    }

    func testEachCriterionHasFourScoreLevels() {
        for criterion in PEWSCriteria.all {
            XCTAssertEqual(criterion.descriptions.count, 4, "Criterion \(criterion.id) should have 4 description levels (0-3)")
        }
    }
}
