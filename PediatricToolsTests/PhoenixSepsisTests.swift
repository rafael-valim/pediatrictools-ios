import XCTest
@testable import PediatricTools

final class PhoenixSepsisTests: XCTestCase {

    // MARK: - Respiratory Score

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

    // MARK: - Cardiovascular Score

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

    // MARK: - Coagulation Score

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

    // MARK: - Neurologic Score

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
        XCTAssertEqual(PhoenixSepsis.neurologicScore(gcs: 11), 1)
    }

    // MARK: - Total Score

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
        // Score ≥2 but cardiovascular = 0
        let result = PhoenixSepsis.calculate(respiratoryScore: 1, cardiovascularScore: 0, coagulationScore: 1, neurologicScore: 0)
        XCTAssertTrue(result.isSepsis)
        XCTAssertFalse(result.isSepticShock)
    }

    func testTotalScore() {
        let result = PhoenixSepsis.calculate(respiratoryScore: 3, cardiovascularScore: 6, coagulationScore: 2, neurologicScore: 2)
        XCTAssertEqual(result.totalScore, 13)
    }
}
