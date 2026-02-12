import Foundation

enum SchwartzGFR {
    struct Result {
        let eGFR: Double
        let interpretationKey: String
    }

    /// Bedside Schwartz equation (2009 revision):
    /// eGFR (mL/min/1.73m²) = 0.413 × (height in cm / serum creatinine in mg/dL)
    static func calculate(heightCm: Double, serumCreatinine: Double) -> Result? {
        guard heightCm > 0, serumCreatinine > 0 else { return nil }
        let eGFR = 0.413 * (heightCm / serumCreatinine)

        let interpretation: String
        switch eGFR {
        case 90...: interpretation = "gfr_normal"
        case 60..<90: interpretation = "gfr_mild"
        case 30..<60: interpretation = "gfr_moderate"
        case 15..<30: interpretation = "gfr_severe"
        default: interpretation = "gfr_kidney_failure"
        }

        return Result(eGFR: eGFR, interpretationKey: interpretation)
    }
}
