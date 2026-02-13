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

    // MARK: - Additional age-based tests

    func testAge0Infant() {
        // Uncuffed: (0/4 + 4) = 4.0, Cuffed: (0/4 + 3.5) = 3.5
        // Both round to nearest 0.5: 4.0, 3.5 (already on 0.5)
        // depthOral = 4.0 * 3 = 12, depthNasal = 12 + 2 = 14, suction = 4.0 * 2 = 8
        let result = ETTCalculator.calculate(ageYears: 0.0)
        XCTAssertEqual(result.uncuffedSize, 4.0, accuracy: 0.01)
        XCTAssertEqual(result.cuffedSize, 3.5, accuracy: 0.01)
        XCTAssertEqual(result.depthOralCm, 12.0, accuracy: 0.01)
        XCTAssertEqual(result.depthNasalCm, 14.0, accuracy: 0.01)
        XCTAssertEqual(result.suctionCatheterFr, 8.0, accuracy: 0.01)
    }

    func testAge1Year() {
        // Uncuffed raw: (1/4 + 4) = 4.25, rounded to 0.5 -> 4.5
        // Cuffed raw: (1/4 + 3.5) = 3.75, rounded to 0.5 -> 4.0
        // depthOral = 4.5 * 3 = 13.5, depthNasal = 13.5 + 2 = 15.5, suction = 4.5 * 2 = 9
        let result = ETTCalculator.calculate(ageYears: 1.0)
        XCTAssertEqual(result.uncuffedSize, 4.5, accuracy: 0.01)
        XCTAssertEqual(result.cuffedSize, 4.0, accuracy: 0.01)
        XCTAssertEqual(result.depthOralCm, 13.5, accuracy: 0.01)
        XCTAssertEqual(result.depthNasalCm, 15.5, accuracy: 0.01)
        XCTAssertEqual(result.suctionCatheterFr, 9.0, accuracy: 0.01)
    }

    func testAge2Years() {
        // Uncuffed raw: (2/4 + 4) = 4.5, rounded -> 4.5
        // Cuffed raw: (2/4 + 3.5) = 4.0, rounded -> 4.0
        // depthOral = 4.5 * 3 = 13.5, depthNasal = 15.5, suction = 9.0
        let result = ETTCalculator.calculate(ageYears: 2.0)
        XCTAssertEqual(result.uncuffedSize, 4.5, accuracy: 0.01)
        XCTAssertEqual(result.cuffedSize, 4.0, accuracy: 0.01)
        XCTAssertEqual(result.depthOralCm, 13.5, accuracy: 0.01)
        XCTAssertEqual(result.depthNasalCm, 15.5, accuracy: 0.01)
        XCTAssertEqual(result.suctionCatheterFr, 9.0, accuracy: 0.01)
    }

    func testAge12Years() {
        // Uncuffed raw: (12/4 + 4) = 7.0, rounded -> 7.0
        // Cuffed raw: (12/4 + 3.5) = 6.5, rounded -> 6.5
        // depthOral = 7.0 * 3 = 21, depthNasal = 23, suction = 14
        let result = ETTCalculator.calculate(ageYears: 12.0)
        XCTAssertEqual(result.uncuffedSize, 7.0, accuracy: 0.01)
        XCTAssertEqual(result.cuffedSize, 6.5, accuracy: 0.01)
        XCTAssertEqual(result.depthOralCm, 21.0, accuracy: 0.01)
        XCTAssertEqual(result.depthNasalCm, 23.0, accuracy: 0.01)
        XCTAssertEqual(result.suctionCatheterFr, 14.0, accuracy: 0.01)
    }

    func testAge16Years() {
        // Uncuffed raw: (16/4 + 4) = 8.0, rounded -> 8.0
        // Cuffed raw: (16/4 + 3.5) = 7.5, rounded -> 7.5
        // depthOral = 8.0 * 3 = 24, depthNasal = 26, suction = 16
        let result = ETTCalculator.calculate(ageYears: 16.0)
        XCTAssertEqual(result.uncuffedSize, 8.0, accuracy: 0.01)
        XCTAssertEqual(result.cuffedSize, 7.5, accuracy: 0.01)
        XCTAssertEqual(result.depthOralCm, 24.0, accuracy: 0.01)
        XCTAssertEqual(result.depthNasalCm, 26.0, accuracy: 0.01)
        XCTAssertEqual(result.suctionCatheterFr, 16.0, accuracy: 0.01)
    }

    // MARK: - Rounding behavior for non-integer ages

    func testAge3YearsRoundingToNearest0_5() {
        // Uncuffed raw: (3/4 + 4) = 4.75, rounded to nearest 0.5 -> 5.0
        // Cuffed raw: (3/4 + 3.5) = 4.25, rounded to nearest 0.5 -> 4.5
        // (4.75 * 2 = 9.5, rounded = 10, /2 = 5.0)
        // (4.25 * 2 = 8.5, rounded = 8 or 9? -> .rounded() uses "round half to even", 8.5 -> 8)
        // Actually: (4.25 * 2).rounded() = 8.0.rounded() = 8.0, /2 = 4.0
        // Wait: 4.25 * 2 = 8.5; 8.5.rounded() with default rounding (.toNearestOrAwayFromZero) in Swift = 9, /2 = 4.5
        // Swift's .rounded() uses .toNearestOrAwayFromZero
        let result = ETTCalculator.calculate(ageYears: 3.0)
        XCTAssertEqual(result.uncuffedSize, 5.0, accuracy: 0.01)
        XCTAssertEqual(result.cuffedSize, 4.5, accuracy: 0.01)
    }

    func testAge5YearsRounding() {
        // Uncuffed raw: (5/4 + 4) = 5.25, *2 = 10.5, rounded = 11, /2 = 5.5
        // Cuffed raw: (5/4 + 3.5) = 4.75, *2 = 9.5, rounded = 10, /2 = 5.0
        let result = ETTCalculator.calculate(ageYears: 5.0)
        XCTAssertEqual(result.uncuffedSize, 5.5, accuracy: 0.01)
        XCTAssertEqual(result.cuffedSize, 5.0, accuracy: 0.01)
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

    func testNeonatal2To3Kg() {
        // 2-3kg: size=3.0 (same bracket as 1-2 in the switch), cuffed=max(2.5, 2.5)=2.5
        // depthOral = 3.0*3 = 9, depthNasal = 11, suction = 6
        let result = ETTCalculator.neonatalSize(weightKg: 2.5)
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

    // MARK: - Neonatal boundary weights

    func testNeonatalExactly1Kg() {
        // 1..<2 bracket: size=3.0
        let result = ETTCalculator.neonatalSize(weightKg: 1.0)
        XCTAssertEqual(result.uncuffedSize, 3.0, accuracy: 0.01)
        XCTAssertEqual(result.cuffedSize, 2.5, accuracy: 0.01)
    }

    func testNeonatalExactly3Kg() {
        // 3..<4 bracket: size=3.5
        let result = ETTCalculator.neonatalSize(weightKg: 3.0)
        XCTAssertEqual(result.uncuffedSize, 3.5, accuracy: 0.01)
        XCTAssertEqual(result.cuffedSize, 3.0, accuracy: 0.01)
    }

    func testNeonatalAbove4Kg() {
        // default bracket: size=3.5
        let result = ETTCalculator.neonatalSize(weightKg: 4.5)
        XCTAssertEqual(result.uncuffedSize, 3.5, accuracy: 0.01)
        XCTAssertEqual(result.cuffedSize, 3.0, accuracy: 0.01)
        XCTAssertEqual(result.depthOralCm, 10.5, accuracy: 0.01)
        XCTAssertEqual(result.depthNasalCm, 12.5, accuracy: 0.01)
        XCTAssertEqual(result.suctionCatheterFr, 7.0, accuracy: 0.01)
    }

    // MARK: - Depth and suction derivation consistency

    func testDepthIsUncuffedTimesThrueForMultipleAges() {
        let ages = [0.0, 2.0, 4.0, 6.0, 8.0, 10.0, 12.0, 16.0]
        for age in ages {
            let result = ETTCalculator.calculate(ageYears: age)
            XCTAssertEqual(result.depthOralCm, result.uncuffedSize * 3, accuracy: 0.01,
                           "Oral depth should be uncuffedSize * 3 for age \(age)")
            XCTAssertEqual(result.depthNasalCm, result.uncuffedSize * 3 + 2, accuracy: 0.01,
                           "Nasal depth should be oral depth + 2 for age \(age)")
            XCTAssertEqual(result.suctionCatheterFr, result.uncuffedSize * 2, accuracy: 0.01,
                           "Suction catheter should be uncuffedSize * 2 for age \(age)")
        }
    }

    func testDepthAndSuctionForNeonatalWeights() {
        let weights = [0.5, 1.0, 1.5, 2.0, 2.5, 3.0, 3.5, 4.0, 5.0]
        for weight in weights {
            let result = ETTCalculator.neonatalSize(weightKg: weight)
            XCTAssertEqual(result.depthOralCm, result.uncuffedSize * 3, accuracy: 0.01,
                           "Oral depth should be size * 3 for neonatal weight \(weight)kg")
            XCTAssertEqual(result.depthNasalCm, result.uncuffedSize * 3 + 2, accuracy: 0.01,
                           "Nasal depth should be oral depth + 2 for neonatal weight \(weight)kg")
            XCTAssertEqual(result.suctionCatheterFr, result.uncuffedSize * 2, accuracy: 0.01,
                           "Suction catheter should be size * 2 for neonatal weight \(weight)kg")
        }
    }

    // MARK: - Cuffed is always 0.5 less than uncuffed (age-based)

    func testCuffedIsHalfLessThanUncuffedForAges() {
        let ages = [0.0, 2.0, 4.0, 6.0, 8.0, 10.0, 12.0, 16.0]
        for age in ages {
            let result = ETTCalculator.calculate(ageYears: age)
            XCTAssertEqual(result.cuffedSize, result.uncuffedSize - 0.5, accuracy: 0.01,
                           "Cuffed should be uncuffed - 0.5 for age \(age)")
        }
    }
}
