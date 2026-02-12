import Foundation

enum DehydrationSeverity: String, CaseIterable, Identifiable {
    case mild
    case moderate
    case severe

    var id: String { rawValue }

    var nameKey: String {
        switch self {
        case .mild: return "dehydration_mild"
        case .moderate: return "dehydration_moderate"
        case .severe: return "dehydration_severe"
        }
    }

    var percentRange: String {
        switch self {
        case .mild: return "3–5%"
        case .moderate: return "6–9%"
        case .severe: return "≥10%"
        }
    }

    var defaultPercent: Double {
        switch self {
        case .mild: return 5
        case .moderate: return 7.5
        case .severe: return 10
        }
    }
}

enum DehydrationCalculator {
    struct Result {
        let deficitMl: Double
        let maintenanceMlPerDay: Double
        let totalFirst24hMl: Double
    }

    /// Calculates fluid deficit and replacement plan.
    /// Deficit (mL) = weight (kg) × percent dehydration × 10
    /// Maintenance uses Holliday-Segar.
    static func calculate(weightKg: Double, dehydrationPercent: Double) -> Result {
        guard weightKg > 0, dehydrationPercent > 0 else {
            return Result(deficitMl: 0, maintenanceMlPerDay: 0, totalFirst24hMl: 0)
        }

        let deficit = weightKg * dehydrationPercent * 10 // percent × 10 = mL/kg → × weight
        let maintenance = HollidaySegarCalculator.calculate(weightKg: weightKg).dailyMl
        let total24h = deficit + maintenance

        return Result(
            deficitMl: deficit,
            maintenanceMlPerDay: maintenance,
            totalFirst24hMl: total24h
        )
    }
}
