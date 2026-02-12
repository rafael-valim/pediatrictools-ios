import XCTest
@testable import PediatricTools

final class BallardScoreTests: XCTestCase {

    func testScoreZeroReturns24Weeks() {
        let result = BallardCalculator.gestationalAge(fromScore: 0)
        XCTAssertEqual(result, 24.0, accuracy: 0.01)
    }

    func testScoreMinusTenReturns20Weeks() {
        let result = BallardCalculator.gestationalAge(fromScore: -10)
        XCTAssertEqual(result, 20.0, accuracy: 0.01)
    }

    func testScoreFiftyReturns44Weeks() {
        let result = BallardCalculator.gestationalAge(fromScore: 50)
        XCTAssertEqual(result, 44.0, accuracy: 0.01)
    }

    func testScoreTwentyFiveReturns34Weeks() {
        let result = BallardCalculator.gestationalAge(fromScore: 25)
        XCTAssertEqual(result, 34.0, accuracy: 0.01)
    }

    func testScoreBelowMinIsClamped() {
        // Score -15 should clamp to -10, yielding 20.0 weeks
        let result = BallardCalculator.gestationalAge(fromScore: -15)
        XCTAssertEqual(result, 20.0, accuracy: 0.01)
    }

    func testScoreAboveMaxIsClamped() {
        // Score 55 should clamp to 50, yielding 44.0 weeks
        let result = BallardCalculator.gestationalAge(fromScore: 55)
        XCTAssertEqual(result, 44.0, accuracy: 0.01)
    }

    func testNonMultipleOfFiveScore() {
        // Score 17 → 20.0 + (27 / 5.0) * 2.0 = 20.0 + 10.8 = 30.8 weeks
        let result = BallardCalculator.gestationalAge(fromScore: 17)
        XCTAssertEqual(result, 30.8, accuracy: 0.01)
    }
}
