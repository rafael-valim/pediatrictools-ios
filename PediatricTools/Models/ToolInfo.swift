import Foundation

struct ToolInfoLink: Identifiable {
    let id: String
    let titleKey: String
    let url: URL
}

struct ToolInfoParameter: Identifiable {
    let id: String
    let nameKey: String
    let descriptionKey: String
}

struct ToolInfoData: Identifiable {
    let id: String
    let overviewKey: String
    let interpretationKey: String
    let parameters: [ToolInfoParameter]
    let referenceKeys: [String]
    let links: [ToolInfoLink]
}

enum ToolInfoCatalog {
    static func info(for toolID: String) -> ToolInfoData? {
        all.first { $0.id == toolID }
    }

    static let all: [ToolInfoData] = [
        // MARK: - Apgar
        ToolInfoData(
            id: "apgar",
            overviewKey: "info_apgar_overview",
            interpretationKey: "info_apgar_interpretation",
            parameters: [
                ToolInfoParameter(id: "apgar_appearance", nameKey: "info_apgar_param_appearance", descriptionKey: "info_apgar_param_appearance_desc"),
                ToolInfoParameter(id: "apgar_pulse", nameKey: "info_apgar_param_pulse", descriptionKey: "info_apgar_param_pulse_desc"),
                ToolInfoParameter(id: "apgar_grimace", nameKey: "info_apgar_param_grimace", descriptionKey: "info_apgar_param_grimace_desc"),
                ToolInfoParameter(id: "apgar_activity", nameKey: "info_apgar_param_activity", descriptionKey: "info_apgar_param_activity_desc"),
                ToolInfoParameter(id: "apgar_respiration", nameKey: "info_apgar_param_respiration", descriptionKey: "info_apgar_param_respiration_desc"),
            ],
            referenceKeys: ["about_ref_apgar"],
            links: [
                ToolInfoLink(id: "apgar_wiki", titleKey: "info_apgar_link_wiki", url: URL(string: "https://en.wikipedia.org/wiki/Apgar_score")!),
                ToolInfoLink(id: "apgar_pubmed", titleKey: "info_apgar_link_pubmed", url: URL(string: "https://pubmed.ncbi.nlm.nih.gov/13083014/")!),
            ]
        ),

        // MARK: - Ballard
        ToolInfoData(
            id: "ballard",
            overviewKey: "info_ballard_overview",
            interpretationKey: "info_ballard_interpretation",
            parameters: [
                ToolInfoParameter(id: "ballard_neuro", nameKey: "info_ballard_param_neuromuscular", descriptionKey: "info_ballard_param_neuromuscular_desc"),
                ToolInfoParameter(id: "ballard_physical", nameKey: "info_ballard_param_physical", descriptionKey: "info_ballard_param_physical_desc"),
            ],
            referenceKeys: ["about_ref_ballard"],
            links: [
                ToolInfoLink(id: "ballard_wiki", titleKey: "info_ballard_link_wiki", url: URL(string: "https://en.wikipedia.org/wiki/Ballard_Maturational_Assessment")!),
            ]
        ),

        // MARK: - PEWS
        ToolInfoData(
            id: "pews",
            overviewKey: "info_pews_overview",
            interpretationKey: "info_pews_interpretation",
            parameters: [
                ToolInfoParameter(id: "pews_behavior", nameKey: "info_pews_param_behavior", descriptionKey: "info_pews_param_behavior_desc"),
                ToolInfoParameter(id: "pews_cardio", nameKey: "info_pews_param_cardiovascular", descriptionKey: "info_pews_param_cardiovascular_desc"),
                ToolInfoParameter(id: "pews_resp", nameKey: "info_pews_param_respiratory", descriptionKey: "info_pews_param_respiratory_desc"),
            ],
            referenceKeys: ["about_ref_pews"],
            links: [
                ToolInfoLink(id: "pews_pubmed", titleKey: "info_pews_link_pubmed", url: URL(string: "https://pubmed.ncbi.nlm.nih.gov/16371945/")!),
            ]
        ),

        // MARK: - FLACC
        ToolInfoData(
            id: "flacc",
            overviewKey: "info_flacc_overview",
            interpretationKey: "info_flacc_interpretation",
            parameters: [
                ToolInfoParameter(id: "flacc_face", nameKey: "info_flacc_param_face", descriptionKey: "info_flacc_param_face_desc"),
                ToolInfoParameter(id: "flacc_legs", nameKey: "info_flacc_param_legs", descriptionKey: "info_flacc_param_legs_desc"),
                ToolInfoParameter(id: "flacc_activity", nameKey: "info_flacc_param_activity", descriptionKey: "info_flacc_param_activity_desc"),
                ToolInfoParameter(id: "flacc_cry", nameKey: "info_flacc_param_cry", descriptionKey: "info_flacc_param_cry_desc"),
                ToolInfoParameter(id: "flacc_consolability", nameKey: "info_flacc_param_consolability", descriptionKey: "info_flacc_param_consolability_desc"),
            ],
            referenceKeys: ["about_ref_flacc"],
            links: [
                ToolInfoLink(id: "flacc_pubmed", titleKey: "info_flacc_link_pubmed", url: URL(string: "https://pubmed.ncbi.nlm.nih.gov/9palcr/")!),
            ]
        ),

        // MARK: - GCS
        ToolInfoData(
            id: "gcs",
            overviewKey: "info_gcs_overview",
            interpretationKey: "info_gcs_interpretation",
            parameters: [
                ToolInfoParameter(id: "gcs_eye", nameKey: "info_gcs_param_eye", descriptionKey: "info_gcs_param_eye_desc"),
                ToolInfoParameter(id: "gcs_verbal", nameKey: "info_gcs_param_verbal", descriptionKey: "info_gcs_param_verbal_desc"),
                ToolInfoParameter(id: "gcs_motor", nameKey: "info_gcs_param_motor", descriptionKey: "info_gcs_param_motor_desc"),
            ],
            referenceKeys: ["about_ref_gcs"],
            links: [
                ToolInfoLink(id: "gcs_wiki", titleKey: "info_gcs_link_wiki", url: URL(string: "https://en.wikipedia.org/wiki/Glasgow_Coma_Scale")!),
                ToolInfoLink(id: "gcs_pubmed", titleKey: "info_gcs_link_pubmed", url: URL(string: "https://pubmed.ncbi.nlm.nih.gov/4136544/")!),
            ]
        ),

        // MARK: - PRAM
        ToolInfoData(
            id: "pram",
            overviewKey: "info_pram_overview",
            interpretationKey: "info_pram_interpretation",
            parameters: [
                ToolInfoParameter(id: "pram_scalene", nameKey: "info_pram_param_scalene", descriptionKey: "info_pram_param_scalene_desc"),
                ToolInfoParameter(id: "pram_suprasternal", nameKey: "info_pram_param_suprasternal", descriptionKey: "info_pram_param_suprasternal_desc"),
                ToolInfoParameter(id: "pram_wheezing", nameKey: "info_pram_param_wheezing", descriptionKey: "info_pram_param_wheezing_desc"),
                ToolInfoParameter(id: "pram_air_entry", nameKey: "info_pram_param_air_entry", descriptionKey: "info_pram_param_air_entry_desc"),
                ToolInfoParameter(id: "pram_o2sat", nameKey: "info_pram_param_o2sat", descriptionKey: "info_pram_param_o2sat_desc"),
            ],
            referenceKeys: ["about_ref_pram"],
            links: [
                ToolInfoLink(id: "pram_pubmed", titleKey: "info_pram_link_pubmed", url: URL(string: "https://pubmed.ncbi.nlm.nih.gov/10742324/")!),
            ]
        ),

        // MARK: - PECARN
        ToolInfoData(
            id: "pecarn",
            overviewKey: "info_pecarn_overview",
            interpretationKey: "info_pecarn_interpretation",
            parameters: [
                ToolInfoParameter(id: "pecarn_age", nameKey: "info_pecarn_param_age_group", descriptionKey: "info_pecarn_param_age_group_desc"),
                ToolInfoParameter(id: "pecarn_criteria", nameKey: "info_pecarn_param_criteria", descriptionKey: "info_pecarn_param_criteria_desc"),
            ],
            referenceKeys: ["about_ref_pecarn"],
            links: [
                ToolInfoLink(id: "pecarn_pubmed", titleKey: "info_pecarn_link_pubmed", url: URL(string: "https://pubmed.ncbi.nlm.nih.gov/19758692/")!),
                ToolInfoLink(id: "pecarn_wiki", titleKey: "info_pecarn_link_wiki", url: URL(string: "https://en.wikipedia.org/wiki/PECARN")!),
            ]
        ),

        // MARK: - Phoenix
        ToolInfoData(
            id: "phoenix",
            overviewKey: "info_phoenix_overview",
            interpretationKey: "info_phoenix_interpretation",
            parameters: [
                ToolInfoParameter(id: "phoenix_resp", nameKey: "info_phoenix_param_respiratory", descriptionKey: "info_phoenix_param_respiratory_desc"),
                ToolInfoParameter(id: "phoenix_cardio", nameKey: "info_phoenix_param_cardiovascular", descriptionKey: "info_phoenix_param_cardiovascular_desc"),
                ToolInfoParameter(id: "phoenix_coag", nameKey: "info_phoenix_param_coagulation", descriptionKey: "info_phoenix_param_coagulation_desc"),
                ToolInfoParameter(id: "phoenix_neuro", nameKey: "info_phoenix_param_neurologic", descriptionKey: "info_phoenix_param_neurologic_desc"),
            ],
            referenceKeys: ["about_ref_phoenix"],
            links: [
                ToolInfoLink(id: "phoenix_pubmed", titleKey: "info_phoenix_link_pubmed", url: URL(string: "https://pubmed.ncbi.nlm.nih.gov/38245897/")!),
            ]
        ),

        // MARK: - Dosage
        ToolInfoData(
            id: "dosage",
            overviewKey: "info_dosage_overview",
            interpretationKey: "info_dosage_interpretation",
            parameters: [
                ToolInfoParameter(id: "dosage_weight", nameKey: "info_dosage_param_weight", descriptionKey: "info_dosage_param_weight_desc"),
                ToolInfoParameter(id: "dosage_med", nameKey: "info_dosage_param_medication", descriptionKey: "info_dosage_param_medication_desc"),
                ToolInfoParameter(id: "dosage_conc", nameKey: "info_dosage_param_concentration", descriptionKey: "info_dosage_param_concentration_desc"),
            ],
            referenceKeys: ["about_ref_dosage"],
            links: []
        ),

        // MARK: - IV Fluid
        ToolInfoData(
            id: "ivfluid",
            overviewKey: "info_ivfluid_overview",
            interpretationKey: "info_ivfluid_interpretation",
            parameters: [
                ToolInfoParameter(id: "ivfluid_weight", nameKey: "info_ivfluid_param_weight", descriptionKey: "info_ivfluid_param_weight_desc"),
            ],
            referenceKeys: ["about_ref_ivfluid"],
            links: [
                ToolInfoLink(id: "ivfluid_wiki", titleKey: "info_ivfluid_link_wiki", url: URL(string: "https://en.wikipedia.org/wiki/Holliday%E2%80%93Segar_formula")!),
            ]
        ),

        // MARK: - BSA
        ToolInfoData(
            id: "bsa",
            overviewKey: "info_bsa_overview",
            interpretationKey: "info_bsa_interpretation",
            parameters: [
                ToolInfoParameter(id: "bsa_weight", nameKey: "info_bsa_param_weight", descriptionKey: "info_bsa_param_weight_desc"),
                ToolInfoParameter(id: "bsa_height", nameKey: "info_bsa_param_height", descriptionKey: "info_bsa_param_height_desc"),
            ],
            referenceKeys: ["about_ref_bsa"],
            links: [
                ToolInfoLink(id: "bsa_wiki", titleKey: "info_bsa_link_wiki", url: URL(string: "https://en.wikipedia.org/wiki/Body_surface_area")!),
            ]
        ),

        // MARK: - Corrected Age
        ToolInfoData(
            id: "corrected",
            overviewKey: "info_corrected_overview",
            interpretationKey: "info_corrected_interpretation",
            parameters: [
                ToolInfoParameter(id: "corrected_birth", nameKey: "info_corrected_param_birth_date", descriptionKey: "info_corrected_param_birth_date_desc"),
                ToolInfoParameter(id: "corrected_ga", nameKey: "info_corrected_param_ga", descriptionKey: "info_corrected_param_ga_desc"),
            ],
            referenceKeys: ["about_ref_corrected"],
            links: []
        ),

        // MARK: - Growth
        ToolInfoData(
            id: "growth",
            overviewKey: "info_growth_overview",
            interpretationKey: "info_growth_interpretation",
            parameters: [
                ToolInfoParameter(id: "growth_sex", nameKey: "info_growth_param_sex", descriptionKey: "info_growth_param_sex_desc"),
                ToolInfoParameter(id: "growth_measurement", nameKey: "info_growth_param_measurement", descriptionKey: "info_growth_param_measurement_desc"),
                ToolInfoParameter(id: "growth_age", nameKey: "info_growth_param_age", descriptionKey: "info_growth_param_age_desc"),
                ToolInfoParameter(id: "growth_value", nameKey: "info_growth_param_value", descriptionKey: "info_growth_param_value_desc"),
            ],
            referenceKeys: ["about_ref_growth"],
            links: [
                ToolInfoLink(id: "growth_who", titleKey: "info_growth_link_who", url: URL(string: "https://www.who.int/tools/child-growth-standards")!),
            ]
        ),

        // MARK: - Dehydration
        ToolInfoData(
            id: "dehydration",
            overviewKey: "info_dehydration_overview",
            interpretationKey: "info_dehydration_interpretation",
            parameters: [
                ToolInfoParameter(id: "dehydration_weight", nameKey: "info_dehydration_param_weight", descriptionKey: "info_dehydration_param_weight_desc"),
                ToolInfoParameter(id: "dehydration_severity", nameKey: "info_dehydration_param_severity", descriptionKey: "info_dehydration_param_severity_desc"),
            ],
            referenceKeys: ["about_ref_dehydration"],
            links: []
        ),

        // MARK: - FENa
        ToolInfoData(
            id: "fena",
            overviewKey: "info_fena_overview",
            interpretationKey: "info_fena_interpretation",
            parameters: [
                ToolInfoParameter(id: "fena_una", nameKey: "info_fena_param_urine_sodium", descriptionKey: "info_fena_param_urine_sodium_desc"),
                ToolInfoParameter(id: "fena_pna", nameKey: "info_fena_param_plasma_sodium", descriptionKey: "info_fena_param_plasma_sodium_desc"),
                ToolInfoParameter(id: "fena_ucr", nameKey: "info_fena_param_urine_creatinine", descriptionKey: "info_fena_param_urine_creatinine_desc"),
                ToolInfoParameter(id: "fena_pcr", nameKey: "info_fena_param_plasma_creatinine", descriptionKey: "info_fena_param_plasma_creatinine_desc"),
            ],
            referenceKeys: ["about_ref_fena"],
            links: [
                ToolInfoLink(id: "fena_wiki", titleKey: "info_fena_link_wiki", url: URL(string: "https://en.wikipedia.org/wiki/Fractional_sodium_excretion")!),
            ]
        ),

        // MARK: - ETT
        ToolInfoData(
            id: "ett",
            overviewKey: "info_ett_overview",
            interpretationKey: "info_ett_interpretation",
            parameters: [
                ToolInfoParameter(id: "ett_mode", nameKey: "info_ett_param_mode", descriptionKey: "info_ett_param_mode_desc"),
                ToolInfoParameter(id: "ett_age", nameKey: "info_ett_param_age", descriptionKey: "info_ett_param_age_desc"),
                ToolInfoParameter(id: "ett_weight", nameKey: "info_ett_param_weight", descriptionKey: "info_ett_param_weight_desc"),
            ],
            referenceKeys: ["about_ref_ett"],
            links: []
        ),

        // MARK: - Schwartz GFR
        ToolInfoData(
            id: "gfr",
            overviewKey: "info_gfr_overview",
            interpretationKey: "info_gfr_interpretation",
            parameters: [
                ToolInfoParameter(id: "gfr_height", nameKey: "info_gfr_param_height", descriptionKey: "info_gfr_param_height_desc"),
                ToolInfoParameter(id: "gfr_creatinine", nameKey: "info_gfr_param_creatinine", descriptionKey: "info_gfr_param_creatinine_desc"),
            ],
            referenceKeys: ["about_ref_gfr"],
            links: [
                ToolInfoLink(id: "gfr_wiki", titleKey: "info_gfr_link_wiki", url: URL(string: "https://en.wikipedia.org/wiki/Glomerular_filtration_rate")!),
            ]
        ),

        // MARK: - QTc
        ToolInfoData(
            id: "qtc",
            overviewKey: "info_qtc_overview",
            interpretationKey: "info_qtc_interpretation",
            parameters: [
                ToolInfoParameter(id: "qtc_qt", nameKey: "info_qtc_param_qt", descriptionKey: "info_qtc_param_qt_desc"),
                ToolInfoParameter(id: "qtc_hr", nameKey: "info_qtc_param_hr", descriptionKey: "info_qtc_param_hr_desc"),
                ToolInfoParameter(id: "qtc_sex", nameKey: "info_qtc_param_sex", descriptionKey: "info_qtc_param_sex_desc"),
            ],
            referenceKeys: ["about_ref_qtc"],
            links: [
                ToolInfoLink(id: "qtc_wiki", titleKey: "info_qtc_link_wiki", url: URL(string: "https://en.wikipedia.org/wiki/QT_interval")!),
            ]
        ),

        // MARK: - BP Percentile
        ToolInfoData(
            id: "bp",
            overviewKey: "info_bp_overview",
            interpretationKey: "info_bp_interpretation",
            parameters: [
                ToolInfoParameter(id: "bp_sex", nameKey: "info_bp_param_sex", descriptionKey: "info_bp_param_sex_desc"),
                ToolInfoParameter(id: "bp_age", nameKey: "info_bp_param_age", descriptionKey: "info_bp_param_age_desc"),
                ToolInfoParameter(id: "bp_height", nameKey: "info_bp_param_height_percentile", descriptionKey: "info_bp_param_height_percentile_desc"),
                ToolInfoParameter(id: "bp_systolic", nameKey: "info_bp_param_systolic", descriptionKey: "info_bp_param_systolic_desc"),
                ToolInfoParameter(id: "bp_diastolic", nameKey: "info_bp_param_diastolic", descriptionKey: "info_bp_param_diastolic_desc"),
            ],
            referenceKeys: ["about_ref_bp"],
            links: [
                ToolInfoLink(id: "bp_aap", titleKey: "info_bp_link_aap", url: URL(string: "https://pubmed.ncbi.nlm.nih.gov/28827377/")!),
            ]
        ),

        // MARK: - Bilirubin
        ToolInfoData(
            id: "bilirubin",
            overviewKey: "info_bilirubin_overview",
            interpretationKey: "info_bilirubin_interpretation",
            parameters: [
                ToolInfoParameter(id: "bili_tsb", nameKey: "info_bilirubin_param_tsb", descriptionKey: "info_bilirubin_param_tsb_desc"),
                ToolInfoParameter(id: "bili_hours", nameKey: "info_bilirubin_param_hours", descriptionKey: "info_bilirubin_param_hours_desc"),
                ToolInfoParameter(id: "bili_ga", nameKey: "info_bilirubin_param_ga_category", descriptionKey: "info_bilirubin_param_ga_category_desc"),
                ToolInfoParameter(id: "bili_risk", nameKey: "info_bilirubin_param_risk_factors", descriptionKey: "info_bilirubin_param_risk_factors_desc"),
            ],
            referenceKeys: ["about_ref_bilirubin"],
            links: [
                ToolInfoLink(id: "bili_aap", titleKey: "info_bilirubin_link_aap", url: URL(string: "https://pubmed.ncbi.nlm.nih.gov/15231951/")!),
            ]
        ),
    ]
}
