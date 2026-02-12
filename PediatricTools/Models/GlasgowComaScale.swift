import Foundation

enum GCSAgeGroup: String, CaseIterable, Identifiable {
    case infant  // <2 years
    case child   // ≥2 years

    var id: String { rawValue }

    var localizedKey: String {
        switch self {
        case .infant: return "gcs_age_infant"
        case .child: return "gcs_age_child"
        }
    }
}

struct GCSCriterion: Identifiable {
    let id: String
    let nameKey: String
    let minScore: Int
    let maxScore: Int
    let descriptions: [Int: String]
}

enum GCSCriteria {
    static let eye = GCSCriterion(
        id: "eye",
        nameKey: "gcs_eye",
        minScore: 1,
        maxScore: 4,
        descriptions: [
            1: "gcs_eye_1",
            2: "gcs_eye_2",
            3: "gcs_eye_3",
            4: "gcs_eye_4",
        ]
    )

    static let verbalChild = GCSCriterion(
        id: "verbal",
        nameKey: "gcs_verbal",
        minScore: 1,
        maxScore: 5,
        descriptions: [
            1: "gcs_verbal_child_1",
            2: "gcs_verbal_child_2",
            3: "gcs_verbal_child_3",
            4: "gcs_verbal_child_4",
            5: "gcs_verbal_child_5",
        ]
    )

    static let verbalInfant = GCSCriterion(
        id: "verbal",
        nameKey: "gcs_verbal",
        minScore: 1,
        maxScore: 5,
        descriptions: [
            1: "gcs_verbal_infant_1",
            2: "gcs_verbal_infant_2",
            3: "gcs_verbal_infant_3",
            4: "gcs_verbal_infant_4",
            5: "gcs_verbal_infant_5",
        ]
    )

    static let motor = GCSCriterion(
        id: "motor",
        nameKey: "gcs_motor",
        minScore: 1,
        maxScore: 6,
        descriptions: [
            1: "gcs_motor_1",
            2: "gcs_motor_2",
            3: "gcs_motor_3",
            4: "gcs_motor_4",
            5: "gcs_motor_5",
            6: "gcs_motor_6",
        ]
    )

    static func criteria(for ageGroup: GCSAgeGroup) -> [GCSCriterion] {
        let verbal = ageGroup == .infant ? verbalInfant : verbalChild
        return [eye, verbal, motor]
    }
}

enum GCSCalculator {
    /// Interprets total GCS score (3–15).
    static func interpretation(score: Int) -> String {
        switch score {
        case 13...15: return "gcs_mild"
        case 9...12: return "gcs_moderate"
        default: return "gcs_severe"
        }
    }
}
