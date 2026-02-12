import XCTest
@testable import PediatricTools

final class FENaTests: XCTestCase {

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
}
