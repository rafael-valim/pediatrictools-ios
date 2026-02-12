import XCTest
@testable import PediatricTools

final class PediatricDosageTests: XCTestCase {

    // MARK: - Acetaminophen (dosePerKg=10, maxDosePerKg=15, maxSingleDose=1000)

    func testAcetaminophen10KgNoCapping() {
        // 10kg: low=10*10=100, high=10*15=150, neither capped
        let result = PediatricDosageCalculator.calculate(
            medication: Medications.acetaminophen,
            weightKg: 10.0
        )
        XCTAssertEqual(result.lowDoseMg, 100.0, accuracy: 0.01)
        XCTAssertEqual(result.highDoseMg, 150.0, accuracy: 0.01)
        XCTAssertFalse(result.cappedLow)
        XCTAssertFalse(result.cappedHigh)
    }

    func testAcetaminophen200KgBothCapped() {
        // 200kg: low=200*10=2000, high=200*15=3000 → both capped to 1000
        let result = PediatricDosageCalculator.calculate(
            medication: Medications.acetaminophen,
            weightKg: 200.0
        )
        XCTAssertEqual(result.lowDoseMg, 1000.0, accuracy: 0.01)
        XCTAssertEqual(result.highDoseMg, 1000.0, accuracy: 0.01)
        XCTAssertTrue(result.cappedLow)
        XCTAssertTrue(result.cappedHigh)
    }

    // MARK: - With concentration

    func testAcetaminophenWithConcentration() {
        // acet_160_5 has mgPerMl = 32
        // 10kg: lowDose=100 → volumeMl = 100/32 = 3.125
        //       highDose=150 → volumeHighMl = 150/32 = 4.6875
        let conc = Medications.acetaminophen.concentrations.first { $0.id == "acet_160_5" }!
        let result = PediatricDosageCalculator.calculate(
            medication: Medications.acetaminophen,
            weightKg: 10.0,
            concentration: conc
        )
        XCTAssertNotNil(result.volumeMl)
        XCTAssertNotNil(result.volumeHighMl)
        XCTAssertEqual(result.volumeMl!, 3.125, accuracy: 0.01)
        XCTAssertEqual(result.volumeHighMl!, 4.6875, accuracy: 0.01)
    }

    // MARK: - Without concentration

    func testNilConcentrationReturnsNilVolumes() {
        let result = PediatricDosageCalculator.calculate(
            medication: Medications.acetaminophen,
            weightKg: 10.0,
            concentration: nil
        )
        XCTAssertNil(result.volumeMl)
        XCTAssertNil(result.volumeHighMl)
    }
}
