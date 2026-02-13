import XCTest
@testable import PediatricTools

final class GCSTests: XCTestCase {

    // MARK: - Mild (13–15)

    func testScore15IsMild() {
        XCTAssertEqual(GCSCalculator.interpretation(score: 15), "gcs_mild")
    }

    func testScore14IsMild() {
        XCTAssertEqual(GCSCalculator.interpretation(score: 14), "gcs_mild")
    }

    func testScore13IsMildLowerBoundary() {
        XCTAssertEqual(GCSCalculator.interpretation(score: 13), "gcs_mild")
    }

    // MARK: - Moderate (9–12)

    func testScore12IsModerateUpperBoundary() {
        XCTAssertEqual(GCSCalculator.interpretation(score: 12), "gcs_moderate")
    }

    func testScore11IsModerate() {
        XCTAssertEqual(GCSCalculator.interpretation(score: 11), "gcs_moderate")
    }

    func testScore10IsModerate() {
        XCTAssertEqual(GCSCalculator.interpretation(score: 10), "gcs_moderate")
    }

    func testScore9IsModerateLowerBoundary() {
        XCTAssertEqual(GCSCalculator.interpretation(score: 9), "gcs_moderate")
    }

    // MARK: - Severe (3–8)

    func testScore8IsSevereUpperBoundary() {
        XCTAssertEqual(GCSCalculator.interpretation(score: 8), "gcs_severe")
    }

    func testScore7IsSevere() {
        XCTAssertEqual(GCSCalculator.interpretation(score: 7), "gcs_severe")
    }

    func testScore6IsSevere() {
        XCTAssertEqual(GCSCalculator.interpretation(score: 6), "gcs_severe")
    }

    func testScore5IsSevere() {
        XCTAssertEqual(GCSCalculator.interpretation(score: 5), "gcs_severe")
    }

    func testScore4IsSevere() {
        XCTAssertEqual(GCSCalculator.interpretation(score: 4), "gcs_severe")
    }

    func testScore3IsSevereMinimum() {
        XCTAssertEqual(GCSCalculator.interpretation(score: 3), "gcs_severe")
    }

    // MARK: - Boundary transitions

    func testBoundaryBetweenSevereAndModerate() {
        XCTAssertEqual(GCSCalculator.interpretation(score: 8), "gcs_severe")
        XCTAssertEqual(GCSCalculator.interpretation(score: 9), "gcs_moderate")
    }

    func testBoundaryBetweenModerateAndMild() {
        XCTAssertEqual(GCSCalculator.interpretation(score: 12), "gcs_moderate")
        XCTAssertEqual(GCSCalculator.interpretation(score: 13), "gcs_mild")
    }

    // MARK: - Child criteria structure

    func testChildCriteriaCount() {
        XCTAssertEqual(GCSCriteria.criteria(for: .child).count, 3)
    }

    func testChildMinScoreIs3() {
        let criteria = GCSCriteria.criteria(for: .child)
        let minTotal = criteria.reduce(0) { $0 + $1.minScore }
        XCTAssertEqual(minTotal, 3)
    }

    func testChildMaxScoreIs15() {
        let criteria = GCSCriteria.criteria(for: .child)
        let maxTotal = criteria.reduce(0) { $0 + $1.maxScore }
        XCTAssertEqual(maxTotal, 15)
    }

    // MARK: - Infant criteria structure

    func testInfantCriteriaCount() {
        XCTAssertEqual(GCSCriteria.criteria(for: .infant).count, 3)
    }

    func testInfantMinScoreIs3() {
        let criteria = GCSCriteria.criteria(for: .infant)
        let minTotal = criteria.reduce(0) { $0 + $1.minScore }
        XCTAssertEqual(minTotal, 3)
    }

    func testInfantMaxScoreIs15() {
        let criteria = GCSCriteria.criteria(for: .infant)
        let maxTotal = criteria.reduce(0) { $0 + $1.maxScore }
        XCTAssertEqual(maxTotal, 15)
    }

    // MARK: - Individual component ranges

    func testEyeResponseRange1To4() {
        XCTAssertEqual(GCSCriteria.eye.minScore, 1)
        XCTAssertEqual(GCSCriteria.eye.maxScore, 4)
    }

    func testMotorResponseRange1To6() {
        XCTAssertEqual(GCSCriteria.motor.minScore, 1)
        XCTAssertEqual(GCSCriteria.motor.maxScore, 6)
    }

    func testChildVerbalRange1To5() {
        XCTAssertEqual(GCSCriteria.verbalChild.minScore, 1)
        XCTAssertEqual(GCSCriteria.verbalChild.maxScore, 5)
    }

    func testInfantVerbalRange1To5() {
        XCTAssertEqual(GCSCriteria.verbalInfant.minScore, 1)
        XCTAssertEqual(GCSCriteria.verbalInfant.maxScore, 5)
    }

    // MARK: - Verbal descriptions differ between infant and child

    func testInfantVerbalDescriptionsDifferFromChild() {
        let infantVerbal = GCSCriteria.verbalInfant.descriptions
        let childVerbal = GCSCriteria.verbalChild.descriptions
        XCTAssertNotEqual(infantVerbal[1], childVerbal[1])
    }

    func testInfantAndChildVerbalHaveSameNumberOfLevels() {
        XCTAssertEqual(GCSCriteria.verbalInfant.descriptions.count,
                       GCSCriteria.verbalChild.descriptions.count)
    }

    // MARK: - Eye and motor are shared between age groups

    func testEyeCriterionIsSharedBetweenAgeGroups() {
        let childEye = GCSCriteria.criteria(for: .child)[0]
        let infantEye = GCSCriteria.criteria(for: .infant)[0]
        XCTAssertEqual(childEye.id, infantEye.id)
        XCTAssertEqual(childEye.maxScore, infantEye.maxScore)
    }

    func testMotorCriterionIsSharedBetweenAgeGroups() {
        let childMotor = GCSCriteria.criteria(for: .child)[2]
        let infantMotor = GCSCriteria.criteria(for: .infant)[2]
        XCTAssertEqual(childMotor.id, infantMotor.id)
        XCTAssertEqual(childMotor.maxScore, infantMotor.maxScore)
    }
}
