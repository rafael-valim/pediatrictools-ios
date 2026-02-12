import Foundation

enum BSACalculator {
    /// Mosteller formula: BSA (m²) = √(height_cm × weight_kg / 3600)
    static func mosteller(heightCm: Double, weightKg: Double) -> Double {
        guard heightCm > 0, weightKg > 0 else { return 0 }
        return sqrt(heightCm * weightKg / 3600.0)
    }
}
