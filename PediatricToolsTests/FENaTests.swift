import XCTest
@testable import PediatricTools

final class FENaTests: XCTestCase {

    // MARK: - Existing tests

    func testPrerenalCase() {
        // UNa=10, PNa=140, UCr=100, PCr=1.0
        // FENa = (10 * 1.0) / (140 * 100) * 100 = 1000 / 14000 = 0.0714%
        let result = FENaCalculator.calculate(
            urineSodium: 10.0,
            plasmaSodium: 140.0,
            urineCreatinine: 100.0,
            plasmaCreatinine: 1.0
        )
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.fena, 0.0714, accuracy: 0.001)
        XCTAssertEqual(result!.interpretationKey, "fena_prerenal")
    }

    func testIntrinsicCase() {
        // UNa=80, PNa=140, UCr=40, PCr=2.0
        // FENa = (80 * 2.0) / (140 * 40) * 100 = 16000 / 5600 = 2.857%
        let result = FENaCalculator.calculate(
            urineSodium: 80.0,
            plasmaSodium: 140.0,
            urineCreatinine: 40.0,
            plasmaCreatinine: 2.0
        )
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.fena, 2.857, accuracy: 0.001)
        XCTAssertEqual(result!.interpretationKey, "fena_intrinsic")
    }

    func testPrerenalBorderlineCase() {
        // UNa=30, PNa=140, UCr=50, PCr=1.5
        // FENa = (30 * 1.5) / (140 * 50) * 100 = 4500 / 7000 = 0.6429%
        let result = FENaCalculator.calculate(
            urineSodium: 30.0,
            plasmaSodium: 140.0,
            urineCreatinine: 50.0,
            plasmaCreatinine: 1.5
        )
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.fena, 0.643, accuracy: 0.001)
        XCTAssertEqual(result!.interpretationKey, "fena_prerenal")
    }

    func testZeroPlasmaSodiumReturnsNil() {
        let result = FENaCalculator.calculate(
            urineSodium: 10.0,
            plasmaSodium: 0.0,
            urineCreatinine: 100.0,
            plasmaCreatinine: 1.0
        )
        XCTAssertNil(result)
    }

    func testZeroUrineCreatinineReturnsNil() {
        let result = FENaCalculator.calculate(
            urineSodium: 10.0,
            plasmaSodium: 140.0,
            urineCreatinine: 0.0,
            plasmaCreatinine: 1.0
        )
        XCTAssertNil(result)
    }

    // MARK: - Exact boundary: FENa = 1.0 (indeterminate, not prerenal)

    func testFENaExactly1_0IsIndeterminate() {
        // FENa = (UNa * PCr) / (PNa * UCr) * 100 = 1.0
        // UNa=14, PNa=140, UCr=10, PCr=1.0
        // FENa = (14 * 1.0) / (140 * 10) * 100 = 1400 / 1400 = 1.0
        // 1.0 is NOT < 1.0, so it falls into the <= 2.0 branch -> indeterminate
        let result = FENaCalculator.calculate(
            urineSodium: 14.0,
            plasmaSodium: 140.0,
            urineCreatinine: 10.0,
            plasmaCreatinine: 1.0
        )
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.fena, 1.0, accuracy: 0.001)
        XCTAssertEqual(result!.interpretationKey, "fena_indeterminate")
    }

    // MARK: - Exact boundary: FENa = 2.0 (still indeterminate)

    func testFENaExactly2_0IsIndeterminate() {
        // UNa=28, PNa=140, UCr=10, PCr=1.0
        // FENa = (28 * 1.0) / (140 * 10) * 100 = 2800 / 1400 = 2.0
        // 2.0 is <= 2.0, so indeterminate
        let result = FENaCalculator.calculate(
            urineSodium: 28.0,
            plasmaSodium: 140.0,
            urineCreatinine: 10.0,
            plasmaCreatinine: 1.0
        )
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.fena, 2.0, accuracy: 0.001)
        XCTAssertEqual(result!.interpretationKey, "fena_indeterminate")
    }

    // MARK: - Just above 2.0 is intrinsic

    func testFENaJustAbove2_0IsIntrinsic() {
        // UNa=28.1, PNa=140, UCr=10, PCr=1.0
        // FENa = (28.1 * 1.0) / (140 * 10) * 100 = 2810 / 1400 = 2.007...
        let result = FENaCalculator.calculate(
            urineSodium: 28.1,
            plasmaSodium: 140.0,
            urineCreatinine: 10.0,
            plasmaCreatinine: 1.0
        )
        XCTAssertNotNil(result)
        XCTAssertGreaterThan(result!.fena, 2.0)
        XCTAssertEqual(result!.interpretationKey, "fena_intrinsic")
    }

    // MARK: - Just below 1.0 is prerenal

    func testFENaJustBelow1_0IsPrerenal() {
        // UNa=13.9, PNa=140, UCr=10, PCr=1.0
        // FENa = (13.9 * 1.0) / (140 * 10) * 100 = 1390 / 1400 = 0.9929
        let result = FENaCalculator.calculate(
            urineSodium: 13.9,
            plasmaSodium: 140.0,
            urineCreatinine: 10.0,
            plasmaCreatinine: 1.0
        )
        XCTAssertNotNil(result)
        XCTAssertLessThan(result!.fena, 1.0)
        XCTAssertEqual(result!.interpretationKey, "fena_prerenal")
    }

    // MARK: - Very high FENa

    func testVeryHighFENa() {
        // UNa=100, PNa=100, UCr=10, PCr=1.0
        // FENa = (100 * 1.0) / (100 * 10) * 100 = 10000 / 1000 = 10.0%
        let result = FENaCalculator.calculate(
            urineSodium: 100.0,
            plasmaSodium: 100.0,
            urineCreatinine: 10.0,
            plasmaCreatinine: 1.0
        )
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.fena, 10.0, accuracy: 0.001)
        XCTAssertEqual(result!.interpretationKey, "fena_intrinsic")
    }

    // MARK: - Numerator zeros (UNa=0 or PCr=0): valid, result = 0

    func testZeroUrineSodiumReturnsZeroFENa() {
        // UNa=0 is in the numerator, so FENa = 0 -> prerenal
        let result = FENaCalculator.calculate(
            urineSodium: 0.0,
            plasmaSodium: 140.0,
            urineCreatinine: 100.0,
            plasmaCreatinine: 1.0
        )
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.fena, 0.0, accuracy: 0.001)
        XCTAssertEqual(result!.interpretationKey, "fena_prerenal")
    }

    func testZeroPlasmaCreatinineReturnsZeroFENa() {
        // PCr=0 is in the numerator, so FENa = 0 -> prerenal
        let result = FENaCalculator.calculate(
            urineSodium: 10.0,
            plasmaSodium: 140.0,
            urineCreatinine: 100.0,
            plasmaCreatinine: 0.0
        )
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.fena, 0.0, accuracy: 0.001)
        XCTAssertEqual(result!.interpretationKey, "fena_prerenal")
    }

    // MARK: - Both denominator values zero returns nil

    func testBothDenominatorZerosReturnNil() {
        let result = FENaCalculator.calculate(
            urineSodium: 10.0,
            plasmaSodium: 0.0,
            urineCreatinine: 0.0,
            plasmaCreatinine: 1.0
        )
        XCTAssertNil(result)
    }

    // MARK: - All zeros returns nil (denominators are zero)

    func testAllZerosReturnsNil() {
        let result = FENaCalculator.calculate(
            urineSodium: 0.0,
            plasmaSodium: 0.0,
            urineCreatinine: 0.0,
            plasmaCreatinine: 0.0
        )
        XCTAssertNil(result)
    }

    // MARK: - FENa formula verification

    func testFENaFormulaIsCorrect() {
        // Verify: FENa = (UNa * PCr) / (PNa * UCr) * 100
        let uNa = 50.0, pNa = 135.0, uCr = 80.0, pCr = 1.2
        let expectedFENa = (uNa * pCr) / (pNa * uCr) * 100.0
        let result = FENaCalculator.calculate(
            urineSodium: uNa,
            plasmaSodium: pNa,
            urineCreatinine: uCr,
            plasmaCreatinine: pCr
        )
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.fena, expectedFENa, accuracy: 0.001)
    }

    // MARK: - Indeterminate range values

    func testFENa1_5IsIndeterminate() {
        // Engineer values to get FENa = 1.5
        // FENa = (UNa * PCr) / (PNa * UCr) * 100 = 1.5
        // UNa=21, PNa=140, UCr=10, PCr=1.0 -> (21*1)/(140*10)*100 = 2100/1400 = 1.5
        let result = FENaCalculator.calculate(
            urineSodium: 21.0,
            plasmaSodium: 140.0,
            urineCreatinine: 10.0,
            plasmaCreatinine: 1.0
        )
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.fena, 1.5, accuracy: 0.001)
        XCTAssertEqual(result!.interpretationKey, "fena_indeterminate")
    }
}
