import Foundation

enum ETTCalculator {
    struct Result {
        let uncuffedSize: Double
        let cuffedSize: Double
        let depthOralCm: Double
        let depthNasalCm: Double
        let suctionCatheterFr: Double
    }

    /// Calculates ETT size based on age.
    /// - Uncuffed: (age in years / 4) + 4
    /// - Cuffed: (age in years / 4) + 3.5
    /// - Oral depth (cm): ETT size × 3
    /// - Nasal depth (cm): ETT size × 3 + 2 (approximate)
    /// - Suction catheter (Fr): ETT size × 2
    static func calculate(ageYears: Double) -> Result {
        let uncuffed = (ageYears / 4.0) + 4.0
        let cuffed = (ageYears / 4.0) + 3.5
        // Round to nearest 0.5
        let uncuffedRounded = (uncuffed * 2).rounded() / 2
        let cuffedRounded = (cuffed * 2).rounded() / 2

        return Result(
            uncuffedSize: uncuffedRounded,
            cuffedSize: cuffedRounded,
            depthOralCm: uncuffedRounded * 3,
            depthNasalCm: uncuffedRounded * 3 + 2,
            suctionCatheterFr: uncuffedRounded * 2
        )
    }

    /// For neonates/infants, use weight-based sizing.
    static func neonatalSize(weightKg: Double) -> Result {
        let size: Double
        switch weightKg {
        case ..<1: size = 2.5
        case 1..<2: size = 3.0
        case 2..<3: size = 3.0
        case 3..<4: size = 3.5
        default: size = 3.5
        }
        return Result(
            uncuffedSize: size,
            cuffedSize: max(2.5, size - 0.5),
            depthOralCm: size * 3,
            depthNasalCm: size * 3 + 2,
            suctionCatheterFr: size * 2
        )
    }
}
