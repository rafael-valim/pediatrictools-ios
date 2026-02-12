import Foundation

struct PRAMCriterion: Identifiable {
    let id: String
    let nameKey: String
    let maxScore: Int
    let descriptions: [Int: String]
}

enum PRAMCriteria {
    static let oxygenSaturation = PRAMCriterion(
        id: "o2sat",
        nameKey: "pram_o2sat",
        maxScore: 2,
        descriptions: [
            0: "pram_o2sat_0",
            1: "pram_o2sat_1",
            2: "pram_o2sat_2",
        ]
    )

    static let suprasternalRetractions = PRAMCriterion(
        id: "suprasternal",
        nameKey: "pram_suprasternal",
        maxScore: 2,
        descriptions: [
            0: "pram_suprasternal_0",
            1: "pram_suprasternal_1",
            2: "pram_suprasternal_2",
        ]
    )

    static let scaleneMuscle = PRAMCriterion(
        id: "scalene",
        nameKey: "pram_scalene",
        maxScore: 2,
        descriptions: [
            0: "pram_scalene_0",
            1: "pram_scalene_1",
            2: "pram_scalene_2",
        ]
    )

    static let airEntry = PRAMCriterion(
        id: "airEntry",
        nameKey: "pram_air_entry",
        maxScore: 3,
        descriptions: [
            0: "pram_air_entry_0",
            1: "pram_air_entry_1",
            2: "pram_air_entry_2",
            3: "pram_air_entry_3",
        ]
    )

    static let wheezing = PRAMCriterion(
        id: "wheezing",
        nameKey: "pram_wheezing",
        maxScore: 3,
        descriptions: [
            0: "pram_wheezing_0",
            1: "pram_wheezing_1",
            2: "pram_wheezing_2",
            3: "pram_wheezing_3",
        ]
    )

    static let all: [PRAMCriterion] = [
        oxygenSaturation, suprasternalRetractions, scaleneMuscle, airEntry, wheezing,
    ]
}

enum PRAMCalculator {
    /// Interprets total PRAM score (0–12).
    static func interpretation(score: Int) -> String {
        switch score {
        case 0...3: return "pram_mild"
        case 4...7: return "pram_moderate"
        default: return "pram_severe"
        }
    }
}
