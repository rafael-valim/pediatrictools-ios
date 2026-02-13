import XCTest
@testable import PediatricTools

final class BallardScoreTests: XCTestCase {

    // MARK: - All 5-point step values

    func testScoreMinus10Returns20Weeks() {
        let result = BallardCalculator.gestationalAge(fromScore: -10)
        XCTAssertEqual(result, 20.0, accuracy: 0.01)
    }

    func testScoreMinus5Returns22Weeks() {
        let result = BallardCalculator.gestationalAge(fromScore: -5)
        XCTAssertEqual(result, 22.0, accuracy: 0.01)
    }

    func testScoreZeroReturns24Weeks() {
        let result = BallardCalculator.gestationalAge(fromScore: 0)
        XCTAssertEqual(result, 24.0, accuracy: 0.01)
    }

    func testScore5Returns26Weeks() {
        let result = BallardCalculator.gestationalAge(fromScore: 5)
        XCTAssertEqual(result, 26.0, accuracy: 0.01)
    }

    func testScore10Returns28Weeks() {
        let result = BallardCalculator.gestationalAge(fromScore: 10)
        XCTAssertEqual(result, 28.0, accuracy: 0.01)
    }

    func testScore15Returns30Weeks() {
        let result = BallardCalculator.gestationalAge(fromScore: 15)
        XCTAssertEqual(result, 30.0, accuracy: 0.01)
    }

    func testScore20Returns32Weeks() {
        let result = BallardCalculator.gestationalAge(fromScore: 20)
        XCTAssertEqual(result, 32.0, accuracy: 0.01)
    }

    func testScore25Returns34Weeks() {
        let result = BallardCalculator.gestationalAge(fromScore: 25)
        XCTAssertEqual(result, 34.0, accuracy: 0.01)
    }

    func testScore30Returns36Weeks() {
        let result = BallardCalculator.gestationalAge(fromScore: 30)
        XCTAssertEqual(result, 36.0, accuracy: 0.01)
    }

    func testScore35Returns38Weeks() {
        let result = BallardCalculator.gestationalAge(fromScore: 35)
        XCTAssertEqual(result, 38.0, accuracy: 0.01)
    }

    func testScore40Returns40Weeks() {
        let result = BallardCalculator.gestationalAge(fromScore: 40)
        XCTAssertEqual(result, 40.0, accuracy: 0.01)
    }

    func testScore45Returns42Weeks() {
        let result = BallardCalculator.gestationalAge(fromScore: 45)
        XCTAssertEqual(result, 42.0, accuracy: 0.01)
    }

    func testScore50Returns44Weeks() {
        let result = BallardCalculator.gestationalAge(fromScore: 50)
        XCTAssertEqual(result, 44.0, accuracy: 0.01)
    }

    // MARK: - Clamping below minimum

    func testScoreBelowMinIsClamped() {
        let result = BallardCalculator.gestationalAge(fromScore: -15)
        XCTAssertEqual(result, 20.0, accuracy: 0.01)
    }

    func testScoreFarBelowMinIsClamped() {
        let result = BallardCalculator.gestationalAge(fromScore: -100)
        XCTAssertEqual(result, 20.0, accuracy: 0.01)
    }

    // MARK: - Clamping above maximum

    func testScoreAboveMaxIsClamped() {
        let result = BallardCalculator.gestationalAge(fromScore: 55)
        XCTAssertEqual(result, 44.0, accuracy: 0.01)
    }

    func testScoreLargeValueIsClamped() {
        let result = BallardCalculator.gestationalAge(fromScore: 100)
        XCTAssertEqual(result, 44.0, accuracy: 0.01)
    }

    // MARK: - Non-multiple-of-five scores

    func testPositiveNonMultipleOfFiveScore() {
        // Score 17 → 20.0 + (27 / 5.0) * 2.0 = 20.0 + 10.8 = 30.8 weeks
        let result = BallardCalculator.gestationalAge(fromScore: 17)
        XCTAssertEqual(result, 30.8, accuracy: 0.01)
    }

    func testNegativeNonMultipleOfFiveScore() {
        // Score -3 → 20.0 + (7 / 5.0) * 2.0 = 20.0 + 2.8 = 22.8 weeks
        let result = BallardCalculator.gestationalAge(fromScore: -3)
        XCTAssertEqual(result, 22.8, accuracy: 0.01)
    }

    func testScoreOfOneAppliesFormula() {
        // Score 1 → 20.0 + (11 / 5.0) * 2.0 = 20.0 + 4.4 = 24.4 weeks
        let result = BallardCalculator.gestationalAge(fromScore: 1)
        XCTAssertEqual(result, 24.4, accuracy: 0.01)
    }

    // MARK: - Formula verification

    func testFormulaIsCorrect() {
        // GA = 20.0 + (score + 10) / 5.0 * 2.0
        for score in stride(from: -10, through: 50, by: 1) {
            let expected = 20.0 + (Double(score + 10) / 5.0) * 2.0
            let result = BallardCalculator.gestationalAge(fromScore: score)
            XCTAssertEqual(result, expected, accuracy: 0.001,
                           "Score \(score) should yield GA \(expected) but got \(result)")
        }
    }
}
