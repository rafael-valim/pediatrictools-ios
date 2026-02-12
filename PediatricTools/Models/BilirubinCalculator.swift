import Foundation

enum BilirubinRiskCategory: String, CaseIterable, Identifiable {
    case lowRisk       // ≥38 weeks, no risk factors
    case mediumRisk    // ≥38 weeks with risk factors, or 35-37 6/7 weeks
    case highRisk      // 35-37 6/7 weeks with risk factors

    var id: String { rawValue }

    var localizedKey: String {
        switch self {
        case .lowRisk: return "bili_risk_low"
        case .mediumRisk: return "bili_risk_medium"
        case .highRisk: return "bili_risk_high"
        }
    }
}

enum BilirubinGACategory: String, CaseIterable, Identifiable {
    case term       // ≥38 weeks
    case latePreterm // 35-37 6/7 weeks

    var id: String { rawValue }

    var localizedKey: String {
        switch self {
        case .term: return "bili_ga_term"
        case .latePreterm: return "bili_ga_late_preterm"
        }
    }
}

enum BilirubinCalculator {
    struct Result {
        let phototherapyThreshold: Double
        let exchangeThreshold: Double
        let exceedsPhototherapy: Bool
        let exceedsExchange: Bool
        let interpretationKey: String
        let riskCategory: BilirubinRiskCategory
    }

    /// Determines risk category based on gestational age and neurotoxicity risk factors.
    static func riskCategory(ga: BilirubinGACategory, hasRiskFactors: Bool) -> BilirubinRiskCategory {
        switch (ga, hasRiskFactors) {
        case (.term, false): return .lowRisk
        case (.term, true), (.latePreterm, false): return .mediumRisk
        case (.latePreterm, true): return .highRisk
        }
    }

    /// Calculates bilirubin thresholds based on AAP 2022 guidelines.
    /// Returns phototherapy and exchange transfusion thresholds for the given postnatal age.
    static func calculate(
        bilirubinMgDL: Double,
        postnatalAgeHours: Double,
        gaCategory: BilirubinGACategory,
        hasRiskFactors: Bool
    ) -> Result? {
        guard bilirubinMgDL >= 0, postnatalAgeHours >= 0 else { return nil }

        let risk = riskCategory(ga: gaCategory, hasRiskFactors: hasRiskFactors)
        let photoThreshold = phototherapyThreshold(hours: postnatalAgeHours, risk: risk)
        let exchangeThreshold = exchangeTransfusionThreshold(hours: postnatalAgeHours, risk: risk)

        let exceedsPhoto = bilirubinMgDL >= photoThreshold
        let exceedsExchange = bilirubinMgDL >= exchangeThreshold

        let interpretation: String
        if exceedsExchange {
            interpretation = "bili_exceeds_exchange"
        } else if exceedsPhoto {
            interpretation = "bili_exceeds_photo"
        } else {
            interpretation = "bili_below_threshold"
        }

        return Result(
            phototherapyThreshold: photoThreshold,
            exchangeThreshold: exchangeThreshold,
            exceedsPhototherapy: exceedsPhoto,
            exceedsExchange: exceedsExchange,
            interpretationKey: interpretation,
            riskCategory: risk
        )
    }

    // MARK: - AAP 2022 Phototherapy Thresholds

    /// Hour-specific phototherapy thresholds (mg/dL) from AAP 2022 nomogram.
    /// Linear interpolation between data points.
    private static func phototherapyThreshold(hours: Double, risk: BilirubinRiskCategory) -> Double {
        let data: [(hours: Double, threshold: Double)]
        switch risk {
        case .lowRisk:
            data = [
                (0, 5.0), (12, 8.0), (24, 11.0), (36, 13.5),
                (48, 15.5), (60, 17.0), (72, 18.5), (84, 19.5),
                (96, 20.5), (108, 21.0), (120, 21.0),
            ]
        case .mediumRisk:
            data = [
                (0, 4.0), (12, 6.5), (24, 9.0), (36, 11.0),
                (48, 13.0), (60, 14.5), (72, 15.5), (84, 16.5),
                (96, 17.0), (108, 17.5), (120, 17.5),
            ]
        case .highRisk:
            data = [
                (0, 3.0), (12, 5.0), (24, 7.0), (36, 8.5),
                (48, 10.0), (60, 11.5), (72, 12.5), (84, 13.5),
                (96, 14.0), (108, 14.5), (120, 14.5),
            ]
        }
        return interpolate(hours: hours, data: data)
    }

    /// Hour-specific exchange transfusion thresholds (mg/dL) from AAP 2022.
    private static func exchangeTransfusionThreshold(hours: Double, risk: BilirubinRiskCategory) -> Double {
        let data: [(hours: Double, threshold: Double)]
        switch risk {
        case .lowRisk:
            data = [
                (0, 8.0), (12, 12.0), (24, 16.0), (36, 19.0),
                (48, 21.5), (60, 23.0), (72, 24.0), (84, 24.5),
                (96, 25.0), (108, 25.0), (120, 25.0),
            ]
        case .mediumRisk:
            data = [
                (0, 7.0), (12, 10.0), (24, 13.5), (36, 16.0),
                (48, 18.0), (60, 19.5), (72, 20.5), (84, 21.0),
                (96, 21.5), (108, 22.0), (120, 22.0),
            ]
        case .highRisk:
            data = [
                (0, 5.0), (12, 8.0), (24, 11.0), (36, 13.0),
                (48, 15.0), (60, 16.5), (72, 17.5), (84, 18.0),
                (96, 18.5), (108, 19.0), (120, 19.0),
            ]
        }
        return interpolate(hours: hours, data: data)
    }

    private static func interpolate(hours: Double, data: [(hours: Double, threshold: Double)]) -> Double {
        guard let first = data.first, let last = data.last else { return 0 }
        if hours <= first.hours { return first.threshold }
        if hours >= last.hours { return last.threshold }

        for i in 0..<data.count - 1 {
            let low = data[i]
            let high = data[i + 1]
            if hours >= low.hours && hours <= high.hours {
                let fraction = (hours - low.hours) / (high.hours - low.hours)
                return low.threshold + fraction * (high.threshold - low.threshold)
            }
        }
        return last.threshold
    }
}
