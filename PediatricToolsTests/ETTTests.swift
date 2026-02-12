import XCTest
@testable import PediatricTools

final class ETTTests: XCTestCase {

    // MARK: - Age-based sizing

    func testAge4Years() {
        // Uncuffed: (4/4 + 4) = 5.0, Cuffed: (4/4 + 3.5) = 4.5
        // depthOral = 5.0 * 3 = 15, depthNasal = 15 + 2 = 17, suction = 5.0 * 2 = 10
        let result = ETTCalculator.calculate(ageYears: 4.0)
        XCTAssertEqual(result.uncuffedSize, 5.0, accuracy: 0.01)
        XCTAssertEqual(result.cuffedSize, 4.5, accuracy: 0.01)
        XCTAssertEqual(result.depthOralCm, 15.0, accuracy: 0.01)
        XCTAssertEqual(result.depthNasalCm, 17.0, accuracy: 0.01)
        XCTAssertEqual(result.suctionCatheterFr, 10.0, accuracy: 0.01)
    }

    func testAge8Years() {
        // Uncuffed: (8/4 + 4) = 6.0, Cuffed: (8/4 + 3.5) = 5.5
        // depthOral = 6.0 * 3 = 18, depthNasal = 18 + 2 = 20, suction = 6.0 * 2 = 12
        let result = ETTCalculator.calculate(ageYears: 8.0)
        XCTAssertEqual(result.uncuffedSize, 6.0, accuracy: 0.01)
        XCTAssertEqual(result.cuffedSize, 5.5, accuracy: 0.01)
        XCTAssertEqual(result.depthOralCm, 18.0, accuracy: 0.01)
        XCTAssertEqual(result.depthNasalCm, 20.0, accuracy: 0.01)
        XCTAssertEqual(result.suctionCatheterFr, 12.0, accuracy: 0.01)
    }

    // MARK: - Neonatal weight-based sizing

    func testNeonatalUnder1Kg() {
        // <1kg: size=2.5, cuffed=max(2.5, 2.0)=2.5
        // depthOral = 2.5*3 = 7.5, depthNasal = 7.5+2 = 9.5, suction = 2.5*2 = 5
        let result = ETTCalculator.neonatalSize(weightKg: 0.8)
        XCTAssertEqual(result.uncuffedSize, 2.5, accuracy: 0.01)
        XCTAssertEqual(result.cuffedSize, 2.5, accuracy: 0.01)
        XCTAssertEqual(result.depthOralCm, 7.5, accuracy: 0.01)
        XCTAssertEqual(result.depthNasalCm, 9.5, accuracy: 0.01)
        XCTAssertEqual(result.suctionCatheterFr, 5.0, accuracy: 0.01)
    }

    func testNeonatal1To2Kg() {
        // 1-2kg: size=3.0, cuffed=max(2.5, 2.5)=2.5
        // depthOral = 3.0*3 = 9, depthNasal = 9+2 = 11, suction = 3.0*2 = 6
        let result = ETTCalculator.neonatalSize(weightKg: 1.5)
        XCTAssertEqual(result.uncuffedSize, 3.0, accuracy: 0.01)
        XCTAssertEqual(result.cuffedSize, 2.5, accuracy: 0.01)
        XCTAssertEqual(result.depthOralCm, 9.0, accuracy: 0.01)
        XCTAssertEqual(result.depthNasalCm, 11.0, accuracy: 0.01)
        XCTAssertEqual(result.suctionCatheterFr, 6.0, accuracy: 0.01)
    }

    func testNeonatal3To4Kg() {
        // 3-4kg: size=3.5, cuffed=max(2.5, 3.0)=3.0
        // depthOral = 3.5*3 = 10.5, depthNasal = 10.5+2 = 12.5, suction = 3.5*2 = 7
        let result = ETTCalculator.neonatalSize(weightKg: 3.5)
        XCTAssertEqual(result.uncuffedSize, 3.5, accuracy: 0.01)
        XCTAssertEqual(result.cuffedSize, 3.0, accuracy: 0.01)
        XCTAssertEqual(result.depthOralCm, 10.5, accuracy: 0.01)
        XCTAssertEqual(result.depthNasalCm, 12.5, accuracy: 0.01)
        XCTAssertEqual(result.suctionCatheterFr, 7.0, accuracy: 0.01)
    }
}
