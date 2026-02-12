import Foundation

enum CorrectedAgeCalculator {
    struct Result {
        let correctedAgeWeeks: Int
        let correctedAgeDays: Int
        let chronologicalAgeWeeks: Int
        let chronologicalAgeDays: Int
        let prematurityWeeks: Int
    }

    /// Calculates corrected age for premature infants.
    /// Corrected age = Chronological age − (40 weeks − Gestational age at birth)
    /// Only clinically relevant up to 2-3 years for most assessments.
    static func calculate(
        birthDate: Date,
        currentDate: Date,
        gestationalAgeWeeks: Int,
        gestationalAgeDays: Int = 0
    ) -> Result {
        let calendar = Calendar.current
        let chronoDays = calendar.dateComponents([.day], from: birthDate, to: currentDate).day ?? 0
        let chronoWeeks = chronoDays / 7
        let chronoRemainderDays = chronoDays % 7

        let fullTermDays = 40 * 7
        let gaDays = gestationalAgeWeeks * 7 + gestationalAgeDays
        let prematurityDays = max(0, fullTermDays - gaDays)
        let prematurityWeeks = prematurityDays / 7

        let correctedDays = max(0, chronoDays - prematurityDays)
        let correctedWeeks = correctedDays / 7
        let correctedRemainderDays = correctedDays % 7

        return Result(
            correctedAgeWeeks: correctedWeeks,
            correctedAgeDays: correctedRemainderDays,
            chronologicalAgeWeeks: chronoWeeks,
            chronologicalAgeDays: chronoRemainderDays,
            prematurityWeeks: prematurityWeeks
        )
    }
}
