import XCTest
@testable import PediatricTools

final class GCSTests: XCTestCase {

    func testScore15IsMild() {
        XCTAssertEqual(GCSCalculator.interpretation(score: 15), "gcs_mild")
    }

    func testScore13IsMild() {
        XCTAssertEqual(GCSCalculator.interpretation(score: 13), "gcs_mild")
    }

    func testScore12IsModerate() {
        XCTAssertEqual(GCSCalculator.interpretation(score: 12), "gcs_moderate")
    }

    func testScore9IsModerate() {
        XCTAssertEqual(GCSCalculator.interpretation(score: 9), "gcs_moderate")
    }

    func testScore8IsSevere() {
        XCTAssertEqual(GCSCalculator.interpretation(score: 8), "gcs_severe")
    }

    func testScore3IsSevere() {
        XCTAssertEqual(GCSCalculator.interpretation(score: 3), "gcs_severe")
    }

    func testChildCriteriaCount() {
        XCTAssertEqual(GCSCriteria.criteria(for: .child).count, 3)
    }

    func testInfantCriteriaCount() {
        XCTAssertEqual(GCSCriteria.criteria(for: .infant).count, 3)
    }

    func testMinScoreIs3() {
        // Eye min 1 + Verbal min 1 + Motor min 1 = 3
        let criteria = GCSCriteria.criteria(for: .child)
        let minTotal = criteria.reduce(0) { $0 + $1.minScore }
        XCTAssertEqual(minTotal, 3)
    }

    func testMaxScoreIs15() {
        // Eye max 4 + Verbal max 5 + Motor max 6 = 15
        let criteria = GCSCriteria.criteria(for: .child)
        let maxTotal = criteria.reduce(0) { $0 + $1.maxScore }
        XCTAssertEqual(maxTotal, 15)
    }

    func testInfantVerbalDescriptionsDifferFromChild() {
        let infantVerbal = GCSCriteria.verbalInfant.descriptions
        let childVerbal = GCSCriteria.verbalChild.descriptions
        XCTAssertNotEqual(infantVerbal[1], childVerbal[1])
    }
}
