import Foundation

// MARK: - LMS Data Point

struct LMSDataPoint {
    let ageMonths: Double
    let L: Double
    let M: Double
    let S: Double
}

enum GrowthMeasurement: String, CaseIterable, Identifiable {
    case weightForAge
    case lengthForAge

    var id: String { rawValue }

    var nameKey: String {
        switch self {
        case .weightForAge: return "growth_weight_for_age"
        case .lengthForAge: return "growth_length_for_age"
        }
    }

    var unitKey: String {
        switch self {
        case .weightForAge: return "unit_kg"
        case .lengthForAge: return "unit_cm"
        }
    }
}

// MARK: - Calculator

enum GrowthPercentileCalculator {
    /// Computes Z-score from LMS parameters.
    /// Z = ((value/M)^L − 1) / (L × S)  when L ≠ 0
    /// Z = ln(value/M) / S               when L = 0
    static func zScore(value: Double, L: Double, M: Double, S: Double) -> Double {
        guard value > 0, M > 0, S > 0 else { return 0 }
        if abs(L) < 0.001 {
            return log(value / M) / S
        }
        return (pow(value / M, L) - 1) / (L * S)
    }

    /// Converts Z-score to percentile using the standard normal CDF approximation.
    static func percentile(zScore z: Double) -> Double {
        // Abramowitz & Stegun approximation of the cumulative normal distribution
        let a1 = 0.254829592
        let a2 = -0.284496736
        let a3 = 1.421413741
        let a4 = -1.453152027
        let a5 = 1.061405429
        let p = 0.3275911

        let sign: Double = z < 0 ? -1.0 : 1.0
        let x = abs(z) / sqrt(2.0)
        let t = 1.0 / (1.0 + p * x)
        let y = 1.0 - (((((a5 * t + a4) * t) + a3) * t + a2) * t + a1) * t * exp(-x * x)

        return max(0.1, min(99.9, (0.5 * (1.0 + sign * y)) * 100.0))
    }

    /// Finds the LMS parameters for a given age by linear interpolation.
    static func interpolateLMS(ageMonths: Double, data: [LMSDataPoint]) -> (L: Double, M: Double, S: Double)? {
        guard !data.isEmpty else { return nil }
        guard ageMonths >= data.first!.ageMonths else {
            let d = data.first!
            return (d.L, d.M, d.S)
        }
        guard ageMonths <= data.last!.ageMonths else {
            let d = data.last!
            return (d.L, d.M, d.S)
        }

        for i in 0..<(data.count - 1) {
            if ageMonths >= data[i].ageMonths && ageMonths <= data[i + 1].ageMonths {
                let fraction = (ageMonths - data[i].ageMonths) / (data[i + 1].ageMonths - data[i].ageMonths)
                let L = data[i].L + fraction * (data[i + 1].L - data[i].L)
                let M = data[i].M + fraction * (data[i + 1].M - data[i].M)
                let S = data[i].S + fraction * (data[i + 1].S - data[i].S)
                return (L, M, S)
            }
        }
        return nil
    }

    static func calculate(
        sex: Sex,
        measurement: GrowthMeasurement,
        ageMonths: Double,
        value: Double
    ) -> (zScore: Double, percentile: Double)? {
        let data: [LMSDataPoint]
        switch (sex, measurement) {
        case (.male, .weightForAge): data = WHOData.weightForAgeBoys
        case (.female, .weightForAge): data = WHOData.weightForAgeGirls
        case (.male, .lengthForAge): data = WHOData.lengthForAgeBoys
        case (.female, .lengthForAge): data = WHOData.lengthForAgeGirls
        }

        guard let lms = interpolateLMS(ageMonths: ageMonths, data: data) else { return nil }
        let z = zScore(value: value, L: lms.L, M: lms.M, S: lms.S)
        let p = percentile(zScore: z)
        return (z, p)
    }
}

// MARK: - WHO Child Growth Standards (0–24 months)

enum WHOData {
    // Weight-for-age Boys (kg), 0–24 months
    static let weightForAgeBoys: [LMSDataPoint] = [
        LMSDataPoint(ageMonths: 0, L: 0.3487, M: 3.3464, S: 0.14602),
        LMSDataPoint(ageMonths: 1, L: 0.2297, M: 4.4709, S: 0.13395),
        LMSDataPoint(ageMonths: 2, L: 0.1970, M: 5.5675, S: 0.12385),
        LMSDataPoint(ageMonths: 3, L: 0.1738, M: 6.3762, S: 0.11727),
        LMSDataPoint(ageMonths: 4, L: 0.1553, M: 7.0023, S: 0.11316),
        LMSDataPoint(ageMonths: 5, L: 0.1395, M: 7.5105, S: 0.11080),
        LMSDataPoint(ageMonths: 6, L: 0.1257, M: 7.9340, S: 0.10958),
        LMSDataPoint(ageMonths: 7, L: 0.1134, M: 8.2970, S: 0.10902),
        LMSDataPoint(ageMonths: 8, L: 0.1021, M: 8.6151, S: 0.10882),
        LMSDataPoint(ageMonths: 9, L: 0.0917, M: 8.9014, S: 0.10881),
        LMSDataPoint(ageMonths: 10, L: 0.0822, M: 9.1649, S: 0.10891),
        LMSDataPoint(ageMonths: 11, L: 0.0736, M: 9.4122, S: 0.10906),
        LMSDataPoint(ageMonths: 12, L: 0.0657, M: 9.6479, S: 0.10925),
        LMSDataPoint(ageMonths: 15, L: 0.0450, M: 10.3002, S: 0.10983),
        LMSDataPoint(ageMonths: 18, L: 0.0293, M: 10.9000, S: 0.11041),
        LMSDataPoint(ageMonths: 21, L: 0.0175, M: 11.4746, S: 0.11099),
        LMSDataPoint(ageMonths: 24, L: 0.0088, M: 12.0435, S: 0.11157),
    ]

    // Weight-for-age Girls (kg), 0–24 months
    static let weightForAgeGirls: [LMSDataPoint] = [
        LMSDataPoint(ageMonths: 0, L: 0.3809, M: 3.2322, S: 0.14171),
        LMSDataPoint(ageMonths: 1, L: 0.1714, M: 4.1873, S: 0.13724),
        LMSDataPoint(ageMonths: 2, L: 0.0962, M: 5.1282, S: 0.13000),
        LMSDataPoint(ageMonths: 3, L: 0.0402, M: 5.8458, S: 0.12619),
        LMSDataPoint(ageMonths: 4, L: -0.0050, M: 6.4237, S: 0.12402),
        LMSDataPoint(ageMonths: 5, L: -0.0430, M: 6.8985, S: 0.12274),
        LMSDataPoint(ageMonths: 6, L: -0.0756, M: 7.2970, S: 0.12204),
        LMSDataPoint(ageMonths: 7, L: -0.1039, M: 7.6422, S: 0.12172),
        LMSDataPoint(ageMonths: 8, L: -0.1288, M: 7.9487, S: 0.12162),
        LMSDataPoint(ageMonths: 9, L: -0.1507, M: 8.2254, S: 0.12166),
        LMSDataPoint(ageMonths: 10, L: -0.1700, M: 8.4800, S: 0.12179),
        LMSDataPoint(ageMonths: 11, L: -0.1872, M: 8.7192, S: 0.12199),
        LMSDataPoint(ageMonths: 12, L: -0.2024, M: 8.9481, S: 0.12223),
        LMSDataPoint(ageMonths: 15, L: -0.2372, M: 9.5722, S: 0.12296),
        LMSDataPoint(ageMonths: 18, L: -0.2630, M: 10.1541, S: 0.12378),
        LMSDataPoint(ageMonths: 21, L: -0.2824, M: 10.7138, S: 0.12467),
        LMSDataPoint(ageMonths: 24, L: -0.2971, M: 11.2759, S: 0.12561),
    ]

    // Length-for-age Boys (cm), 0–24 months
    static let lengthForAgeBoys: [LMSDataPoint] = [
        LMSDataPoint(ageMonths: 0, L: 1, M: 49.8842, S: 0.03795),
        LMSDataPoint(ageMonths: 1, L: 1, M: 54.7244, S: 0.03557),
        LMSDataPoint(ageMonths: 2, L: 1, M: 58.4249, S: 0.03424),
        LMSDataPoint(ageMonths: 3, L: 1, M: 61.4292, S: 0.03328),
        LMSDataPoint(ageMonths: 4, L: 1, M: 63.8860, S: 0.03257),
        LMSDataPoint(ageMonths: 5, L: 1, M: 65.9026, S: 0.03204),
        LMSDataPoint(ageMonths: 6, L: 1, M: 67.6236, S: 0.03165),
        LMSDataPoint(ageMonths: 7, L: 1, M: 69.1645, S: 0.03139),
        LMSDataPoint(ageMonths: 8, L: 1, M: 70.5994, S: 0.03124),
        LMSDataPoint(ageMonths: 9, L: 1, M: 71.9687, S: 0.03117),
        LMSDataPoint(ageMonths: 10, L: 1, M: 73.2812, S: 0.03118),
        LMSDataPoint(ageMonths: 11, L: 1, M: 74.5388, S: 0.03126),
        LMSDataPoint(ageMonths: 12, L: 1, M: 75.7488, S: 0.03138),
        LMSDataPoint(ageMonths: 15, L: 1, M: 79.1942, S: 0.03192),
        LMSDataPoint(ageMonths: 18, L: 1, M: 82.2468, S: 0.03262),
        LMSDataPoint(ageMonths: 21, L: 1, M: 85.0748, S: 0.03337),
        LMSDataPoint(ageMonths: 24, L: 1, M: 87.8161, S: 0.03411),
    ]

    // Length-for-age Girls (cm), 0–24 months
    static let lengthForAgeGirls: [LMSDataPoint] = [
        LMSDataPoint(ageMonths: 0, L: 1, M: 49.1477, S: 0.03790),
        LMSDataPoint(ageMonths: 1, L: 1, M: 53.6872, S: 0.03561),
        LMSDataPoint(ageMonths: 2, L: 1, M: 57.0673, S: 0.03514),
        LMSDataPoint(ageMonths: 3, L: 1, M: 59.8029, S: 0.03441),
        LMSDataPoint(ageMonths: 4, L: 1, M: 62.0899, S: 0.03386),
        LMSDataPoint(ageMonths: 5, L: 1, M: 64.0301, S: 0.03347),
        LMSDataPoint(ageMonths: 6, L: 1, M: 65.7311, S: 0.03319),
        LMSDataPoint(ageMonths: 7, L: 1, M: 67.2873, S: 0.03303),
        LMSDataPoint(ageMonths: 8, L: 1, M: 68.7498, S: 0.03296),
        LMSDataPoint(ageMonths: 9, L: 1, M: 70.1435, S: 0.03298),
        LMSDataPoint(ageMonths: 10, L: 1, M: 71.4818, S: 0.03306),
        LMSDataPoint(ageMonths: 11, L: 1, M: 72.7710, S: 0.03320),
        LMSDataPoint(ageMonths: 12, L: 1, M: 74.0153, S: 0.03339),
        LMSDataPoint(ageMonths: 15, L: 1, M: 77.5049, S: 0.03407),
        LMSDataPoint(ageMonths: 18, L: 1, M: 80.7128, S: 0.03490),
        LMSDataPoint(ageMonths: 21, L: 1, M: 83.6593, S: 0.03579),
        LMSDataPoint(ageMonths: 24, L: 1, M: 86.4000, S: 0.03668),
    ]
}
