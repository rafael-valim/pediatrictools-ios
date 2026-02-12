import Foundation

struct ApgarCriterion: Identifiable {
    let id: String
    let nameKey: String
    let descriptions: [Int: String] // score (0-2) → localization key
}

enum ApgarCriteria {
    static let appearance = ApgarCriterion(
        id: "appearance",
        nameKey: "apgar_appearance",
        descriptions: [
            0: "apgar_appearance_0",
            1: "apgar_appearance_1",
            2: "apgar_appearance_2",
        ]
    )

    static let pulse = ApgarCriterion(
        id: "pulse",
        nameKey: "apgar_pulse",
        descriptions: [
            0: "apgar_pulse_0",
            1: "apgar_pulse_1",
            2: "apgar_pulse_2",
        ]
    )

    static let grimace = ApgarCriterion(
        id: "grimace",
        nameKey: "apgar_grimace",
        descriptions: [
            0: "apgar_grimace_0",
            1: "apgar_grimace_1",
            2: "apgar_grimace_2",
        ]
    )

    static let activity = ApgarCriterion(
        id: "activity",
        nameKey: "apgar_activity",
        descriptions: [
            0: "apgar_activity_0",
            1: "apgar_activity_1",
            2: "apgar_activity_2",
        ]
    )

    static let respiration = ApgarCriterion(
        id: "respiration",
        nameKey: "apgar_respiration",
        descriptions: [
            0: "apgar_respiration_0",
            1: "apgar_respiration_1",
            2: "apgar_respiration_2",
        ]
    )

    static let all: [ApgarCriterion] = [
        appearance, pulse, grimace, activity, respiration,
    ]
}

enum ApgarCalculator {
    /// Interprets total Apgar score (0–10).
    static func interpretation(score: Int) -> String {
        switch score {
        case 7...10: return "apgar_normal"
        case 4...6: return "apgar_moderate"
        default: return "apgar_severe"
        }
    }
}
