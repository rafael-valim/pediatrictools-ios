import XCTest
@testable import PediatricTools

final class PEWSScoreTests: XCTestCase {

    func testScore0IsLowRisk() {
        XCTAssertEqual(PEWSCalculator.interpretation(score: 0), "pews_low_risk")
    }

    func testScore2IsLowRisk() {
        XCTAssertEqual(PEWSCalculator.interpretation(score: 2), "pews_low_risk")
    }

    func testScore3IsModerateRisk() {
        XCTAssertEqual(PEWSCalculator.interpretation(score: 3), "pews_moderate_risk")
    }

    func testScore4IsModerateRisk() {
        XCTAssertEqual(PEWSCalculator.interpretation(score: 4), "pews_moderate_risk")
    }

    func testScore5IsHighRisk() {
        XCTAssertEqual(PEWSCalculator.interpretation(score: 5), "pews_high_risk")
    }

    func testScore9IsHighRisk() {
        XCTAssertEqual(PEWSCalculator.interpretation(score: 9), "pews_high_risk")
    }
}
