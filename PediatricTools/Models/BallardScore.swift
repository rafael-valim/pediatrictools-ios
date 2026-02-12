import Foundation

// MARK: - Sex

enum Sex: String, CaseIterable, Identifiable {
    case male
    case female

    var id: String { rawValue }

    var localizedKey: String {
        switch self {
        case .male: return "sex_male"
        case .female: return "sex_female"
        }
    }
}

// MARK: - Ballard Criterion

enum BallardCriterionCategory {
    case neuromuscular
    case physical
}

struct BallardCriterion: Identifiable {
    let id: String
    let localizedKey: String
    let category: BallardCriterionCategory
    let minScore: Int
    let maxScore: Int
    /// Localization keys for each score level description, keyed by score value
    let descriptionKeys: [Int: String]

    var scoreRange: ClosedRange<Int> { minScore...maxScore }
}

// MARK: - Criterion Definitions

enum BallardCriteria {
    // MARK: Neuromuscular

    static let posture = BallardCriterion(
        id: "posture",
        localizedKey: "criterion_posture",
        category: .neuromuscular,
        minScore: -1,
        maxScore: 4,
        descriptionKeys: [
            -1: "posture_minus1",
            0: "posture_0",
            1: "posture_1",
            2: "posture_2",
            3: "posture_3",
            4: "posture_4",
        ]
    )

    static let squareWindow = BallardCriterion(
        id: "squareWindow",
        localizedKey: "criterion_square_window",
        category: .neuromuscular,
        minScore: -1,
        maxScore: 4,
        descriptionKeys: [
            -1: "square_window_minus1",
            0: "square_window_0",
            1: "square_window_1",
            2: "square_window_2",
            3: "square_window_3",
            4: "square_window_4",
        ]
    )

    static let armRecoil = BallardCriterion(
        id: "armRecoil",
        localizedKey: "criterion_arm_recoil",
        category: .neuromuscular,
        minScore: -1,
        maxScore: 4,
        descriptionKeys: [
            -1: "arm_recoil_minus1",
            0: "arm_recoil_0",
            1: "arm_recoil_1",
            2: "arm_recoil_2",
            3: "arm_recoil_3",
            4: "arm_recoil_4",
        ]
    )

    static let poplitealAngle = BallardCriterion(
        id: "poplitealAngle",
        localizedKey: "criterion_popliteal_angle",
        category: .neuromuscular,
        minScore: -1,
        maxScore: 5,
        descriptionKeys: [
            -1: "popliteal_angle_minus1",
            0: "popliteal_angle_0",
            1: "popliteal_angle_1",
            2: "popliteal_angle_2",
            3: "popliteal_angle_3",
            4: "popliteal_angle_4",
            5: "popliteal_angle_5",
        ]
    )

    static let scarfSign = BallardCriterion(
        id: "scarfSign",
        localizedKey: "criterion_scarf_sign",
        category: .neuromuscular,
        minScore: -1,
        maxScore: 4,
        descriptionKeys: [
            -1: "scarf_sign_minus1",
            0: "scarf_sign_0",
            1: "scarf_sign_1",
            2: "scarf_sign_2",
            3: "scarf_sign_3",
            4: "scarf_sign_4",
        ]
    )

    static let heelToEar = BallardCriterion(
        id: "heelToEar",
        localizedKey: "criterion_heel_to_ear",
        category: .neuromuscular,
        minScore: -1,
        maxScore: 4,
        descriptionKeys: [
            -1: "heel_to_ear_minus1",
            0: "heel_to_ear_0",
            1: "heel_to_ear_1",
            2: "heel_to_ear_2",
            3: "heel_to_ear_3",
            4: "heel_to_ear_4",
        ]
    )

    // MARK: Physical

    static let skin = BallardCriterion(
        id: "skin",
        localizedKey: "criterion_skin",
        category: .physical,
        minScore: -1,
        maxScore: 5,
        descriptionKeys: [
            -1: "skin_minus1",
            0: "skin_0",
            1: "skin_1",
            2: "skin_2",
            3: "skin_3",
            4: "skin_4",
            5: "skin_5",
        ]
    )

    static let lanugo = BallardCriterion(
        id: "lanugo",
        localizedKey: "criterion_lanugo",
        category: .physical,
        minScore: -1,
        maxScore: 4,
        descriptionKeys: [
            -1: "lanugo_minus1",
            0: "lanugo_0",
            1: "lanugo_1",
            2: "lanugo_2",
            3: "lanugo_3",
            4: "lanugo_4",
        ]
    )

    static let plantarSurface = BallardCriterion(
        id: "plantarSurface",
        localizedKey: "criterion_plantar_surface",
        category: .physical,
        minScore: -1,
        maxScore: 4,
        descriptionKeys: [
            -1: "plantar_surface_minus1",
            0: "plantar_surface_0",
            1: "plantar_surface_1",
            2: "plantar_surface_2",
            3: "plantar_surface_3",
            4: "plantar_surface_4",
        ]
    )

    static let breast = BallardCriterion(
        id: "breast",
        localizedKey: "criterion_breast",
        category: .physical,
        minScore: -1,
        maxScore: 4,
        descriptionKeys: [
            -1: "breast_minus1",
            0: "breast_0",
            1: "breast_1",
            2: "breast_2",
            3: "breast_3",
            4: "breast_4",
        ]
    )

    static let eyeEar = BallardCriterion(
        id: "eyeEar",
        localizedKey: "criterion_eye_ear",
        category: .physical,
        minScore: -1,
        maxScore: 4,
        descriptionKeys: [
            -1: "eye_ear_minus1",
            0: "eye_ear_0",
            1: "eye_ear_1",
            2: "eye_ear_2",
            3: "eye_ear_3",
            4: "eye_ear_4",
        ]
    )

    static let genitalsMale = BallardCriterion(
        id: "genitalsMale",
        localizedKey: "criterion_genitals_male",
        category: .physical,
        minScore: -1,
        maxScore: 4,
        descriptionKeys: [
            -1: "genitals_male_minus1",
            0: "genitals_male_0",
            1: "genitals_male_1",
            2: "genitals_male_2",
            3: "genitals_male_3",
            4: "genitals_male_4",
        ]
    )

    static let genitalsFemale = BallardCriterion(
        id: "genitalsFemale",
        localizedKey: "criterion_genitals_female",
        category: .physical,
        minScore: -1,
        maxScore: 4,
        descriptionKeys: [
            -1: "genitals_female_minus1",
            0: "genitals_female_0",
            1: "genitals_female_1",
            2: "genitals_female_2",
            3: "genitals_female_3",
            4: "genitals_female_4",
        ]
    )

    static let neuromuscular: [BallardCriterion] = [
        posture, squareWindow, armRecoil, poplitealAngle, scarfSign, heelToEar,
    ]

    static func physical(for sex: Sex) -> [BallardCriterion] {
        let genitals: BallardCriterion = sex == .male ? genitalsMale : genitalsFemale
        return [skin, lanugo, plantarSurface, breast, eyeEar, genitals]
    }
}

// MARK: - Score Calculator

enum BallardCalculator {
    /// Calculates estimated gestational age in weeks from total Ballard score.
    /// Uses linear interpolation: each 5 points = 2 weeks, starting at score -10 = 20 weeks.
    static func gestationalAge(fromScore score: Int) -> Double {
        let clampedScore = max(-10, min(50, score))
        return 20.0 + (Double(clampedScore + 10) / 5.0) * 2.0
    }
}
