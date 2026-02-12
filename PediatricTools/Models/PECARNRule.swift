import Foundation

enum PECARNAgeGroup: String, CaseIterable, Identifiable {
    case underTwo  // <2 years
    case twoAndOver // ≥2 years

    var id: String { rawValue }

    var localizedKey: String {
        switch self {
        case .underTwo: return "pecarn_age_under2"
        case .twoAndOver: return "pecarn_age_2plus"
        }
    }
}

enum PECARNRisk: String {
    case veryLow
    case intermediate
    case higher

    var localizedKey: String {
        switch self {
        case .veryLow: return "pecarn_very_low"
        case .intermediate: return "pecarn_intermediate"
        case .higher: return "pecarn_higher"
        }
    }

    var recommendationKey: String {
        switch self {
        case .veryLow: return "pecarn_rec_very_low"
        case .intermediate: return "pecarn_rec_intermediate"
        case .higher: return "pecarn_rec_higher"
        }
    }
}

struct PECARNCriterion: Identifiable {
    let id: String
    let nameKey: String
    let detailKey: String?
}

enum PECARNCriteria {
    // <2 years criteria
    static let alteredMentalStatusUnder2 = PECARNCriterion(
        id: "ams_under2", nameKey: "pecarn_ams", detailKey: "pecarn_ams_detail"
    )
    static let palpableSkullFracture = PECARNCriterion(
        id: "skull_fracture", nameKey: "pecarn_skull_fracture", detailKey: nil
    )
    static let locUnder2 = PECARNCriterion(
        id: "loc_under2", nameKey: "pecarn_loc_5s", detailKey: nil
    )
    static let severeMechanismUnder2 = PECARNCriterion(
        id: "mechanism_under2", nameKey: "pecarn_severe_mechanism", detailKey: "pecarn_mechanism_detail"
    )
    static let occipitalHematoma = PECARNCriterion(
        id: "hematoma", nameKey: "pecarn_hematoma", detailKey: nil
    )
    static let notActingNormally = PECARNCriterion(
        id: "not_normal", nameKey: "pecarn_not_normal", detailKey: nil
    )

    // ≥2 years criteria
    static let alteredMentalStatusOver2 = PECARNCriterion(
        id: "ams_over2", nameKey: "pecarn_ams", detailKey: "pecarn_ams_detail"
    )
    static let basilarSkullFracture = PECARNCriterion(
        id: "basilar_fracture", nameKey: "pecarn_basilar_fracture", detailKey: "pecarn_basilar_detail"
    )
    static let locOver2 = PECARNCriterion(
        id: "loc_over2", nameKey: "pecarn_loc", detailKey: nil
    )
    static let severeMechanismOver2 = PECARNCriterion(
        id: "mechanism_over2", nameKey: "pecarn_severe_mechanism", detailKey: "pecarn_mechanism_detail"
    )
    static let vomiting = PECARNCriterion(
        id: "vomiting", nameKey: "pecarn_vomiting", detailKey: nil
    )
    static let severeHeadache = PECARNCriterion(
        id: "headache", nameKey: "pecarn_headache", detailKey: nil
    )

    static func criteria(for ageGroup: PECARNAgeGroup) -> [PECARNCriterion] {
        switch ageGroup {
        case .underTwo:
            return [alteredMentalStatusUnder2, palpableSkullFracture, locUnder2,
                    severeMechanismUnder2, occipitalHematoma, notActingNormally]
        case .twoAndOver:
            return [alteredMentalStatusOver2, basilarSkullFracture, locOver2,
                    severeMechanismOver2, vomiting, severeHeadache]
        }
    }
}

enum PECARNCalculator {
    /// Evaluates PECARN risk based on age group and positive criteria.
    /// Higher-risk criteria (first 2 in each group) indicate higher risk.
    /// Intermediate criteria (last 4) indicate intermediate risk when isolated.
    static func evaluate(ageGroup: PECARNAgeGroup, positiveCriteria: Set<String>) -> PECARNRisk {
        let criteria = PECARNCriteria.criteria(for: ageGroup)
        guard criteria.count >= 2 else { return .veryLow }

        let highRiskIDs: Set<String>
        switch ageGroup {
        case .underTwo:
            highRiskIDs = ["ams_under2", "skull_fracture"]
        case .twoAndOver:
            highRiskIDs = ["ams_over2", "basilar_fracture"]
        }

        let hasHighRisk = !positiveCriteria.isDisjoint(with: highRiskIDs)
        if hasHighRisk {
            return .higher
        }

        let intermediateIDs = Set(criteria.map(\.id)).subtracting(highRiskIDs)
        let hasIntermediate = !positiveCriteria.isDisjoint(with: intermediateIDs)
        if hasIntermediate {
            return .intermediate
        }

        return .veryLow
    }
}
