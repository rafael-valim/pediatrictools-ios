import SwiftUI

struct BSAView: View {
    @State private var weightText = ""
    @State private var heightText = ""

    private var weightKg: Double { Double(weightText) ?? 0 }
    private var heightCm: Double { Double(heightText) ?? 0 }

    private var bsa: Double? {
        guard weightKg > 0, heightCm > 0 else { return nil }
        return BSACalculator.mosteller(heightCm: heightCm, weightKg: weightKg)
    }

    var body: some View {
        Form {
            Section {
                NumberInputRow(labelKey: "input_weight", unitKey: "unit_kg", value: $weightText, range: 0.1...300)
                NumberInputRow(labelKey: "input_height", unitKey: "unit_cm", value: $heightText, range: 10...250)
            }

            Section {
                Text("bsa_formula_explanation")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            } header: {
                Text("bsa_formula")
            }
        }
        .scrollDismissesKeyboard(.interactively)
        .modifier(KeyboardDoneButton())
        .safeAreaInset(edge: .bottom) {
            if let bsa {
                ResultBar {
                    HStack(spacing: 4) {
                        Text("bsa_result_label")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Text(String(format: "%.4f m²", bsa))
                            .font(.subheadline.weight(.bold))
                            .foregroundStyle(.accent)
                    }
                }
                .padding(.bottom, 4)
            }
        }
        .navigationTitle("bsa_title")
        .navigationBarTitleDisplayMode(.inline)
        .modifier(ToolInfoToolbar(toolID: "bsa"))
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("reset_button") {
                    weightText = ""
                    heightText = ""
                }
            }
        }
    }
}
