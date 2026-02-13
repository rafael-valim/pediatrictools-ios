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

    // MARK: - Acetaminophen with concentration

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

    // MARK: - Ibuprofen (dosePerKg=5, maxDosePerKg=10, maxSingleDose=400)

    func testIbuprofen10Kg() {
        // 10kg: low=10*5=50, high=10*10=100
        let result = PediatricDosageCalculator.calculate(
            medication: Medications.ibuprofen,
            weightKg: 10.0
        )
        XCTAssertEqual(result.lowDoseMg, 50.0, accuracy: 0.01)
        XCTAssertEqual(result.highDoseMg, 100.0, accuracy: 0.01)
        XCTAssertFalse(result.cappedLow)
        XCTAssertFalse(result.cappedHigh)
    }

    func testIbuprofenHeavyWeightCapped() {
        // 100kg: low=100*5=500 → capped to 400, high=100*10=1000 → capped to 400
        let result = PediatricDosageCalculator.calculate(
            medication: Medications.ibuprofen,
            weightKg: 100.0
        )
        XCTAssertEqual(result.lowDoseMg, 400.0, accuracy: 0.01)
        XCTAssertEqual(result.highDoseMg, 400.0, accuracy: 0.01)
        XCTAssertTrue(result.cappedLow)
        XCTAssertTrue(result.cappedHigh)
    }

    // MARK: - Amoxicillin (dosePerKg=12.5, maxDosePerKg=25, maxSingleDose=500)

    func testAmoxicillin10Kg() {
        // 10kg: low=10*12.5=125, high=10*25=250
        let result = PediatricDosageCalculator.calculate(
            medication: Medications.amoxicillin,
            weightKg: 10.0
        )
        XCTAssertEqual(result.lowDoseMg, 125.0, accuracy: 0.01)
        XCTAssertEqual(result.highDoseMg, 250.0, accuracy: 0.01)
        XCTAssertFalse(result.cappedLow)
        XCTAssertFalse(result.cappedHigh)
    }

    func testAmoxicillinHeavyWeightCapped() {
        // 50kg: low=50*12.5=625 → capped to 500, high=50*25=1250 → capped to 500
        let result = PediatricDosageCalculator.calculate(
            medication: Medications.amoxicillin,
            weightKg: 50.0
        )
        XCTAssertEqual(result.lowDoseMg, 500.0, accuracy: 0.01)
        XCTAssertEqual(result.highDoseMg, 500.0, accuracy: 0.01)
        XCTAssertTrue(result.cappedLow)
        XCTAssertTrue(result.cappedHigh)
    }

    // MARK: - Amoxicillin High Dose (dosePerKg=40, maxDosePerKg=45, maxSingleDose=2000)

    func testAmoxicillinHD10Kg() {
        // 10kg: low=10*40=400, high=10*45=450
        let result = PediatricDosageCalculator.calculate(
            medication: Medications.amoxicillinHighDose,
            weightKg: 10.0
        )
        XCTAssertEqual(result.lowDoseMg, 400.0, accuracy: 0.01)
        XCTAssertEqual(result.highDoseMg, 450.0, accuracy: 0.01)
        XCTAssertFalse(result.cappedLow)
        XCTAssertFalse(result.cappedHigh)
    }

    func testAmoxicillinHDHeavyWeightCapped() {
        // 60kg: low=60*40=2400 → capped to 2000, high=60*45=2700 → capped to 2000
        let result = PediatricDosageCalculator.calculate(
            medication: Medications.amoxicillinHighDose,
            weightKg: 60.0
        )
        XCTAssertEqual(result.lowDoseMg, 2000.0, accuracy: 0.01)
        XCTAssertEqual(result.highDoseMg, 2000.0, accuracy: 0.01)
        XCTAssertTrue(result.cappedLow)
        XCTAssertTrue(result.cappedHigh)
    }

    // MARK: - Azithromycin (dosePerKg=10, maxDosePerKg=10, maxSingleDose=500)

    func testAzithromycin10Kg() {
        // 10kg: low=10*10=100, high=10*10=100 (same dose range)
        let result = PediatricDosageCalculator.calculate(
            medication: Medications.azithromycin,
            weightKg: 10.0
        )
        XCTAssertEqual(result.lowDoseMg, 100.0, accuracy: 0.01)
        XCTAssertEqual(result.highDoseMg, 100.0, accuracy: 0.01)
        XCTAssertFalse(result.cappedLow)
        XCTAssertFalse(result.cappedHigh)
    }

    func testAzithromycinHeavyWeightCapped() {
        // 60kg: low=60*10=600 → capped to 500, high=60*10=600 → capped to 500
        let result = PediatricDosageCalculator.calculate(
            medication: Medications.azithromycin,
            weightKg: 60.0
        )
        XCTAssertEqual(result.lowDoseMg, 500.0, accuracy: 0.01)
        XCTAssertEqual(result.highDoseMg, 500.0, accuracy: 0.01)
        XCTAssertTrue(result.cappedLow)
        XCTAssertTrue(result.cappedHigh)
    }

    // MARK: - Cephalexin (dosePerKg=6.25, maxDosePerKg=12.5, maxSingleDose=500)

    func testCephalexin10Kg() {
        // 10kg: low=10*6.25=62.5, high=10*12.5=125
        let result = PediatricDosageCalculator.calculate(
            medication: Medications.cephalexin,
            weightKg: 10.0
        )
        XCTAssertEqual(result.lowDoseMg, 62.5, accuracy: 0.01)
        XCTAssertEqual(result.highDoseMg, 125.0, accuracy: 0.01)
        XCTAssertFalse(result.cappedLow)
        XCTAssertFalse(result.cappedHigh)
    }

    func testCephalexinHeavyWeightCapped() {
        // 100kg: low=100*6.25=625 → capped to 500, high=100*12.5=1250 → capped to 500
        let result = PediatricDosageCalculator.calculate(
            medication: Medications.cephalexin,
            weightKg: 100.0
        )
        XCTAssertEqual(result.lowDoseMg, 500.0, accuracy: 0.01)
        XCTAssertEqual(result.highDoseMg, 500.0, accuracy: 0.01)
        XCTAssertTrue(result.cappedLow)
        XCTAssertTrue(result.cappedHigh)
    }

    // MARK: - Prednisolone (dosePerKg=1, maxDosePerKg=2, maxSingleDose=60)

    func testPrednisolone10Kg() {
        // 10kg: low=10*1=10, high=10*2=20
        let result = PediatricDosageCalculator.calculate(
            medication: Medications.prednisolone,
            weightKg: 10.0
        )
        XCTAssertEqual(result.lowDoseMg, 10.0, accuracy: 0.01)
        XCTAssertEqual(result.highDoseMg, 20.0, accuracy: 0.01)
        XCTAssertFalse(result.cappedLow)
        XCTAssertFalse(result.cappedHigh)
    }

    func testPrednisoloneHeavyWeightCapped() {
        // 80kg: low=80*1=80 → capped to 60, high=80*2=160 → capped to 60
        let result = PediatricDosageCalculator.calculate(
            medication: Medications.prednisolone,
            weightKg: 80.0
        )
        XCTAssertEqual(result.lowDoseMg, 60.0, accuracy: 0.01)
        XCTAssertEqual(result.highDoseMg, 60.0, accuracy: 0.01)
        XCTAssertTrue(result.cappedLow)
        XCTAssertTrue(result.cappedHigh)
    }

    // MARK: - Ondansetron (dosePerKg=0.15, maxDosePerKg=0.15, maxSingleDose=4)

    func testOndansetron10Kg() {
        // 10kg: low=10*0.15=1.5, high=10*0.15=1.5
        let result = PediatricDosageCalculator.calculate(
            medication: Medications.ondansetron,
            weightKg: 10.0
        )
        XCTAssertEqual(result.lowDoseMg, 1.5, accuracy: 0.01)
        XCTAssertEqual(result.highDoseMg, 1.5, accuracy: 0.01)
        XCTAssertFalse(result.cappedLow)
        XCTAssertFalse(result.cappedHigh)
    }

    func testOndansetronHeavyWeightCapped() {
        // 30kg: low=30*0.15=4.5 → capped to 4, high=30*0.15=4.5 → capped to 4
        let result = PediatricDosageCalculator.calculate(
            medication: Medications.ondansetron,
            weightKg: 30.0
        )
        XCTAssertEqual(result.lowDoseMg, 4.0, accuracy: 0.01)
        XCTAssertEqual(result.highDoseMg, 4.0, accuracy: 0.01)
        XCTAssertTrue(result.cappedLow)
        XCTAssertTrue(result.cappedHigh)
    }

    // MARK: - Diphenhydramine (dosePerKg=1, maxDosePerKg=1.25, maxSingleDose=50)

    func testDiphenhydramine10Kg() {
        // 10kg: low=10*1=10, high=10*1.25=12.5
        let result = PediatricDosageCalculator.calculate(
            medication: Medications.diphenhydramine,
            weightKg: 10.0
        )
        XCTAssertEqual(result.lowDoseMg, 10.0, accuracy: 0.01)
        XCTAssertEqual(result.highDoseMg, 12.5, accuracy: 0.01)
        XCTAssertFalse(result.cappedLow)
        XCTAssertFalse(result.cappedHigh)
    }

    func testDiphenhydramineHeavyWeightCapped() {
        // 60kg: low=60*1=60 → capped to 50, high=60*1.25=75 → capped to 50
        let result = PediatricDosageCalculator.calculate(
            medication: Medications.diphenhydramine,
            weightKg: 60.0
        )
        XCTAssertEqual(result.lowDoseMg, 50.0, accuracy: 0.01)
        XCTAssertEqual(result.highDoseMg, 50.0, accuracy: 0.01)
        XCTAssertTrue(result.cappedLow)
        XCTAssertTrue(result.cappedHigh)
    }

    // MARK: - Zero weight

    func testZeroWeightReturnsZeroDose() {
        let result = PediatricDosageCalculator.calculate(
            medication: Medications.acetaminophen,
            weightKg: 0.0
        )
        XCTAssertEqual(result.lowDoseMg, 0.0, accuracy: 0.01)
        XCTAssertEqual(result.highDoseMg, 0.0, accuracy: 0.01)
        XCTAssertFalse(result.cappedLow)
        XCTAssertFalse(result.cappedHigh)
    }

    // MARK: - Very small weight (0.5kg)

    func testVerySmallWeightIbuprofen() {
        // 0.5kg: low=0.5*5=2.5, high=0.5*10=5
        let result = PediatricDosageCalculator.calculate(
            medication: Medications.ibuprofen,
            weightKg: 0.5
        )
        XCTAssertEqual(result.lowDoseMg, 2.5, accuracy: 0.01)
        XCTAssertEqual(result.highDoseMg, 5.0, accuracy: 0.01)
        XCTAssertFalse(result.cappedLow)
        XCTAssertFalse(result.cappedHigh)
    }

    func testVerySmallWeightOndansetron() {
        // 0.5kg: low=0.5*0.15=0.075, high=0.5*0.15=0.075
        let result = PediatricDosageCalculator.calculate(
            medication: Medications.ondansetron,
            weightKg: 0.5
        )
        XCTAssertEqual(result.lowDoseMg, 0.075, accuracy: 0.001)
        XCTAssertEqual(result.highDoseMg, 0.075, accuracy: 0.001)
        XCTAssertFalse(result.cappedLow)
        XCTAssertFalse(result.cappedHigh)
    }

    // MARK: - Medication count

    func testMedicationCountIs9() {
        XCTAssertEqual(Medications.all.count, 9, "There should be exactly 9 medications in the database")
    }

    // MARK: - Concentration volume test — Ibuprofen with 100mg/5mL (mgPerMl=20)

    func testIbuprofenConcentrationVolume() {
        // ibu_100_5 has mgPerMl = 20
        // 10kg: lowDose=50 → volume = 50/20 = 2.5 mL
        //       highDose=100 → volume = 100/20 = 5.0 mL
        let conc = Medications.ibuprofen.concentrations.first { $0.id == "ibu_100_5" }!
        XCTAssertEqual(conc.mgPerMl, 20.0, accuracy: 0.01)
        let result = PediatricDosageCalculator.calculate(
            medication: Medications.ibuprofen,
            weightKg: 10.0,
            concentration: conc
        )
        XCTAssertNotNil(result.volumeMl)
        XCTAssertNotNil(result.volumeHighMl)
        XCTAssertEqual(result.volumeMl!, 2.5, accuracy: 0.01)
        XCTAssertEqual(result.volumeHighMl!, 5.0, accuracy: 0.01)
    }

    // MARK: - Capping boundary — Acetaminophen high only capped

    func testAcetaminophenHighOnlyCapped() {
        // Weight where low stays under 1000 but high exceeds 1000
        // 70kg: low=70*10=700 (not capped), high=70*15=1050 → capped to 1000
        let result = PediatricDosageCalculator.calculate(
            medication: Medications.acetaminophen,
            weightKg: 70.0
        )
        XCTAssertEqual(result.lowDoseMg, 700.0, accuracy: 0.01)
        XCTAssertEqual(result.highDoseMg, 1000.0, accuracy: 0.01)
        XCTAssertFalse(result.cappedLow)
        XCTAssertTrue(result.cappedHigh)
    }

    // MARK: - Capping boundary — Ibuprofen high only capped

    func testIbuprofenHighOnlyCapped() {
        // 50kg: low=50*5=250 (not capped), high=50*10=500 → capped to 400
        let result = PediatricDosageCalculator.calculate(
            medication: Medications.ibuprofen,
            weightKg: 50.0
        )
        XCTAssertEqual(result.lowDoseMg, 250.0, accuracy: 0.01)
        XCTAssertEqual(result.highDoseMg, 400.0, accuracy: 0.01)
        XCTAssertFalse(result.cappedLow)
        XCTAssertTrue(result.cappedHigh)
    }

    // MARK: - Volume with capped dose

    func testIbuprofenVolumeWhenCapped() {
        // 100kg: both capped to 400mg, conc=20mg/mL → volume=400/20=20mL
        let conc = Medications.ibuprofen.concentrations.first { $0.id == "ibu_100_5" }!
        let result = PediatricDosageCalculator.calculate(
            medication: Medications.ibuprofen,
            weightKg: 100.0,
            concentration: conc
        )
        XCTAssertEqual(result.lowDoseMg, 400.0, accuracy: 0.01)
        XCTAssertEqual(result.volumeMl!, 20.0, accuracy: 0.01)
        XCTAssertEqual(result.volumeHighMl!, 20.0, accuracy: 0.01)
    }

    // MARK: - Prednisolone partial capping

    func testPrednisoloneHighOnlyCapped() {
        // 40kg: low=40*1=40 (not capped), high=40*2=80 → capped to 60
        let result = PediatricDosageCalculator.calculate(
            medication: Medications.prednisolone,
            weightKg: 40.0
        )
        XCTAssertEqual(result.lowDoseMg, 40.0, accuracy: 0.01)
        XCTAssertEqual(result.highDoseMg, 60.0, accuracy: 0.01)
        XCTAssertFalse(result.cappedLow)
        XCTAssertTrue(result.cappedHigh)
    }

    // MARK: - All medications have unique IDs

    func testAllMedicationIDsAreUnique() {
        let ids = Medications.all.map(\.id)
        let uniqueIDs = Set(ids)
        XCTAssertEqual(ids.count, uniqueIDs.count, "All medication IDs must be unique")
    }

    // MARK: - All medications have at least one concentration

    func testAllMedicationsHaveConcentrations() {
        for med in Medications.all {
            XCTAssertFalse(med.concentrations.isEmpty, "\(med.id) should have at least one concentration")
        }
    }
}
