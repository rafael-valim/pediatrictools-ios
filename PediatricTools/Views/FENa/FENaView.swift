import SwiftUI

struct FENaView: View {
    @State private var urineSodiumText = ""
    @State private var plasmaSodiumText = ""
    @State private var urineCreatinineText = ""
    @State private var plasmaCreatinineText = ""

    private var result: FENaCalculator.Result? {
        guard let una = Double(urineSodiumText), una > 0,
              let pna = Double(plasmaSodiumText), pna > 0,
              let ucr = Double(urineCreatinineText), ucr > 0,
              let pcr = Double(plasmaCreatinineText), pcr > 0 else { return nil }
        return FENaCalculator.calculate(
            urineSodium: una,
            plasmaSodium: pna,
            urineCreatinine: ucr,
            plasmaCreatinine: pcr
        )
    }

    var body: some View {
        Form {
            Section {
                NumberInputRow(labelKey: "fena_urine_sodium", unitKey: "unit_meq_l", value: $urineSodiumText)
                NumberInputRow(labelKey: "fena_plasma_sodium", unitKey: "unit_meq_l", value: $plasmaSodiumText)
            } header: {
                Text("fena_sodium")
            }

            Section {
                NumberInputRow(labelKey: "fena_urine_creatinine", unitKey: "unit_mg_dl", value: $urineCreatinineText)
                NumberInputRow(labelKey: "fena_plasma_creatinine", unitKey: "unit_mg_dl", value: $plasmaCreatinineText)
            } header: {
                Text("fena_creatinine")
            }

            Section {
                Text("fena_formula_explanation")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            } header: {
                Text("fena_formula")
            }
        }
        .safeAreaInset(edge: .bottom) {
            if let result {
                ResultBar {
                    HStack(spacing: 16) {
                        VStack(spacing: 2) {
                            Text("fena_result")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text(String(format: "%.2f%%", result.fena))
                                .font(.subheadline.weight(.bold))
                        }
                        Divider().fixedSize(horizontal: false, vertical: true)
                        Text(String(localized: String.LocalizationValue(result.interpretationKey)))
                            .font(.subheadline.weight(.bold))
                            .foregroundStyle(result.fena < 1 ? .orange : result.fena <= 2 ? .yellow : .red)
                    }
                }
                .padding(.bottom, 4)
            }
        }
        .navigationTitle("fena_title")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("reset_button") {
                    urineSodiumText = ""
                    plasmaSodiumText = ""
                    urineCreatinineText = ""
                    plasmaCreatinineText = ""
                }
            }
        }
    }
}
