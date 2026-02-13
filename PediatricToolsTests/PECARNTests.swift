import XCTest
@testable import PediatricTools

final class PECARNTests: XCTestCase {

    // MARK: - Under 2 years — Basic

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

    // MARK: - Under 2 years — All criteria present (AMS overrides)

    func testUnder2AllCriteriaPresentIsHigher() {
        let allUnder2: Set<String> = [
            "ams_under2", "skull_fracture", "loc_under2",
            "mechanism_under2", "hematoma", "not_normal"
        ]
        let risk = PECARNCalculator.evaluate(ageGroup: .underTwo, positiveCriteria: allUnder2)
        XCTAssertEqual(risk, .higher, "AMS high-risk criterion should override all intermediate criteria")
    }

    // MARK: - Under 2 years — Single high-risk criterion tests

    func testUnder2AMSAloneIsHigher() {
        let risk = PECARNCalculator.evaluate(ageGroup: .underTwo, positiveCriteria: ["ams_under2"])
        XCTAssertEqual(risk, .higher)
    }

    func testUnder2SkullFractureAloneIsHigher() {
        let risk = PECARNCalculator.evaluate(ageGroup: .underTwo, positiveCriteria: ["skull_fracture"])
        XCTAssertEqual(risk, .higher)
    }

    // MARK: - Under 2 years — Mixed high + intermediate

    func testUnder2AMSPlusAllIntermediateIsHigher() {
        let risk = PECARNCalculator.evaluate(
            ageGroup: .underTwo,
            positiveCriteria: ["ams_under2", "loc_under2", "mechanism_under2", "hematoma", "not_normal"]
        )
        XCTAssertEqual(risk, .higher, "High-risk always wins regardless of intermediate criteria count")
    }

    func testUnder2SkullFracturePlusHematomaIsHigher() {
        let risk = PECARNCalculator.evaluate(
            ageGroup: .underTwo,
            positiveCriteria: ["skull_fracture", "hematoma"]
        )
        XCTAssertEqual(risk, .higher, "High-risk criterion should override intermediate hematoma")
    }

    func testUnder2BothHighRiskCriteriaIsHigher() {
        let risk = PECARNCalculator.evaluate(
            ageGroup: .underTwo,
            positiveCriteria: ["ams_under2", "skull_fracture"]
        )
        XCTAssertEqual(risk, .higher)
    }

    func testUnder2MultipleIntermediateStillIntermediate() {
        let risk = PECARNCalculator.evaluate(
            ageGroup: .underTwo,
            positiveCriteria: ["loc_under2", "mechanism_under2", "hematoma", "not_normal"]
        )
        XCTAssertEqual(risk, .intermediate, "Multiple intermediate criteria without high-risk stays intermediate")
    }

    // MARK: - 2 years and over — Basic

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

    // MARK: - 2 years and over — All criteria present (AMS overrides)

    func testOver2AllCriteriaPresentIsHigher() {
        let allOver2: Set<String> = [
            "ams_over2", "basilar_fracture", "loc_over2",
            "mechanism_over2", "vomiting", "headache"
        ]
        let risk = PECARNCalculator.evaluate(ageGroup: .twoAndOver, positiveCriteria: allOver2)
        XCTAssertEqual(risk, .higher, "AMS high-risk criterion should override all intermediate criteria")
    }

    // MARK: - 2 years and over — Mechanism alone is intermediate

    func testOver2MechanismAloneIsIntermediate() {
        let risk = PECARNCalculator.evaluate(ageGroup: .twoAndOver, positiveCriteria: ["mechanism_over2"])
        XCTAssertEqual(risk, .intermediate)
    }

    // MARK: - 2 years and over — Single high-risk criterion tests

    func testOver2AMSAloneIsHigher() {
        let risk = PECARNCalculator.evaluate(ageGroup: .twoAndOver, positiveCriteria: ["ams_over2"])
        XCTAssertEqual(risk, .higher)
    }

    func testOver2BasilarFractureAloneIsHigher() {
        let risk = PECARNCalculator.evaluate(ageGroup: .twoAndOver, positiveCriteria: ["basilar_fracture"])
        XCTAssertEqual(risk, .higher)
    }

    func testOver2BothHighRiskCriteriaIsHigher() {
        let risk = PECARNCalculator.evaluate(
            ageGroup: .twoAndOver,
            positiveCriteria: ["ams_over2", "basilar_fracture"]
        )
        XCTAssertEqual(risk, .higher)
    }

    func testOver2HighRiskPlusAllIntermediateIsHigher() {
        let risk = PECARNCalculator.evaluate(
            ageGroup: .twoAndOver,
            positiveCriteria: ["basilar_fracture", "loc_over2", "mechanism_over2", "vomiting", "headache"]
        )
        XCTAssertEqual(risk, .higher, "High-risk always wins regardless of intermediate criteria count")
    }

    func testOver2AllIntermediateNoneHighStillIntermediate() {
        let risk = PECARNCalculator.evaluate(
            ageGroup: .twoAndOver,
            positiveCriteria: ["loc_over2", "mechanism_over2", "vomiting", "headache"]
        )
        XCTAssertEqual(risk, .intermediate, "All 4 intermediate criteria without high-risk stays intermediate")
    }

    // MARK: - Both age groups — Empty set and irrelevant criteria

    func testEmptySetUnder2IsVeryLow() {
        let risk = PECARNCalculator.evaluate(ageGroup: .underTwo, positiveCriteria: Set<String>())
        XCTAssertEqual(risk, .veryLow)
    }

    func testEmptySetOver2IsVeryLow() {
        let risk = PECARNCalculator.evaluate(ageGroup: .twoAndOver, positiveCriteria: Set<String>())
        XCTAssertEqual(risk, .veryLow)
    }

    func testIrrelevantCriteriaIDUnder2IsVeryLow() {
        let risk = PECARNCalculator.evaluate(ageGroup: .underTwo, positiveCriteria: ["bogus_criterion"])
        XCTAssertEqual(risk, .veryLow, "Unrecognized criteria IDs should not affect the risk level")
    }

    func testIrrelevantCriteriaIDOver2IsVeryLow() {
        let risk = PECARNCalculator.evaluate(ageGroup: .twoAndOver, positiveCriteria: ["nonexistent_id"])
        XCTAssertEqual(risk, .veryLow, "Unrecognized criteria IDs should not affect the risk level")
    }

    func testOver2CriteriaUsedForUnder2IsVeryLow() {
        // Using over2-specific IDs in the underTwo age group should not trigger any match
        let risk = PECARNCalculator.evaluate(
            ageGroup: .underTwo,
            positiveCriteria: ["ams_over2", "basilar_fracture", "loc_over2", "mechanism_over2", "vomiting", "headache"]
        )
        XCTAssertEqual(risk, .veryLow, "Over-2 criteria IDs should not match under-2 age group")
    }

    func testUnder2CriteriaUsedForOver2IsVeryLow() {
        // Using under2-specific IDs in the twoAndOver age group should not trigger any match
        let risk = PECARNCalculator.evaluate(
            ageGroup: .twoAndOver,
            positiveCriteria: ["ams_under2", "skull_fracture", "loc_under2", "mechanism_under2", "hematoma", "not_normal"]
        )
        XCTAssertEqual(risk, .veryLow, "Under-2 criteria IDs should not match over-2 age group")
    }

    // MARK: - Criteria count

    func testUnder2CriteriaCount() {
        XCTAssertEqual(PECARNCriteria.criteria(for: .underTwo).count, 6)
    }

    func testOver2CriteriaCount() {
        XCTAssertEqual(PECARNCriteria.criteria(for: .twoAndOver).count, 6)
    }

    // MARK: - PECARNRisk localizedKey verification

    func testVeryLowLocalizedKey() {
        XCTAssertEqual(PECARNRisk.veryLow.localizedKey, "pecarn_very_low")
    }

    func testIntermediateLocalizedKey() {
        XCTAssertEqual(PECARNRisk.intermediate.localizedKey, "pecarn_intermediate")
    }

    func testHigherLocalizedKey() {
        XCTAssertEqual(PECARNRisk.higher.localizedKey, "pecarn_higher")
    }

    // MARK: - PECARNRisk recommendationKey verification

    func testVeryLowRecommendationKey() {
        XCTAssertEqual(PECARNRisk.veryLow.recommendationKey, "pecarn_rec_very_low")
    }

    func testIntermediateRecommendationKey() {
        XCTAssertEqual(PECARNRisk.intermediate.recommendationKey, "pecarn_rec_intermediate")
    }

    func testHigherRecommendationKey() {
        XCTAssertEqual(PECARNRisk.higher.recommendationKey, "pecarn_rec_higher")
    }
}
