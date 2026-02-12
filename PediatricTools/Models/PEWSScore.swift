import Foundation

struct PEWSCriterion: Identifiable {
    let id: String
    let nameKey: String
    let maxScore: Int
    let descriptions: [Int: String]
}

enum PEWSCriteria {
    static let behavior = PEWSCriterion(
        id: "behavior",
        nameKey: "pews_behavior",
        maxScore: 3,
        descriptions: [
            0: "pews_behavior_0",
            1: "pews_behavior_1",
            2: "pews_behavior_2",
            3: "pews_behavior_3",
        ]
    )

    static let cardiovascular = PEWSCriterion(
        id: "cardiovascular",
        nameKey: "pews_cardiovascular",
        maxScore: 3,
        descriptions: [
            0: "pews_cardiovascular_0",
            1: "pews_cardiovascular_1",
            2: "pews_cardiovascular_2",
            3: "pews_cardiovascular_3",
        ]
    )

    static let respiratory = PEWSCriterion(
        id: "respiratory",
        nameKey: "pews_respiratory",
        maxScore: 3,
        descriptions: [
            0: "pews_respiratory_0",
            1: "pews_respiratory_1",
            2: "pews_respiratory_2",
            3: "pews_respiratory_3",
        ]
    )

    static let all: [PEWSCriterion] = [behavior, cardiovascular, respiratory]
}

enum PEWSCalculator {
    static func interpretation(score: Int) -> String {
        switch score {
        case 0...2: return "pews_low_risk"
        case 3...4: return "pews_moderate_risk"
        default: return "pews_high_risk"
        }
    }
}
