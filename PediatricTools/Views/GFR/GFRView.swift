import SwiftUI

struct GFRView: View {
    @State private var heightText = ""
    @State private var creatinineText = ""

    private var result: SchwartzGFR.Result? {
        guard let h = Double(heightText), h > 0,
              let cr = Double(creatinineText), cr > 0 else { return nil }
        return SchwartzGFR.calculate(heightCm: h, serumCreatinine: cr)
    }

    var body: some View {
        Form {
            Section {
                NumberInputRow(labelKey: "input_height", unitKey: "unit_cm", value: $heightText, range: 10...250)
                NumberInputRow(labelKey: "gfr_creatinine", unitKey: "unit_mg_dl", value: $creatinineText, range: 0.01...50)
            }

            Section {
                Text("gfr_formula_explanation")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            } header: {
                Text("gfr_formula")
            }
        }
        .scrollDismissesKeyboard(.interactively)
        .modifier(KeyboardDoneButton())
        .safeAreaInset(edge: .bottom) {
            if let result {
                ResultBar {
                    HStack(spacing: 16) {
                        VStack(spacing: 2) {
                            Text("gfr_result")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text(String(format: "%.1f mL/min/1.73m²", result.eGFR))
                                .font(.subheadline.weight(.bold))
                        }
                        Divider().fixedSize(horizontal: false, vertical: true)
                        Text(LocalizedStringKey(result.interpretationKey))
                            .font(.subheadline.weight(.bold))
                            .foregroundStyle(result.eGFR >= 90 ? .green : result.eGFR >= 60 ? .yellow : result.eGFR >= 30 ? .orange : .red)
                    }
                }
                .padding(.bottom, 4)
            }
        }
        .navigationTitle("gfr_title")
        .navigationBarTitleDisplayMode(.inline)
        .modifier(ToolInfoToolbar(toolID: "gfr"))
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("reset_button") {
                    heightText = ""
                    creatinineText = ""
                }
            }
        }
    }
}
