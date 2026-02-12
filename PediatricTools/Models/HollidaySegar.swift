import Foundation

enum HollidaySegarCalculator {
    struct Result {
        let dailyMl: Double
        let hourlyMl: Double
        let dailyPerKg: Double
    }

    /// Holliday-Segar method for maintenance IV fluid calculation.
    /// - 0–10 kg: 100 mL/kg/day
    /// - 10–20 kg: 1000 mL + 50 mL/kg/day for each kg over 10
    /// - >20 kg: 1500 mL + 20 mL/kg/day for each kg over 20
    static func calculate(weightKg: Double) -> Result {
        guard weightKg > 0 else {
            return Result(dailyMl: 0, hourlyMl: 0, dailyPerKg: 0)
        }

        let daily: Double
        if weightKg <= 10 {
            daily = weightKg * 100
        } else if weightKg <= 20 {
            daily = 1000 + (weightKg - 10) * 50
        } else {
            daily = 1500 + (weightKg - 20) * 20
        }

        return Result(
            dailyMl: daily,
            hourlyMl: daily / 24.0,
            dailyPerKg: daily / weightKg
        )
    }

    /// Recommended electrolyte additions per liter of maintenance fluid.
    struct Electrolytes {
        static let sodiumMeqPerL = 20.0...30.0
        static let potassiumMeqPerL = 20.0
        static let dextrosePercent = 5.0
    }
}
