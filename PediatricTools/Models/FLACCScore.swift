import Foundation

struct FLACCCriterion: Identifiable {
    let id: String
    let nameKey: String
    let descriptions: [Int: String] // score (0-2) → localization key
}

enum FLACCCriteria {
    static let face = FLACCCriterion(
        id: "face",
        nameKey: "flacc_face",
        descriptions: [
            0: "flacc_face_0",
            1: "flacc_face_1",
            2: "flacc_face_2",
        ]
    )

    static let legs = FLACCCriterion(
        id: "legs",
        nameKey: "flacc_legs",
        descriptions: [
            0: "flacc_legs_0",
            1: "flacc_legs_1",
            2: "flacc_legs_2",
        ]
    )

    static let activity = FLACCCriterion(
        id: "activity",
        nameKey: "flacc_activity",
        descriptions: [
            0: "flacc_activity_0",
            1: "flacc_activity_1",
            2: "flacc_activity_2",
        ]
    )

    static let cry = FLACCCriterion(
        id: "cry",
        nameKey: "flacc_cry",
        descriptions: [
            0: "flacc_cry_0",
            1: "flacc_cry_1",
            2: "flacc_cry_2",
        ]
    )

    static let consolability = FLACCCriterion(
        id: "consolability",
        nameKey: "flacc_consolability",
        descriptions: [
            0: "flacc_consolability_0",
            1: "flacc_consolability_1",
            2: "flacc_consolability_2",
        ]
    )

    static let all: [FLACCCriterion] = [
        face, legs, activity, cry, consolability,
    ]
}

enum FLACCCalculator {
    /// Interprets total FLACC score (0–10).
    static func interpretation(score: Int) -> String {
        switch score {
        case 0: return "flacc_relaxed"
        case 1...3: return "flacc_mild"
        case 4...6: return "flacc_moderate"
        default: return "flacc_severe"
        }
    }
}
