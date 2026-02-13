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

    // MARK: - HR=60 (RR=1.0): QTc should equal QT exactly

    func testHR60QTcEqualsQT() {
        // At HR=60, RR=1.0s, sqrt(1.0)=1.0, so QTc = QT
        let qt = 420.0
        let result = QTcCalculator.calculate(qtInterval: qt, heartRate: 60, sex: .male)
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.qtc, qt, accuracy: 0.01)
    }

    // MARK: - Very high HR=200

    func testVeryHighHR200() {
        // RR = 60/200 = 0.3s, QTc = QT / sqrt(0.3)
        let qt = 300.0
        let result = QTcCalculator.calculate(qtInterval: qt, heartRate: 200, sex: .male)
        XCTAssertNotNil(result)
        let expectedQTc = qt / sqrt(0.3)
        XCTAssertEqual(result!.qtc, expectedQTc, accuracy: 0.1)
    }

    // MARK: - Very low HR=40

    func testVeryLowHR40() {
        // RR = 60/40 = 1.5s, QTc = QT / sqrt(1.5)
        let qt = 400.0
        let result = QTcCalculator.calculate(qtInterval: qt, heartRate: 40, sex: .male)
        XCTAssertNotNil(result)
        let expectedQTc = qt / sqrt(1.5)
        XCTAssertEqual(result!.qtc, expectedQTc, accuracy: 0.1)
    }

    // MARK: - Male boundary tests (borderline = 440, prolonged = 460)

    func testMaleBoundary439IsNormal() {
        // QT=439, HR=60 → QTc=439 → < 440 → "qtc_normal"
        let result = QTcCalculator.calculate(qtInterval: 439, heartRate: 60, sex: .male)
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.qtc, 439.0, accuracy: 0.1)
        XCTAssertEqual(result!.interpretationKey, "qtc_normal")
    }

    func testMaleBoundary440IsBorderline() {
        // QT=440, HR=60 → QTc=440 → >= 440 and < 460 → "qtc_borderline"
        let result = QTcCalculator.calculate(qtInterval: 440, heartRate: 60, sex: .male)
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.qtc, 440.0, accuracy: 0.1)
        XCTAssertEqual(result!.interpretationKey, "qtc_borderline")
    }

    func testMaleBoundary460IsProlonged() {
        // QT=460, HR=60 → QTc=460 → >= 460 → "qtc_prolonged"
        let result = QTcCalculator.calculate(qtInterval: 460, heartRate: 60, sex: .male)
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.qtc, 460.0, accuracy: 0.1)
        XCTAssertEqual(result!.interpretationKey, "qtc_prolonged")
    }

    // MARK: - Female boundary tests (borderline = 440, prolonged = 470)

    func testFemaleBoundary440IsBorderline() {
        // QT=440, HR=60 → QTc=440 → >= 440 and < 470 → "qtc_borderline"
        let result = QTcCalculator.calculate(qtInterval: 440, heartRate: 60, sex: .female)
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.qtc, 440.0, accuracy: 0.1)
        XCTAssertEqual(result!.interpretationKey, "qtc_borderline")
    }

    func testFemaleBoundary469IsBorderline() {
        // QT=469, HR=60 → QTc=469 → >= 440 and < 470 → "qtc_borderline"
        let result = QTcCalculator.calculate(qtInterval: 469, heartRate: 60, sex: .female)
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.qtc, 469.0, accuracy: 0.1)
        XCTAssertEqual(result!.interpretationKey, "qtc_borderline")
    }

    func testFemaleBoundary470IsProlonged() {
        // QT=470, HR=60 → QTc=470 → >= 470 → "qtc_prolonged"
        let result = QTcCalculator.calculate(qtInterval: 470, heartRate: 60, sex: .female)
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.qtc, 470.0, accuracy: 0.1)
        XCTAssertEqual(result!.interpretationKey, "qtc_prolonged")
    }

    // MARK: - Negative input tests

    func testNegativeQTReturnsNil() {
        let result = QTcCalculator.calculate(qtInterval: -100, heartRate: 60, sex: .male)
        XCTAssertNil(result)
    }

    func testNegativeHRReturnsNil() {
        let result = QTcCalculator.calculate(qtInterval: 400, heartRate: -60, sex: .male)
        XCTAssertNil(result)
    }
}
