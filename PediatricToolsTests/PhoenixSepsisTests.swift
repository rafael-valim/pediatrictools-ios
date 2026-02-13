import XCTest
@testable import PediatricTools

final class PhoenixSepsisTests: XCTestCase {

    // MARK: - Respiratory Score — Basic

    func testRespiratoryNormal() {
        let score = PhoenixSepsis.respiratoryScore(paoFioRatio: 300, spoFioRatio: nil, onInvasiveVent: false)
        XCTAssertEqual(score, 0)
    }

    func testRespiratoryMildPF() {
        let score = PhoenixSepsis.respiratoryScore(paoFioRatio: 150, spoFioRatio: nil, onInvasiveVent: false)
        XCTAssertEqual(score, 1)
    }

    func testRespiratorySeverePF() {
        let score = PhoenixSepsis.respiratoryScore(paoFioRatio: 80, spoFioRatio: nil, onInvasiveVent: false)
        XCTAssertEqual(score, 2)
    }

    func testRespiratoryWithVent() {
        let score = PhoenixSepsis.respiratoryScore(paoFioRatio: 150, spoFioRatio: nil, onInvasiveVent: true)
        XCTAssertEqual(score, 2)
    }

    func testRespiratoryMaxIs3() {
        let score = PhoenixSepsis.respiratoryScore(paoFioRatio: 80, spoFioRatio: nil, onInvasiveVent: true)
        XCTAssertEqual(score, 3)
    }

    func testRespiratorySFRatio() {
        let score = PhoenixSepsis.respiratoryScore(paoFioRatio: nil, spoFioRatio: 200, onInvasiveVent: false)
        XCTAssertEqual(score, 1)
    }

    // MARK: - Respiratory Score — SF ratio boundaries

    func testRespiratorySFRatio147IsScore2() {
        // SF < 148 → oxygenScore = 2
        let score = PhoenixSepsis.respiratoryScore(paoFioRatio: nil, spoFioRatio: 147, onInvasiveVent: false)
        XCTAssertEqual(score, 2)
    }

    func testRespiratorySFRatio148IsScore1() {
        // SF = 148 is NOT < 148, so it falls to < 220 → oxygenScore = 1
        let score = PhoenixSepsis.respiratoryScore(paoFioRatio: nil, spoFioRatio: 148, onInvasiveVent: false)
        XCTAssertEqual(score, 1)
    }

    func testRespiratorySFRatio219IsScore1() {
        // SF = 219 is < 220 → oxygenScore = 1
        let score = PhoenixSepsis.respiratoryScore(paoFioRatio: nil, spoFioRatio: 219, onInvasiveVent: false)
        XCTAssertEqual(score, 1)
    }

    func testRespiratorySFRatio220IsScore0() {
        // SF = 220 is NOT < 220 → oxygenScore = 0
        let score = PhoenixSepsis.respiratoryScore(paoFioRatio: nil, spoFioRatio: 220, onInvasiveVent: false)
        XCTAssertEqual(score, 0)
    }

    // MARK: - Respiratory Score — Nil both ratios

    func testRespiratoryNilBothRatiosNoVentIs0() {
        let score = PhoenixSepsis.respiratoryScore(paoFioRatio: nil, spoFioRatio: nil, onInvasiveVent: false)
        XCTAssertEqual(score, 0, "With no oxygenation data and no vent, respiratory score should be 0")
    }

    func testRespiratoryNilBothRatiosWithVentIs1() {
        let score = PhoenixSepsis.respiratoryScore(paoFioRatio: nil, spoFioRatio: nil, onInvasiveVent: true)
        XCTAssertEqual(score, 1, "With no oxygenation data but on vent, respiratory score should be 1")
    }

    // MARK: - Respiratory Score — PF boundary at 100

    func testRespiratoryPFExactly100IsScore1() {
        // PF = 100 is NOT < 100, so falls into < 200 → oxygenScore = 1
        let score = PhoenixSepsis.respiratoryScore(paoFioRatio: 100, spoFioRatio: nil, onInvasiveVent: false)
        XCTAssertEqual(score, 1)
    }

    func testRespiratoryPF99IsScore2() {
        // PF = 99 < 100 → oxygenScore = 2
        let score = PhoenixSepsis.respiratoryScore(paoFioRatio: 99, spoFioRatio: nil, onInvasiveVent: false)
        XCTAssertEqual(score, 2)
    }

    func testRespiratoryPFExactly200IsScore0() {
        // PF = 200 is NOT < 200 → oxygenScore = 0
        let score = PhoenixSepsis.respiratoryScore(paoFioRatio: 200, spoFioRatio: nil, onInvasiveVent: false)
        XCTAssertEqual(score, 0)
    }

    func testRespiratoryPF199IsScore1() {
        // PF = 199 < 200 → oxygenScore = 1
        let score = PhoenixSepsis.respiratoryScore(paoFioRatio: 199, spoFioRatio: nil, onInvasiveVent: false)
        XCTAssertEqual(score, 1)
    }

    // MARK: - Respiratory Score — PF takes priority over SF

    func testRespiratoryPFTakesPriorityOverSF() {
        // When both are provided, PF should be used (it comes first in the if-else)
        let score = PhoenixSepsis.respiratoryScore(paoFioRatio: 300, spoFioRatio: 100, onInvasiveVent: false)
        XCTAssertEqual(score, 0, "PF ratio should take priority; PF=300 → 0, SF=100 would give 2")
    }

    // MARK: - Cardiovascular Score — Basic

    func testCardioNormal() {
        let score = PhoenixSepsis.cardiovascularScore(vasoactiveCount: 0, lactateMmol: nil, mapForAge: true)
        XCTAssertEqual(score, 0)
    }

    func testCardioOneVasoactive() {
        let score = PhoenixSepsis.cardiovascularScore(vasoactiveCount: 1, lactateMmol: nil, mapForAge: true)
        XCTAssertEqual(score, 1)
    }

    func testCardioTwoVasoactives() {
        let score = PhoenixSepsis.cardiovascularScore(vasoactiveCount: 2, lactateMmol: nil, mapForAge: true)
        XCTAssertEqual(score, 2)
    }

    func testCardioHighLactate() {
        let score = PhoenixSepsis.cardiovascularScore(vasoactiveCount: 0, lactateMmol: 12.0, mapForAge: true)
        XCTAssertEqual(score, 2)
    }

    func testCardioModerateLactate() {
        let score = PhoenixSepsis.cardiovascularScore(vasoactiveCount: 0, lactateMmol: 6.0, mapForAge: true)
        XCTAssertEqual(score, 1)
    }

    func testCardioLowMAP() {
        let score = PhoenixSepsis.cardiovascularScore(vasoactiveCount: 0, lactateMmol: nil, mapForAge: false)
        XCTAssertEqual(score, 2)
    }

    func testCardioMaxIs6() {
        let score = PhoenixSepsis.cardiovascularScore(vasoactiveCount: 2, lactateMmol: 15.0, mapForAge: false)
        XCTAssertEqual(score, 6)
    }

    // MARK: - Cardiovascular Score — Lactate boundaries

    func testCardioLactate4_99IsScore0() {
        // 4.99 < 5.0 → no lactate points
        let score = PhoenixSepsis.cardiovascularScore(vasoactiveCount: 0, lactateMmol: 4.99, mapForAge: true)
        XCTAssertEqual(score, 0)
    }

    func testCardioLactate5_0IsScore1() {
        // 5.0 >= 5.0 → +1
        let score = PhoenixSepsis.cardiovascularScore(vasoactiveCount: 0, lactateMmol: 5.0, mapForAge: true)
        XCTAssertEqual(score, 1)
    }

    func testCardioLactate10_99IsScore1() {
        // 10.99 >= 5.0 but < 11.0 → +1
        let score = PhoenixSepsis.cardiovascularScore(vasoactiveCount: 0, lactateMmol: 10.99, mapForAge: true)
        XCTAssertEqual(score, 1)
    }

    func testCardioLactate11_0IsScore2() {
        // 11.0 >= 11.0 → +2
        let score = PhoenixSepsis.cardiovascularScore(vasoactiveCount: 0, lactateMmol: 11.0, mapForAge: true)
        XCTAssertEqual(score, 2)
    }

    // MARK: - Cardiovascular Score — Vasoactive count 3+

    func testCardioThreeVasoactivesIsScore2() {
        // vasoactiveCount >= 2 → +2 (same as 2)
        let score = PhoenixSepsis.cardiovascularScore(vasoactiveCount: 3, lactateMmol: nil, mapForAge: true)
        XCTAssertEqual(score, 2)
    }

    func testCardioFiveVasoactivesIsScore2() {
        let score = PhoenixSepsis.cardiovascularScore(vasoactiveCount: 5, lactateMmol: nil, mapForAge: true)
        XCTAssertEqual(score, 2)
    }

    // MARK: - Cardiovascular Score — Capping at 6

    func testCardioCapsAt6WithAllMaxComponents() {
        // 2 (vaso>=2) + 2 (lactate>=11) + 2 (low MAP) = 6, which is exactly max
        let score = PhoenixSepsis.cardiovascularScore(vasoactiveCount: 3, lactateMmol: 20.0, mapForAge: false)
        XCTAssertEqual(score, 6)
    }

    func testCardioNilLactateDoesNotContribute() {
        let score = PhoenixSepsis.cardiovascularScore(vasoactiveCount: 0, lactateMmol: nil, mapForAge: true)
        XCTAssertEqual(score, 0)
    }

    // MARK: - Coagulation Score — Basic

    func testCoagNormal() {
        let score = PhoenixSepsis.coagulationScore(platelets: 200, inr: 1.0, dDimer: 0.5, fibrinogen: 300)
        XCTAssertEqual(score, 0)
    }

    func testCoagLowPlatelets() {
        let score = PhoenixSepsis.coagulationScore(platelets: 80, inr: nil, dDimer: nil, fibrinogen: nil)
        XCTAssertEqual(score, 1)
    }

    func testCoagHighINR() {
        let score = PhoenixSepsis.coagulationScore(platelets: nil, inr: 1.5, dDimer: nil, fibrinogen: nil)
        XCTAssertEqual(score, 1)
    }

    func testCoagMaxIs2() {
        let score = PhoenixSepsis.coagulationScore(platelets: 50, inr: 2.0, dDimer: 5.0, fibrinogen: 50)
        XCTAssertEqual(score, 2)
    }

    // MARK: - Coagulation Score — Boundary tests

    func testCoagPlateletsExactly100IsScore0() {
        // platelets < 100 triggers; 100 is NOT < 100 → 0
        let score = PhoenixSepsis.coagulationScore(platelets: 100, inr: nil, dDimer: nil, fibrinogen: nil)
        XCTAssertEqual(score, 0)
    }

    func testCoagPlatelets99IsScore1() {
        let score = PhoenixSepsis.coagulationScore(platelets: 99, inr: nil, dDimer: nil, fibrinogen: nil)
        XCTAssertEqual(score, 1)
    }

    func testCoagINRExactly1_3IsScore0() {
        // INR > 1.3 triggers; 1.3 is NOT > 1.3 → 0
        let score = PhoenixSepsis.coagulationScore(platelets: nil, inr: 1.3, dDimer: nil, fibrinogen: nil)
        XCTAssertEqual(score, 0)
    }

    func testCoagINR1_31IsScore1() {
        let score = PhoenixSepsis.coagulationScore(platelets: nil, inr: 1.31, dDimer: nil, fibrinogen: nil)
        XCTAssertEqual(score, 1)
    }

    func testCoagDDimerExactly2_0IsScore0() {
        // D-dimer > 2.0 triggers; 2.0 is NOT > 2.0 → 0
        let score = PhoenixSepsis.coagulationScore(platelets: nil, inr: nil, dDimer: 2.0, fibrinogen: nil)
        XCTAssertEqual(score, 0)
    }

    func testCoagDDimer2_01IsScore1() {
        let score = PhoenixSepsis.coagulationScore(platelets: nil, inr: nil, dDimer: 2.01, fibrinogen: nil)
        XCTAssertEqual(score, 1)
    }

    func testCoagFibrinogenExactly100IsScore0() {
        // fibrinogen < 100 triggers; 100 is NOT < 100 → 0
        let score = PhoenixSepsis.coagulationScore(platelets: nil, inr: nil, dDimer: nil, fibrinogen: 100)
        XCTAssertEqual(score, 0)
    }

    func testCoagFibrinogen99IsScore1() {
        let score = PhoenixSepsis.coagulationScore(platelets: nil, inr: nil, dDimer: nil, fibrinogen: 99)
        XCTAssertEqual(score, 1)
    }

    // MARK: - Coagulation Score — All nil

    func testCoagAllNilIsScore0() {
        let score = PhoenixSepsis.coagulationScore(platelets: nil, inr: nil, dDimer: nil, fibrinogen: nil)
        XCTAssertEqual(score, 0, "All nil coagulation values should yield score 0")
    }

    // MARK: - Coagulation Score — Multiple abnormal capped at 2

    func testCoagThreeAbnormalCappedAt2() {
        // Low plt + high INR + high D-dimer = 3 raw, capped at 2
        let score = PhoenixSepsis.coagulationScore(platelets: 50, inr: 2.0, dDimer: 5.0, fibrinogen: 200)
        XCTAssertEqual(score, 2)
    }

    func testCoagFourAbnormalCappedAt2() {
        // All 4 abnormal = 4 raw, capped at 2
        let score = PhoenixSepsis.coagulationScore(platelets: 10, inr: 5.0, dDimer: 10.0, fibrinogen: 20)
        XCTAssertEqual(score, 2)
    }

    // MARK: - Neurologic Score — Basic

    func testNeuroNormal() {
        XCTAssertEqual(PhoenixSepsis.neurologicScore(gcs: 15), 0)
    }

    func testNeuroMild() {
        XCTAssertEqual(PhoenixSepsis.neurologicScore(gcs: 12), 1)
    }

    func testNeuroSevere() {
        XCTAssertEqual(PhoenixSepsis.neurologicScore(gcs: 8), 2)
    }

    func testNeuroBoundary10() {
        XCTAssertEqual(PhoenixSepsis.neurologicScore(gcs: 10), 2)
    }

    func testNeuroBoundary11() {
        // GCS 11: > 10, < 15 → score 1
        XCTAssertEqual(PhoenixSepsis.neurologicScore(gcs: 11), 1)
    }

    // MARK: - Neurologic Score — Additional boundaries

    func testNeuroGCS14IsScore1() {
        // GCS 14: > 10, < 15 → score 1
        XCTAssertEqual(PhoenixSepsis.neurologicScore(gcs: 14), 1)
    }

    func testNeuroGCS3IsScore2() {
        // GCS 3 (minimum possible) → score 2
        XCTAssertEqual(PhoenixSepsis.neurologicScore(gcs: 3), 2)
    }

    func testNeuroGCS10IsScore2() {
        // GCS 10 <= 10 → score 2
        XCTAssertEqual(PhoenixSepsis.neurologicScore(gcs: 10), 2)
    }

    func testNeuroGCS13IsScore1() {
        XCTAssertEqual(PhoenixSepsis.neurologicScore(gcs: 13), 1)
    }

    // MARK: - Total Score — Basic

    func testNoSepsis() {
        let result = PhoenixSepsis.calculate(respiratoryScore: 0, cardiovascularScore: 0, coagulationScore: 0, neurologicScore: 1)
        XCTAssertFalse(result.isSepsis)
        XCTAssertFalse(result.isSepticShock)
        XCTAssertEqual(result.interpretationKey, "phoenix_no_sepsis")
    }

    func testSepsisThreshold() {
        let result = PhoenixSepsis.calculate(respiratoryScore: 2, cardiovascularScore: 0, coagulationScore: 0, neurologicScore: 0)
        XCTAssertTrue(result.isSepsis)
        XCTAssertFalse(result.isSepticShock)
        XCTAssertEqual(result.interpretationKey, "phoenix_sepsis")
    }

    func testSepticShock() {
        let result = PhoenixSepsis.calculate(respiratoryScore: 1, cardiovascularScore: 1, coagulationScore: 0, neurologicScore: 0)
        XCTAssertTrue(result.isSepsis)
        XCTAssertTrue(result.isSepticShock)
        XCTAssertEqual(result.interpretationKey, "phoenix_septic_shock")
    }

    func testSepsisWithoutShock() {
        // Score >= 2 but cardiovascular = 0
        let result = PhoenixSepsis.calculate(respiratoryScore: 1, cardiovascularScore: 0, coagulationScore: 1, neurologicScore: 0)
        XCTAssertTrue(result.isSepsis)
        XCTAssertFalse(result.isSepticShock)
    }

    func testTotalScore() {
        let result = PhoenixSepsis.calculate(respiratoryScore: 3, cardiovascularScore: 6, coagulationScore: 2, neurologicScore: 2)
        XCTAssertEqual(result.totalScore, 13)
    }

    // MARK: - Total Score — Max possible score

    func testMaxPossibleScore() {
        // resp=3, cardio=6, coag=2, neuro=2 → total=13
        let result = PhoenixSepsis.calculate(respiratoryScore: 3, cardiovascularScore: 6, coagulationScore: 2, neurologicScore: 2)
        XCTAssertEqual(result.totalScore, 13)
        XCTAssertTrue(result.isSepsis)
        XCTAssertTrue(result.isSepticShock)
        XCTAssertEqual(result.interpretationKey, "phoenix_septic_shock")
    }

    // MARK: - Total Score — Score 1 is no sepsis

    func testScore1IsNotSepsis() {
        let result = PhoenixSepsis.calculate(respiratoryScore: 1, cardiovascularScore: 0, coagulationScore: 0, neurologicScore: 0)
        XCTAssertEqual(result.totalScore, 1)
        XCTAssertFalse(result.isSepsis, "Total score of 1 should not meet sepsis threshold of 2")
        XCTAssertFalse(result.isSepticShock)
        XCTAssertEqual(result.interpretationKey, "phoenix_no_sepsis")
    }

    // MARK: - Total Score — Cardiovascular 0 with resp+coag >= 2 is sepsis not shock

    func testCardio0WithRespPlusCoagIsSepsisNotShock() {
        // resp=1, coag=1, total=2 → sepsis, but cardio=0 → not shock
        let result = PhoenixSepsis.calculate(respiratoryScore: 1, cardiovascularScore: 0, coagulationScore: 1, neurologicScore: 0)
        XCTAssertEqual(result.totalScore, 2)
        XCTAssertTrue(result.isSepsis)
        XCTAssertFalse(result.isSepticShock, "Cardiovascular = 0 should prevent septic shock classification")
        XCTAssertEqual(result.interpretationKey, "phoenix_sepsis")
    }

    func testCardio0WithRespPlusNeuroIsSepsisNotShock() {
        // resp=1, neuro=1, total=2 → sepsis, but cardio=0 → not shock
        let result = PhoenixSepsis.calculate(respiratoryScore: 1, cardiovascularScore: 0, coagulationScore: 0, neurologicScore: 1)
        XCTAssertEqual(result.totalScore, 2)
        XCTAssertTrue(result.isSepsis)
        XCTAssertFalse(result.isSepticShock)
    }

    // MARK: - Total Score — Septic shock requires cardio >= 1 AND total >= 2

    func testSepticShockRequiresCardioAndTotal() {
        // cardio=1 alone → total=1 → not sepsis → not shock
        let result = PhoenixSepsis.calculate(respiratoryScore: 0, cardiovascularScore: 1, coagulationScore: 0, neurologicScore: 0)
        XCTAssertEqual(result.totalScore, 1)
        XCTAssertFalse(result.isSepsis)
        XCTAssertFalse(result.isSepticShock, "Total < 2 should prevent septic shock even with cardio >= 1")
    }

    func testSepticShockWithCardio1AndResp1() {
        // cardio=1, resp=1 → total=2 → sepsis AND cardio>=1 → shock
        let result = PhoenixSepsis.calculate(respiratoryScore: 1, cardiovascularScore: 1, coagulationScore: 0, neurologicScore: 0)
        XCTAssertTrue(result.isSepsis)
        XCTAssertTrue(result.isSepticShock)
        XCTAssertEqual(result.interpretationKey, "phoenix_septic_shock")
    }

    func testSepticShockWithCardio6AndResp0CoagNeuro() {
        // cardio=6, coag=0, neuro=0, resp=0 → total=6 → sepsis AND cardio>=1 → shock
        let result = PhoenixSepsis.calculate(respiratoryScore: 0, cardiovascularScore: 6, coagulationScore: 0, neurologicScore: 0)
        XCTAssertTrue(result.isSepsis)
        XCTAssertTrue(result.isSepticShock)
    }

    // MARK: - Total Score — All zeros

    func testAllZerosIsNoSepsis() {
        let result = PhoenixSepsis.calculate(respiratoryScore: 0, cardiovascularScore: 0, coagulationScore: 0, neurologicScore: 0)
        XCTAssertEqual(result.totalScore, 0)
        XCTAssertFalse(result.isSepsis)
        XCTAssertFalse(result.isSepticShock)
        XCTAssertEqual(result.interpretationKey, "phoenix_no_sepsis")
    }

    // MARK: - Total Score — Exact threshold at 2

    func testExactThreshold2IsSepsis() {
        let result = PhoenixSepsis.calculate(respiratoryScore: 0, cardiovascularScore: 0, coagulationScore: 2, neurologicScore: 0)
        XCTAssertEqual(result.totalScore, 2)
        XCTAssertTrue(result.isSepsis, "Total score exactly 2 should meet sepsis threshold")
        XCTAssertFalse(result.isSepticShock, "No cardiovascular involvement → no shock")
    }

    // MARK: - Result property verification

    func testResultStoresIndividualScores() {
        let result = PhoenixSepsis.calculate(respiratoryScore: 2, cardiovascularScore: 3, coagulationScore: 1, neurologicScore: 2)
        XCTAssertEqual(result.respiratoryScore, 2)
        XCTAssertEqual(result.cardiovascularScore, 3)
        XCTAssertEqual(result.coagulationScore, 1)
        XCTAssertEqual(result.neurologicScore, 2)
        XCTAssertEqual(result.totalScore, 8)
    }
}
