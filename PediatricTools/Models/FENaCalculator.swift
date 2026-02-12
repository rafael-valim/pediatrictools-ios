import Foundation

enum FENaCalculator {
    struct Result {
        let fena: Double
        let interpretationKey: String
    }

    /// Fractional Excretion of Sodium (%)
    /// FENa = (UNa × PCr) / (PNa × UCr) × 100
    /// - UNa: Urine sodium (mEq/L)
    /// - PNa: Plasma sodium (mEq/L)
    /// - UCr: Urine creatinine (mg/dL)
    /// - PCr: Plasma creatinine (mg/dL)
    static func calculate(
        urineSodium: Double,
        plasmaSodium: Double,
        urineCreatinine: Double,
        plasmaCreatinine: Double
    ) -> Result? {
        guard plasmaSodium > 0, urineCreatinine > 0 else { return nil }
        let fena = (urineSodium * plasmaCreatinine) / (plasmaSodium * urineCreatinine) * 100.0

        let interpretation: String
        // In neonates, thresholds differ (FENa <2.5% prerenal), but we use standard pediatric values
        if fena < 1.0 {
            interpretation = "fena_prerenal"
        } else if fena <= 2.0 {
            interpretation = "fena_indeterminate"
        } else {
            interpretation = "fena_intrinsic"
        }

        return Result(fena: fena, interpretationKey: interpretation)
    }
}
