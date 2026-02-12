import Foundation

struct Medication: Identifiable {
    let id: String
    let nameKey: String
    let dosePerKg: Double        // mg/kg per dose
    let maxDosePerKg: Double     // mg/kg per dose (high end)
    let maxSingleDose: Double    // mg absolute max per dose
    let frequencyKey: String     // e.g. "q6h", "q8h"
    let concentrations: [MedicationConcentration]
}

struct MedicationConcentration: Identifiable {
    let id: String
    let labelKey: String         // e.g. "160mg/5mL"
    let mgPerMl: Double
}

enum PediatricDosageCalculator {
    struct DoseResult {
        let lowDoseMg: Double
        let highDoseMg: Double
        let cappedLow: Bool      // was low dose capped at max?
        let cappedHigh: Bool
        let volumeMl: Double?    // if concentration selected
        let volumeHighMl: Double?
    }

    static func calculate(
        medication: Medication,
        weightKg: Double,
        concentration: MedicationConcentration? = nil
    ) -> DoseResult {
        var lowDose = weightKg * medication.dosePerKg
        var highDose = weightKg * medication.maxDosePerKg
        let cappedLow = lowDose > medication.maxSingleDose
        let cappedHigh = highDose > medication.maxSingleDose
        lowDose = min(lowDose, medication.maxSingleDose)
        highDose = min(highDose, medication.maxSingleDose)

        var volLow: Double?
        var volHigh: Double?
        if let conc = concentration, conc.mgPerMl > 0 {
            volLow = lowDose / conc.mgPerMl
            volHigh = highDose / conc.mgPerMl
        }

        return DoseResult(
            lowDoseMg: lowDose,
            highDoseMg: highDose,
            cappedLow: cappedLow,
            cappedHigh: cappedHigh,
            volumeMl: volLow,
            volumeHighMl: volHigh
        )
    }
}

// MARK: - Medication Database

enum Medications {
    static let all: [Medication] = [
        acetaminophen, ibuprofen, amoxicillin, amoxicillinHighDose,
        azithromycin, cephalexin, prednisolone, ondansetron, diphenhydramine,
    ]

    static let acetaminophen = Medication(
        id: "acetaminophen",
        nameKey: "med_acetaminophen",
        dosePerKg: 10, maxDosePerKg: 15, maxSingleDose: 1000,
        frequencyKey: "freq_q4_6h",
        concentrations: [
            .init(id: "acet_160_5", labelKey: "conc_160_5ml", mgPerMl: 32),
            .init(id: "acet_325tab", labelKey: "conc_325mg_tab", mgPerMl: 325),
            .init(id: "acet_500tab", labelKey: "conc_500mg_tab", mgPerMl: 500),
        ]
    )

    static let ibuprofen = Medication(
        id: "ibuprofen",
        nameKey: "med_ibuprofen",
        dosePerKg: 5, maxDosePerKg: 10, maxSingleDose: 400,
        frequencyKey: "freq_q6_8h",
        concentrations: [
            .init(id: "ibu_100_5", labelKey: "conc_100_5ml", mgPerMl: 20),
            .init(id: "ibu_200tab", labelKey: "conc_200mg_tab", mgPerMl: 200),
        ]
    )

    static let amoxicillin = Medication(
        id: "amoxicillin",
        nameKey: "med_amoxicillin",
        dosePerKg: 12.5, maxDosePerKg: 25, maxSingleDose: 500,
        frequencyKey: "freq_q8_12h",
        concentrations: [
            .init(id: "amox_125_5", labelKey: "conc_125_5ml", mgPerMl: 25),
            .init(id: "amox_250_5", labelKey: "conc_250_5ml", mgPerMl: 50),
            .init(id: "amox_500tab", labelKey: "conc_500mg_tab", mgPerMl: 500),
        ]
    )

    static let amoxicillinHighDose = Medication(
        id: "amoxicillinHD",
        nameKey: "med_amoxicillin_hd",
        dosePerKg: 40, maxDosePerKg: 45, maxSingleDose: 2000,
        frequencyKey: "freq_q12h",
        concentrations: [
            .init(id: "amoxhd_250_5", labelKey: "conc_250_5ml", mgPerMl: 50),
            .init(id: "amoxhd_400_5", labelKey: "conc_400_5ml", mgPerMl: 80),
        ]
    )

    static let azithromycin = Medication(
        id: "azithromycin",
        nameKey: "med_azithromycin",
        dosePerKg: 10, maxDosePerKg: 10, maxSingleDose: 500,
        frequencyKey: "freq_q24h_day1",
        concentrations: [
            .init(id: "azi_200_5", labelKey: "conc_200_5ml", mgPerMl: 40),
            .init(id: "azi_250tab", labelKey: "conc_250mg_tab", mgPerMl: 250),
        ]
    )

    static let cephalexin = Medication(
        id: "cephalexin",
        nameKey: "med_cephalexin",
        dosePerKg: 6.25, maxDosePerKg: 12.5, maxSingleDose: 500,
        frequencyKey: "freq_q6_8h",
        concentrations: [
            .init(id: "ceph_125_5", labelKey: "conc_125_5ml", mgPerMl: 25),
            .init(id: "ceph_250_5", labelKey: "conc_250_5ml", mgPerMl: 50),
            .init(id: "ceph_500tab", labelKey: "conc_500mg_tab", mgPerMl: 500),
        ]
    )

    static let prednisolone = Medication(
        id: "prednisolone",
        nameKey: "med_prednisolone",
        dosePerKg: 1, maxDosePerKg: 2, maxSingleDose: 60,
        frequencyKey: "freq_q24h",
        concentrations: [
            .init(id: "pred_15_5", labelKey: "conc_15_5ml", mgPerMl: 3),
            .init(id: "pred_5tab", labelKey: "conc_5mg_tab", mgPerMl: 5),
        ]
    )

    static let ondansetron = Medication(
        id: "ondansetron",
        nameKey: "med_ondansetron",
        dosePerKg: 0.15, maxDosePerKg: 0.15, maxSingleDose: 4,
        frequencyKey: "freq_q8h",
        concentrations: [
            .init(id: "ond_4_5", labelKey: "conc_4_5ml", mgPerMl: 0.8),
            .init(id: "ond_4tab", labelKey: "conc_4mg_tab", mgPerMl: 4),
        ]
    )

    static let diphenhydramine = Medication(
        id: "diphenhydramine",
        nameKey: "med_diphenhydramine",
        dosePerKg: 1, maxDosePerKg: 1.25, maxSingleDose: 50,
        frequencyKey: "freq_q6h",
        concentrations: [
            .init(id: "diph_12_5_5", labelKey: "conc_12_5_5ml", mgPerMl: 2.5),
            .init(id: "diph_25tab", labelKey: "conc_25mg_tab", mgPerMl: 25),
        ]
    )
}
