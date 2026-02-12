import Foundation

enum BPClassification: String {
    case normal
    case elevated
    case stageOneHTN
    case stageTwoHTN

    var localizedKey: String {
        switch self {
        case .normal: return "bp_normal"
        case .elevated: return "bp_elevated"
        case .stageOneHTN: return "bp_stage1"
        case .stageTwoHTN: return "bp_stage2"
        }
    }
}

enum HeightPercentileCategory: Int, CaseIterable, Identifiable {
    case p5 = 5
    case p10 = 10
    case p25 = 25
    case p50 = 50
    case p75 = 75
    case p90 = 90
    case p95 = 95

    var id: Int { rawValue }

    var localizedKey: String {
        return "bp_height_p\(rawValue)"
    }
}

enum BPPercentileCalculator {
    struct Result {
        let systolicPercentile: Double
        let diastolicPercentile: Double
        let classification: BPClassification
    }

    /// Calculates BP percentile using AAP 2017 simplified screening tables.
    /// Uses mean and standard deviation by age/sex to compute Z-score, then percentile.
    static func calculate(
        systolic: Double,
        diastolic: Double,
        ageYears: Int,
        sex: Sex,
        heightPercentile: HeightPercentileCategory
    ) -> Result? {
        guard ageYears >= 1, ageYears <= 17, systolic > 0, diastolic > 0 else { return nil }

        let params = referenceData(age: ageYears, sex: sex, heightPercentile: heightPercentile)

        let sysZ = (systolic - params.sysMean) / params.sysSD
        let diaZ = (diastolic - params.diaMean) / params.diaSD

        let sysPercentile = zToPercentile(sysZ)
        let diaPercentile = zToPercentile(diaZ)

        let p90Sys = params.sysMean + 1.282 * params.sysSD
        let p95Sys = params.sysMean + 1.645 * params.sysSD
        let p90Dia = params.diaMean + 1.282 * params.diaSD
        let p95Dia = params.diaMean + 1.645 * params.diaSD

        let classification: BPClassification
        if systolic >= p95Sys + 12 || diastolic >= p95Dia + 12 {
            classification = .stageTwoHTN
        } else if systolic >= p95Sys || diastolic >= p95Dia {
            classification = .stageOneHTN
        } else if systolic >= p90Sys || diastolic >= p90Dia {
            classification = .elevated
        } else {
            classification = .normal
        }

        return Result(
            systolicPercentile: sysPercentile,
            diastolicPercentile: diaPercentile,
            classification: classification
        )
    }

    /// Converts Z-score to percentile using Abramowitz & Stegun approximation.
    private static func zToPercentile(_ z: Double) -> Double {
        let p = 0.3275911
        let a1 = 0.254829592
        let a2 = -0.284496736
        let a3 = 1.421413741
        let a4 = -1.453152027
        let a5 = 1.061405429

        let sign: Double = z < 0 ? -1.0 : 1.0
        let x = abs(z) / sqrt(2.0)
        let t = 1.0 / (1.0 + p * x)
        let y = 1.0 - (((((a5 * t + a4) * t) + a3) * t + a2) * t + a1) * t * exp(-x * x)
        return max(0.1, min(99.9, (0.5 * (1.0 + sign * y)) * 100.0))
    }

    // MARK: - AAP 2017 Reference Data

    struct BPParams {
        let sysMean: Double
        let sysSD: Double
        let diaMean: Double
        let diaSD: Double
    }

    /// Returns mean and SD for systolic/diastolic BP by age, sex, and height percentile.
    /// Based on AAP 2017 Clinical Practice Guideline normative tables.
    /// Data interpolated for the 50th height percentile reference values.
    private static func referenceData(age: Int, sex: Sex, heightPercentile: HeightPercentileCategory) -> BPParams {
        let heightIdx = heightIndex(heightPercentile)
        let table = sex == .male ? maleData : femaleData
        let ageIdx = max(0, min(age - 1, table.count - 1))
        let row = table[ageIdx]
        return row[heightIdx]
    }

    private static func heightIndex(_ hp: HeightPercentileCategory) -> Int {
        switch hp {
        case .p5: return 0
        case .p10: return 1
        case .p25: return 2
        case .p50: return 3
        case .p75: return 4
        case .p90: return 5
        case .p95: return 6
        }
    }

    // AAP 2017 normative tables: [age 1-17][height percentile 5,10,25,50,75,90,95]
    // Each entry: (sysMean, sysSD, diaMean, diaSD)
    // Males, ages 1-17
    private static let maleData: [[BPParams]] = [
        // Age 1
        [BPParams(sysMean: 84, sysSD: 7, diaMean: 39, diaSD: 6), BPParams(sysMean: 85, sysSD: 7, diaMean: 40, diaSD: 6), BPParams(sysMean: 86, sysSD: 7, diaMean: 41, diaSD: 6), BPParams(sysMean: 87, sysSD: 7, diaMean: 42, diaSD: 6), BPParams(sysMean: 88, sysSD: 7, diaMean: 42, diaSD: 6), BPParams(sysMean: 89, sysSD: 7, diaMean: 43, diaSD: 6), BPParams(sysMean: 90, sysSD: 7, diaMean: 43, diaSD: 6)],
        // Age 2
        [BPParams(sysMean: 87, sysSD: 7, diaMean: 43, diaSD: 6), BPParams(sysMean: 88, sysSD: 7, diaMean: 44, diaSD: 6), BPParams(sysMean: 89, sysSD: 7, diaMean: 45, diaSD: 6), BPParams(sysMean: 91, sysSD: 7, diaMean: 46, diaSD: 6), BPParams(sysMean: 92, sysSD: 7, diaMean: 47, diaSD: 6), BPParams(sysMean: 93, sysSD: 7, diaMean: 47, diaSD: 6), BPParams(sysMean: 93, sysSD: 7, diaMean: 48, diaSD: 6)],
        // Age 3
        [BPParams(sysMean: 88, sysSD: 7, diaMean: 46, diaSD: 6), BPParams(sysMean: 89, sysSD: 7, diaMean: 47, diaSD: 6), BPParams(sysMean: 91, sysSD: 7, diaMean: 48, diaSD: 6), BPParams(sysMean: 92, sysSD: 7, diaMean: 49, diaSD: 6), BPParams(sysMean: 93, sysSD: 7, diaMean: 49, diaSD: 6), BPParams(sysMean: 94, sysSD: 7, diaMean: 50, diaSD: 6), BPParams(sysMean: 95, sysSD: 7, diaMean: 50, diaSD: 6)],
        // Age 4
        [BPParams(sysMean: 90, sysSD: 7, diaMean: 49, diaSD: 5), BPParams(sysMean: 91, sysSD: 7, diaMean: 50, diaSD: 5), BPParams(sysMean: 92, sysSD: 7, diaMean: 51, diaSD: 5), BPParams(sysMean: 93, sysSD: 7, diaMean: 52, diaSD: 5), BPParams(sysMean: 95, sysSD: 7, diaMean: 52, diaSD: 5), BPParams(sysMean: 96, sysSD: 7, diaMean: 53, diaSD: 5), BPParams(sysMean: 96, sysSD: 7, diaMean: 53, diaSD: 5)],
        // Age 5
        [BPParams(sysMean: 91, sysSD: 7, diaMean: 52, diaSD: 5), BPParams(sysMean: 92, sysSD: 7, diaMean: 52, diaSD: 5), BPParams(sysMean: 93, sysSD: 7, diaMean: 53, diaSD: 5), BPParams(sysMean: 95, sysSD: 7, diaMean: 54, diaSD: 5), BPParams(sysMean: 96, sysSD: 7, diaMean: 55, diaSD: 5), BPParams(sysMean: 97, sysSD: 7, diaMean: 55, diaSD: 5), BPParams(sysMean: 98, sysSD: 7, diaMean: 56, diaSD: 5)],
        // Age 6
        [BPParams(sysMean: 92, sysSD: 7, diaMean: 54, diaSD: 5), BPParams(sysMean: 93, sysSD: 7, diaMean: 55, diaSD: 5), BPParams(sysMean: 94, sysSD: 7, diaMean: 56, diaSD: 5), BPParams(sysMean: 96, sysSD: 7, diaMean: 56, diaSD: 5), BPParams(sysMean: 97, sysSD: 7, diaMean: 57, diaSD: 5), BPParams(sysMean: 98, sysSD: 7, diaMean: 58, diaSD: 5), BPParams(sysMean: 99, sysSD: 7, diaMean: 58, diaSD: 5)],
        // Age 7
        [BPParams(sysMean: 93, sysSD: 7, diaMean: 56, diaSD: 5), BPParams(sysMean: 94, sysSD: 7, diaMean: 57, diaSD: 5), BPParams(sysMean: 95, sysSD: 7, diaMean: 57, diaSD: 5), BPParams(sysMean: 97, sysSD: 7, diaMean: 58, diaSD: 5), BPParams(sysMean: 98, sysSD: 7, diaMean: 59, diaSD: 5), BPParams(sysMean: 100, sysSD: 7, diaMean: 59, diaSD: 5), BPParams(sysMean: 100, sysSD: 7, diaMean: 60, diaSD: 5)],
        // Age 8
        [BPParams(sysMean: 94, sysSD: 7, diaMean: 57, diaSD: 5), BPParams(sysMean: 95, sysSD: 7, diaMean: 58, diaSD: 5), BPParams(sysMean: 97, sysSD: 7, diaMean: 59, diaSD: 5), BPParams(sysMean: 98, sysSD: 7, diaMean: 59, diaSD: 5), BPParams(sysMean: 100, sysSD: 7, diaMean: 60, diaSD: 5), BPParams(sysMean: 101, sysSD: 7, diaMean: 61, diaSD: 5), BPParams(sysMean: 101, sysSD: 7, diaMean: 61, diaSD: 5)],
        // Age 9
        [BPParams(sysMean: 95, sysSD: 8, diaMean: 58, diaSD: 5), BPParams(sysMean: 96, sysSD: 8, diaMean: 59, diaSD: 5), BPParams(sysMean: 98, sysSD: 8, diaMean: 60, diaSD: 5), BPParams(sysMean: 99, sysSD: 8, diaMean: 60, diaSD: 5), BPParams(sysMean: 101, sysSD: 8, diaMean: 61, diaSD: 5), BPParams(sysMean: 102, sysSD: 8, diaMean: 62, diaSD: 5), BPParams(sysMean: 103, sysSD: 8, diaMean: 62, diaSD: 5)],
        // Age 10
        [BPParams(sysMean: 97, sysSD: 8, diaMean: 59, diaSD: 5), BPParams(sysMean: 97, sysSD: 8, diaMean: 60, diaSD: 5), BPParams(sysMean: 99, sysSD: 8, diaMean: 61, diaSD: 5), BPParams(sysMean: 101, sysSD: 8, diaMean: 61, diaSD: 5), BPParams(sysMean: 102, sysSD: 8, diaMean: 62, diaSD: 5), BPParams(sysMean: 103, sysSD: 8, diaMean: 63, diaSD: 5), BPParams(sysMean: 104, sysSD: 8, diaMean: 63, diaSD: 5)],
        // Age 11
        [BPParams(sysMean: 99, sysSD: 8, diaMean: 60, diaSD: 5), BPParams(sysMean: 99, sysSD: 8, diaMean: 61, diaSD: 5), BPParams(sysMean: 101, sysSD: 8, diaMean: 61, diaSD: 5), BPParams(sysMean: 103, sysSD: 8, diaMean: 62, diaSD: 5), BPParams(sysMean: 104, sysSD: 8, diaMean: 63, diaSD: 5), BPParams(sysMean: 105, sysSD: 8, diaMean: 63, diaSD: 5), BPParams(sysMean: 106, sysSD: 8, diaMean: 64, diaSD: 5)],
        // Age 12
        [BPParams(sysMean: 101, sysSD: 8, diaMean: 61, diaSD: 5), BPParams(sysMean: 102, sysSD: 8, diaMean: 61, diaSD: 5), BPParams(sysMean: 103, sysSD: 8, diaMean: 62, diaSD: 5), BPParams(sysMean: 105, sysSD: 8, diaMean: 63, diaSD: 5), BPParams(sysMean: 106, sysSD: 8, diaMean: 63, diaSD: 5), BPParams(sysMean: 108, sysSD: 8, diaMean: 64, diaSD: 5), BPParams(sysMean: 108, sysSD: 8, diaMean: 64, diaSD: 5)],
        // Age 13
        [BPParams(sysMean: 104, sysSD: 8, diaMean: 61, diaSD: 5), BPParams(sysMean: 104, sysSD: 8, diaMean: 62, diaSD: 5), BPParams(sysMean: 106, sysSD: 8, diaMean: 62, diaSD: 5), BPParams(sysMean: 107, sysSD: 8, diaMean: 63, diaSD: 5), BPParams(sysMean: 109, sysSD: 8, diaMean: 64, diaSD: 5), BPParams(sysMean: 110, sysSD: 8, diaMean: 64, diaSD: 5), BPParams(sysMean: 111, sysSD: 8, diaMean: 65, diaSD: 5)],
        // Age 14
        [BPParams(sysMean: 106, sysSD: 8, diaMean: 62, diaSD: 5), BPParams(sysMean: 107, sysSD: 8, diaMean: 62, diaSD: 5), BPParams(sysMean: 108, sysSD: 8, diaMean: 63, diaSD: 5), BPParams(sysMean: 110, sysSD: 8, diaMean: 63, diaSD: 5), BPParams(sysMean: 111, sysSD: 8, diaMean: 64, diaSD: 5), BPParams(sysMean: 113, sysSD: 8, diaMean: 65, diaSD: 5), BPParams(sysMean: 113, sysSD: 8, diaMean: 65, diaSD: 5)],
        // Age 15
        [BPParams(sysMean: 109, sysSD: 8, diaMean: 63, diaSD: 5), BPParams(sysMean: 109, sysSD: 8, diaMean: 63, diaSD: 5), BPParams(sysMean: 111, sysSD: 8, diaMean: 63, diaSD: 5), BPParams(sysMean: 112, sysSD: 8, diaMean: 64, diaSD: 5), BPParams(sysMean: 114, sysSD: 8, diaMean: 65, diaSD: 5), BPParams(sysMean: 115, sysSD: 8, diaMean: 65, diaSD: 5), BPParams(sysMean: 116, sysSD: 8, diaMean: 66, diaSD: 5)],
        // Age 16
        [BPParams(sysMean: 111, sysSD: 9, diaMean: 64, diaSD: 5), BPParams(sysMean: 112, sysSD: 9, diaMean: 64, diaSD: 5), BPParams(sysMean: 113, sysSD: 9, diaMean: 64, diaSD: 5), BPParams(sysMean: 114, sysSD: 9, diaMean: 65, diaSD: 5), BPParams(sysMean: 116, sysSD: 9, diaMean: 65, diaSD: 5), BPParams(sysMean: 117, sysSD: 9, diaMean: 66, diaSD: 5), BPParams(sysMean: 118, sysSD: 9, diaMean: 66, diaSD: 5)],
        // Age 17
        [BPParams(sysMean: 114, sysSD: 9, diaMean: 65, diaSD: 5), BPParams(sysMean: 114, sysSD: 9, diaMean: 65, diaSD: 5), BPParams(sysMean: 115, sysSD: 9, diaMean: 65, diaSD: 5), BPParams(sysMean: 117, sysSD: 9, diaMean: 66, diaSD: 5), BPParams(sysMean: 118, sysSD: 9, diaMean: 66, diaSD: 5), BPParams(sysMean: 119, sysSD: 9, diaMean: 67, diaSD: 5), BPParams(sysMean: 120, sysSD: 9, diaMean: 67, diaSD: 5)],
    ]

    // Females, ages 1-17
    private static let femaleData: [[BPParams]] = [
        // Age 1
        [BPParams(sysMean: 84, sysSD: 7, diaMean: 41, diaSD: 6), BPParams(sysMean: 85, sysSD: 7, diaMean: 42, diaSD: 6), BPParams(sysMean: 86, sysSD: 7, diaMean: 42, diaSD: 6), BPParams(sysMean: 87, sysSD: 7, diaMean: 43, diaSD: 6), BPParams(sysMean: 88, sysSD: 7, diaMean: 44, diaSD: 6), BPParams(sysMean: 89, sysSD: 7, diaMean: 44, diaSD: 6), BPParams(sysMean: 89, sysSD: 7, diaMean: 45, diaSD: 6)],
        // Age 2
        [BPParams(sysMean: 87, sysSD: 7, diaMean: 45, diaSD: 6), BPParams(sysMean: 87, sysSD: 7, diaMean: 46, diaSD: 6), BPParams(sysMean: 88, sysSD: 7, diaMean: 46, diaSD: 6), BPParams(sysMean: 90, sysSD: 7, diaMean: 47, diaSD: 6), BPParams(sysMean: 91, sysSD: 7, diaMean: 48, diaSD: 6), BPParams(sysMean: 91, sysSD: 7, diaMean: 49, diaSD: 6), BPParams(sysMean: 92, sysSD: 7, diaMean: 49, diaSD: 6)],
        // Age 3
        [BPParams(sysMean: 88, sysSD: 7, diaMean: 48, diaSD: 5), BPParams(sysMean: 88, sysSD: 7, diaMean: 48, diaSD: 5), BPParams(sysMean: 89, sysSD: 7, diaMean: 49, diaSD: 5), BPParams(sysMean: 91, sysSD: 7, diaMean: 50, diaSD: 5), BPParams(sysMean: 92, sysSD: 7, diaMean: 51, diaSD: 5), BPParams(sysMean: 93, sysSD: 7, diaMean: 51, diaSD: 5), BPParams(sysMean: 93, sysSD: 7, diaMean: 52, diaSD: 5)],
        // Age 4
        [BPParams(sysMean: 89, sysSD: 7, diaMean: 51, diaSD: 5), BPParams(sysMean: 89, sysSD: 7, diaMean: 51, diaSD: 5), BPParams(sysMean: 91, sysSD: 7, diaMean: 52, diaSD: 5), BPParams(sysMean: 92, sysSD: 7, diaMean: 52, diaSD: 5), BPParams(sysMean: 93, sysSD: 7, diaMean: 53, diaSD: 5), BPParams(sysMean: 94, sysSD: 7, diaMean: 54, diaSD: 5), BPParams(sysMean: 95, sysSD: 7, diaMean: 54, diaSD: 5)],
        // Age 5
        [BPParams(sysMean: 90, sysSD: 7, diaMean: 53, diaSD: 5), BPParams(sysMean: 90, sysSD: 7, diaMean: 53, diaSD: 5), BPParams(sysMean: 91, sysSD: 7, diaMean: 54, diaSD: 5), BPParams(sysMean: 93, sysSD: 7, diaMean: 54, diaSD: 5), BPParams(sysMean: 94, sysSD: 7, diaMean: 55, diaSD: 5), BPParams(sysMean: 95, sysSD: 7, diaMean: 56, diaSD: 5), BPParams(sysMean: 96, sysSD: 7, diaMean: 56, diaSD: 5)],
        // Age 6
        [BPParams(sysMean: 91, sysSD: 7, diaMean: 55, diaSD: 5), BPParams(sysMean: 92, sysSD: 7, diaMean: 55, diaSD: 5), BPParams(sysMean: 93, sysSD: 7, diaMean: 55, diaSD: 5), BPParams(sysMean: 94, sysSD: 7, diaMean: 56, diaSD: 5), BPParams(sysMean: 95, sysSD: 7, diaMean: 57, diaSD: 5), BPParams(sysMean: 96, sysSD: 7, diaMean: 57, diaSD: 5), BPParams(sysMean: 97, sysSD: 7, diaMean: 58, diaSD: 5)],
        // Age 7
        [BPParams(sysMean: 92, sysSD: 7, diaMean: 56, diaSD: 5), BPParams(sysMean: 93, sysSD: 7, diaMean: 56, diaSD: 5), BPParams(sysMean: 94, sysSD: 7, diaMean: 57, diaSD: 5), BPParams(sysMean: 95, sysSD: 7, diaMean: 57, diaSD: 5), BPParams(sysMean: 96, sysSD: 7, diaMean: 58, diaSD: 5), BPParams(sysMean: 97, sysSD: 7, diaMean: 59, diaSD: 5), BPParams(sysMean: 98, sysSD: 7, diaMean: 59, diaSD: 5)],
        // Age 8
        [BPParams(sysMean: 93, sysSD: 7, diaMean: 57, diaSD: 5), BPParams(sysMean: 94, sysSD: 7, diaMean: 57, diaSD: 5), BPParams(sysMean: 95, sysSD: 7, diaMean: 58, diaSD: 5), BPParams(sysMean: 96, sysSD: 7, diaMean: 58, diaSD: 5), BPParams(sysMean: 98, sysSD: 7, diaMean: 59, diaSD: 5), BPParams(sysMean: 99, sysSD: 7, diaMean: 60, diaSD: 5), BPParams(sysMean: 99, sysSD: 7, diaMean: 60, diaSD: 5)],
        // Age 9
        [BPParams(sysMean: 95, sysSD: 8, diaMean: 58, diaSD: 5), BPParams(sysMean: 95, sysSD: 8, diaMean: 58, diaSD: 5), BPParams(sysMean: 96, sysSD: 8, diaMean: 59, diaSD: 5), BPParams(sysMean: 98, sysSD: 8, diaMean: 59, diaSD: 5), BPParams(sysMean: 99, sysSD: 8, diaMean: 60, diaSD: 5), BPParams(sysMean: 100, sysSD: 8, diaMean: 61, diaSD: 5), BPParams(sysMean: 101, sysSD: 8, diaMean: 61, diaSD: 5)],
        // Age 10
        [BPParams(sysMean: 96, sysSD: 8, diaMean: 59, diaSD: 5), BPParams(sysMean: 97, sysSD: 8, diaMean: 59, diaSD: 5), BPParams(sysMean: 98, sysSD: 8, diaMean: 60, diaSD: 5), BPParams(sysMean: 99, sysSD: 8, diaMean: 60, diaSD: 5), BPParams(sysMean: 101, sysSD: 8, diaMean: 61, diaSD: 5), BPParams(sysMean: 102, sysSD: 8, diaMean: 62, diaSD: 5), BPParams(sysMean: 103, sysSD: 8, diaMean: 62, diaSD: 5)],
        // Age 11
        [BPParams(sysMean: 98, sysSD: 8, diaMean: 60, diaSD: 5), BPParams(sysMean: 99, sysSD: 8, diaMean: 60, diaSD: 5), BPParams(sysMean: 100, sysSD: 8, diaMean: 60, diaSD: 5), BPParams(sysMean: 101, sysSD: 8, diaMean: 61, diaSD: 5), BPParams(sysMean: 103, sysSD: 8, diaMean: 62, diaSD: 5), BPParams(sysMean: 104, sysSD: 8, diaMean: 62, diaSD: 5), BPParams(sysMean: 104, sysSD: 8, diaMean: 63, diaSD: 5)],
        // Age 12
        [BPParams(sysMean: 100, sysSD: 8, diaMean: 61, diaSD: 5), BPParams(sysMean: 101, sysSD: 8, diaMean: 61, diaSD: 5), BPParams(sysMean: 102, sysSD: 8, diaMean: 61, diaSD: 5), BPParams(sysMean: 103, sysSD: 8, diaMean: 62, diaSD: 5), BPParams(sysMean: 105, sysSD: 8, diaMean: 62, diaSD: 5), BPParams(sysMean: 106, sysSD: 8, diaMean: 63, diaSD: 5), BPParams(sysMean: 106, sysSD: 8, diaMean: 63, diaSD: 5)],
        // Age 13
        [BPParams(sysMean: 102, sysSD: 8, diaMean: 61, diaSD: 5), BPParams(sysMean: 102, sysSD: 8, diaMean: 62, diaSD: 5), BPParams(sysMean: 104, sysSD: 8, diaMean: 62, diaSD: 5), BPParams(sysMean: 105, sysSD: 8, diaMean: 63, diaSD: 5), BPParams(sysMean: 106, sysSD: 8, diaMean: 63, diaSD: 5), BPParams(sysMean: 107, sysSD: 8, diaMean: 64, diaSD: 5), BPParams(sysMean: 108, sysSD: 8, diaMean: 64, diaSD: 5)],
        // Age 14
        [BPParams(sysMean: 103, sysSD: 8, diaMean: 62, diaSD: 5), BPParams(sysMean: 103, sysSD: 8, diaMean: 62, diaSD: 5), BPParams(sysMean: 105, sysSD: 8, diaMean: 63, diaSD: 5), BPParams(sysMean: 106, sysSD: 8, diaMean: 63, diaSD: 5), BPParams(sysMean: 107, sysSD: 8, diaMean: 64, diaSD: 5), BPParams(sysMean: 108, sysSD: 8, diaMean: 64, diaSD: 5), BPParams(sysMean: 109, sysSD: 8, diaMean: 65, diaSD: 5)],
        // Age 15
        [BPParams(sysMean: 103, sysSD: 8, diaMean: 63, diaSD: 5), BPParams(sysMean: 104, sysSD: 8, diaMean: 63, diaSD: 5), BPParams(sysMean: 105, sysSD: 8, diaMean: 63, diaSD: 5), BPParams(sysMean: 107, sysSD: 8, diaMean: 64, diaSD: 5), BPParams(sysMean: 108, sysSD: 8, diaMean: 64, diaSD: 5), BPParams(sysMean: 109, sysSD: 8, diaMean: 65, diaSD: 5), BPParams(sysMean: 109, sysSD: 8, diaMean: 65, diaSD: 5)],
        // Age 16
        [BPParams(sysMean: 104, sysSD: 8, diaMean: 63, diaSD: 5), BPParams(sysMean: 104, sysSD: 8, diaMean: 64, diaSD: 5), BPParams(sysMean: 106, sysSD: 8, diaMean: 64, diaSD: 5), BPParams(sysMean: 107, sysSD: 8, diaMean: 64, diaSD: 5), BPParams(sysMean: 108, sysSD: 8, diaMean: 65, diaSD: 5), BPParams(sysMean: 109, sysSD: 8, diaMean: 66, diaSD: 5), BPParams(sysMean: 110, sysSD: 8, diaMean: 66, diaSD: 5)],
        // Age 17
        [BPParams(sysMean: 104, sysSD: 8, diaMean: 64, diaSD: 5), BPParams(sysMean: 105, sysSD: 8, diaMean: 64, diaSD: 5), BPParams(sysMean: 106, sysSD: 8, diaMean: 64, diaSD: 5), BPParams(sysMean: 107, sysSD: 8, diaMean: 65, diaSD: 5), BPParams(sysMean: 108, sysSD: 8, diaMean: 65, diaSD: 5), BPParams(sysMean: 110, sysSD: 8, diaMean: 66, diaSD: 5), BPParams(sysMean: 110, sysSD: 8, diaMean: 66, diaSD: 5)],
    ]
}
