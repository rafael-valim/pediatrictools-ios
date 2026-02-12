import XCTest
@testable import PediatricTools

final class PECARNTests: XCTestCase {

    // MARK: - Under 2 years

    func testUnder2NoCriteriaIsVeryLow() {
        let risk = PECARNCalculator.evaluate(ageGroup: .underTwo, positiveCriteria: [])
        XCTAssertEqual(risk, .veryLow)
    }

    func testUnder2AlteredMentalStatusIsHigher() {
        let risk = PECARNCalculator.evaluate(ageGroup: .underTwo, positiveCriteria: ["ams_under2"])
        XCTAssertEqual(risk, .higher)
    }

    func testUnder2SkullFractureIsHigher() {
        let risk = PECARNCalculator.evaluate(ageGroup: .underTwo, positiveCriteria: ["skull_fracture"])
        XCTAssertEqual(risk, .higher)
    }

    func testUnder2LOCIsIntermediate() {
        let risk = PECARNCalculator.evaluate(ageGroup: .underTwo, positiveCriteria: ["loc_under2"])
        XCTAssertEqual(risk, .intermediate)
    }

    func testUnder2SevereMechanismIsIntermediate() {
        let risk = PECARNCalculator.evaluate(ageGroup: .underTwo, positiveCriteria: ["mechanism_under2"])
        XCTAssertEqual(risk, .intermediate)
    }

    func testUnder2HematomaIsIntermediate() {
        let risk = PECARNCalculator.evaluate(ageGroup: .underTwo, positiveCriteria: ["hematoma"])
        XCTAssertEqual(risk, .intermediate)
    }

    func testUnder2NotNormalIsIntermediate() {
        let risk = PECARNCalculator.evaluate(ageGroup: .underTwo, positiveCriteria: ["not_normal"])
        XCTAssertEqual(risk, .intermediate)
    }

    func testUnder2HighOverridesIntermediate() {
        let risk = PECARNCalculator.evaluate(
            ageGroup: .underTwo, positiveCriteria: ["ams_under2", "loc_under2"]
        )
        XCTAssertEqual(risk, .higher)
    }

    // MARK: - 2 years and over

    func testOver2NoCriteriaIsVeryLow() {
        let risk = PECARNCalculator.evaluate(ageGroup: .twoAndOver, positiveCriteria: [])
        XCTAssertEqual(risk, .veryLow)
    }

    func testOver2AlteredMentalStatusIsHigher() {
        let risk = PECARNCalculator.evaluate(ageGroup: .twoAndOver, positiveCriteria: ["ams_over2"])
        XCTAssertEqual(risk, .higher)
    }

    func testOver2BasilarFractureIsHigher() {
        let risk = PECARNCalculator.evaluate(ageGroup: .twoAndOver, positiveCriteria: ["basilar_fracture"])
        XCTAssertEqual(risk, .higher)
    }

    func testOver2VomitingIsIntermediate() {
        let risk = PECARNCalculator.evaluate(ageGroup: .twoAndOver, positiveCriteria: ["vomiting"])
        XCTAssertEqual(risk, .intermediate)
    }

    func testOver2HeadacheIsIntermediate() {
        let risk = PECARNCalculator.evaluate(ageGroup: .twoAndOver, positiveCriteria: ["headache"])
        XCTAssertEqual(risk, .intermediate)
    }

    func testOver2LOCIsIntermediate() {
        let risk = PECARNCalculator.evaluate(ageGroup: .twoAndOver, positiveCriteria: ["loc_over2"])
        XCTAssertEqual(risk, .intermediate)
    }

    func testOver2MultipleIntermediateStillIntermediate() {
        let risk = PECARNCalculator.evaluate(
            ageGroup: .twoAndOver, positiveCriteria: ["vomiting", "headache", "loc_over2"]
        )
        XCTAssertEqual(risk, .intermediate)
    }

    // MARK: - Criteria count

    func testUnder2CriteriaCount() {
        XCTAssertEqual(PECARNCriteria.criteria(for: .underTwo).count, 6)
    }

    func testOver2CriteriaCount() {
        XCTAssertEqual(PECARNCriteria.criteria(for: .twoAndOver).count, 6)
    }
}
