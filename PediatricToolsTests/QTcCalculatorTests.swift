import XCTest
@testable import PediatricTools

final class QTcCalculatorTests: XCTestCase {

    func testKnownQTcValue() {
        // QT=400ms, HR=60bpm → RR=1s → QTc = 400/√1 = 400ms
        let result = QTcCalculator.calculate(qtInterval: 400, heartRate: 60, sex: .male)
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.qtc, 400.0, accuracy: 0.1)
    }

    func testQTcAtHR75() {
        // QT=350ms, HR=75bpm → RR=0.8s → QTc = 350/√0.8 ≈ 391.2ms
        let result = QTcCalculator.calculate(qtInterval: 350, heartRate: 75, sex: .male)
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.qtc, 350.0 / sqrt(0.8), accuracy: 0.1)
    }

    func testNormalQTcMale() {
        // QTc < 440 → normal
        let result = QTcCalculator.calculate(qtInterval: 380, heartRate: 60, sex: .male)
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.interpretationKey, "qtc_normal")
    }

    func testBorderlineMale() {
        // QTc 440-459 for male → borderline
        let result = QTcCalculator.calculate(qtInterval: 450, heartRate: 60, sex: .male)
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.interpretationKey, "qtc_borderline")
    }

    func testProlongedMale() {
        // QTc ≥ 460 for male → prolonged
        let result = QTcCalculator.calculate(qtInterval: 470, heartRate: 60, sex: .male)
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.interpretationKey, "qtc_prolonged")
    }

    func testBorderlineFemale() {
        // QTc 440-469 for female → borderline
        let result = QTcCalculator.calculate(qtInterval: 460, heartRate: 60, sex: .female)
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.interpretationKey, "qtc_borderline")
    }

    func testProlongedFemale() {
        // QTc ≥ 470 for female → prolonged
        let result = QTcCalculator.calculate(qtInterval: 480, heartRate: 60, sex: .female)
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.interpretationKey, "qtc_prolonged")
    }

    func testZeroQTReturnsNil() {
        let result = QTcCalculator.calculate(qtInterval: 0, heartRate: 60, sex: .male)
        XCTAssertNil(result)
    }

    func testZeroHRReturnsNil() {
        let result = QTcCalculator.calculate(qtInterval: 400, heartRate: 0, sex: .male)
        XCTAssertNil(result)
    }

    func testHighHeartRate() {
        // QT=300ms, HR=150bpm → RR=0.4s → QTc = 300/√0.4 ≈ 474.3ms
        let result = QTcCalculator.calculate(qtInterval: 300, heartRate: 150, sex: .male)
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.qtc, 300.0 / sqrt(0.4), accuracy: 0.1)
    }
}
