import XCTest
@testable import PediatricTools

final class PRAMScoreTests: XCTestCase {

    // MARK: - Mild (0–3)

    func testScore0IsMild() {
        XCTAssertEqual(PRAMCalculator.interpretation(score: 0), "pram_mild")
    }

    func testScore1IsMild() {
        XCTAssertEqual(PRAMCalculator.interpretation(score: 1), "pram_mild")
    }

    func testScore2IsMild() {
        XCTAssertEqual(PRAMCalculator.interpretation(score: 2), "pram_mild")
    }

    func testScore3IsMildUpperBoundary() {
        XCTAssertEqual(PRAMCalculator.interpretation(score: 3), "pram_mild")
    }

    // MARK: - Moderate (4–7)

    func testScore4IsModerateLowerBoundary() {
        XCTAssertEqual(PRAMCalculator.interpretation(score: 4), "pram_moderate")
    }

    func testScore5IsModerate() {
        XCTAssertEqual(PRAMCalculator.interpretation(score: 5), "pram_moderate")
    }

    func testScore6IsModerate() {
        XCTAssertEqual(PRAMCalculator.interpretation(score: 6), "pram_moderate")
    }

    func testScore7IsModerateUpperBoundary() {
        XCTAssertEqual(PRAMCalculator.interpretation(score: 7), "pram_moderate")
    }

    // MARK: - Severe (8–12)

    func testScore8IsSevereLowerBoundary() {
        XCTAssertEqual(PRAMCalculator.interpretation(score: 8), "pram_severe")
    }

    func testScore9IsSevere() {
        XCTAssertEqual(PRAMCalculator.interpretation(score: 9), "pram_severe")
    }

    func testScore10IsSevere() {
        XCTAssertEqual(PRAMCalculator.interpretation(score: 10), "pram_severe")
    }

    func testScore11IsSevere() {
        XCTAssertEqual(PRAMCalculator.interpretation(score: 11), "pram_severe")
    }

    func testScore12IsSevereMaximum() {
        XCTAssertEqual(PRAMCalculator.interpretation(score: 12), "pram_severe")
    }

    // MARK: - Boundary transitions

    func testBoundaryBetweenMildAndModerate() {
        XCTAssertEqual(PRAMCalculator.interpretation(score: 3), "pram_mild")
        XCTAssertEqual(PRAMCalculator.interpretation(score: 4), "pram_moderate")
    }

    func testBoundaryBetweenModerateAndSevere() {
        XCTAssertEqual(PRAMCalculator.interpretation(score: 7), "pram_moderate")
        XCTAssertEqual(PRAMCalculator.interpretation(score: 8), "pram_severe")
    }

    // MARK: - Criteria structure

    func testCriteriaCount() {
        XCTAssertEqual(PRAMCriteria.all.count, 5)
    }

    func testMaxPossibleScore() {
        let maxTotal = PRAMCriteria.all.reduce(0) { $0 + $1.maxScore }
        XCTAssertEqual(maxTotal, 12) // 2 + 2 + 2 + 3 + 3 = 12
    }

    // MARK: - Individual criteria max scores

    func testOxygenSaturationMaxScoreIs2() {
        XCTAssertEqual(PRAMCriteria.oxygenSaturation.maxScore, 2)
    }

    func testSuprasternalRetractionsMaxScoreIs2() {
        XCTAssertEqual(PRAMCriteria.suprasternalRetractions.maxScore, 2)
    }

    func testScaleneMuscleMaxScoreIs2() {
        XCTAssertEqual(PRAMCriteria.scaleneMuscle.maxScore, 2)
    }

    func testAirEntryMaxScoreIs3() {
        XCTAssertEqual(PRAMCriteria.airEntry.maxScore, 3)
    }

    func testWheezingMaxScoreIs3() {
        XCTAssertEqual(PRAMCriteria.wheezing.maxScore, 3)
    }

    // MARK: - Criteria description counts match max scores

    func testEachCriterionHasCorrectNumberOfDescriptions() {
        for criterion in PRAMCriteria.all {
            let expectedCount = criterion.maxScore + 1 // scores 0 through maxScore
            XCTAssertEqual(criterion.descriptions.count, expectedCount,
                           "Criterion \(criterion.id) should have \(expectedCount) descriptions")
        }
    }
}
