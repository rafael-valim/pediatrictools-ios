import XCTest
@testable import PediatricTools

final class ApgarScoreTests: XCTestCase {

    func testScore10IsNormal() {
        XCTAssertEqual(ApgarCalculator.interpretation(score: 10), "apgar_normal")
    }

    func testScore7IsNormal() {
        XCTAssertEqual(ApgarCalculator.interpretation(score: 7), "apgar_normal")
    }

    func testScore6IsModerate() {
        XCTAssertEqual(ApgarCalculator.interpretation(score: 6), "apgar_moderate")
    }

    func testScore4IsModerate() {
        XCTAssertEqual(ApgarCalculator.interpretation(score: 4), "apgar_moderate")
    }

    func testScore3IsSevere() {
        XCTAssertEqual(ApgarCalculator.interpretation(score: 3), "apgar_severe")
    }

    func testScore0IsSevere() {
        XCTAssertEqual(ApgarCalculator.interpretation(score: 0), "apgar_severe")
    }
}
