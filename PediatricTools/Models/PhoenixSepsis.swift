import Foundation

enum PhoenixSepsis {
    struct Result {
        let respiratoryScore: Int
        let cardiovascularScore: Int
        let coagulationScore: Int
        let neurologicScore: Int
        let totalScore: Int
        let isSepsis: Bool
        let isSepticShock: Bool
        let interpretationKey: String
    }

    // MARK: - Respiratory (0-3)

    /// Calculates respiratory subscore based on oxygenation and ventilation.
    /// - Parameters:
    ///   - paoFioRatio: PaO2/FiO2 ratio (optional, use nil if not available)
    ///   - spoFioRatio: SpO2/FiO2 ratio (optional, use nil if PaO2 available)
    ///   - onInvasiveVent: Whether patient is on invasive mechanical ventilation
    static func respiratoryScore(paoFioRatio: Double?, spoFioRatio: Double?, onInvasiveVent: Bool) -> Int {
        let oxygenScore: Int
        if let pf = paoFioRatio {
            if pf < 100 {
                oxygenScore = 2
            } else if pf < 200 {
                oxygenScore = 1
            } else {
                oxygenScore = 0
            }
        } else if let sf = spoFioRatio {
            if sf < 148 {
                oxygenScore = 2
            } else if sf < 220 {
                oxygenScore = 1
            } else {
                oxygenScore = 0
            }
        } else {
            oxygenScore = 0
        }

        let ventScore = onInvasiveVent ? 1 : 0
        return min(3, oxygenScore + ventScore)
    }

    // MARK: - Cardiovascular (0-6)

    /// Calculates cardiovascular subscore.
    /// - Parameters:
    ///   - vasoactiveCount: Number of vasoactive medications (0, 1, or ≥2)
    ///   - lactateMmol: Serum lactate (mmol/L), optional
    ///   - mapForAge: Whether MAP is age-appropriate (false = low MAP for age)
    static func cardiovascularScore(vasoactiveCount: Int, lactateMmol: Double?, mapForAge: Bool) -> Int {
        var score = 0

        // Vasoactive component (0, 1, or 2)
        if vasoactiveCount >= 2 {
            score += 2
        } else if vasoactiveCount == 1 {
            score += 1
        }

        // Lactate component (0, 1, or 2)
        if let lactate = lactateMmol {
            if lactate >= 11.0 {
                score += 2
            } else if lactate >= 5.0 {
                score += 1
            }
        }

        // MAP component (0 or 2)
        if !mapForAge {
            score += 2
        }

        return min(6, score)
    }

    // MARK: - Coagulation (0-2)

    /// Calculates coagulation subscore.
    /// - Parameters:
    ///   - platelets: Platelet count (×10³/µL)
    ///   - inr: INR value
    ///   - dDimer: D-dimer (mg/L FEU), optional
    ///   - fibrinogen: Fibrinogen (mg/dL), optional
    static func coagulationScore(platelets: Double?, inr: Double?, dDimer: Double?, fibrinogen: Double?) -> Int {
        var score = 0

        if let plt = platelets, plt < 100 {
            score += 1
        }

        if let inr = inr, inr > 1.3 {
            score += 1
        }

        if let dd = dDimer, dd > 2.0 {
            score += 1
        }

        if let fib = fibrinogen, fib < 100 {
            score += 1
        }

        return min(2, score)
    }

    // MARK: - Neurologic (0-2)

    /// Calculates neurologic subscore based on GCS.
    static func neurologicScore(gcs: Int) -> Int {
        if gcs <= 10 {
            return 2
        } else if gcs < 15 {
            return 1
        }
        return 0
    }

    // MARK: - Total

    /// Calculates the complete Phoenix Sepsis Score.
    static func calculate(
        respiratoryScore resp: Int,
        cardiovascularScore cardio: Int,
        coagulationScore coag: Int,
        neurologicScore neuro: Int
    ) -> Result {
        let total = resp + cardio + coag + neuro
        let isSepsis = total >= 2
        let isSepticShock = isSepsis && cardio >= 1

        let interpretation: String
        if isSepticShock {
            interpretation = "phoenix_septic_shock"
        } else if isSepsis {
            interpretation = "phoenix_sepsis"
        } else {
            interpretation = "phoenix_no_sepsis"
        }

        return Result(
            respiratoryScore: resp,
            cardiovascularScore: cardio,
            coagulationScore: coag,
            neurologicScore: neuro,
            totalScore: total,
            isSepsis: isSepsis,
            isSepticShock: isSepticShock,
            interpretationKey: interpretation
        )
    }
}
