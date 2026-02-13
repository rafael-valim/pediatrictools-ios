import SwiftUI

struct DehydrationView: View {
    @State private var weightText = ""
    @State private var severity: DehydrationSeverity = .moderate
    @State private var customPercent = ""

    private var weightKg: Double { Double(weightText) ?? 0 }
    private var dehydrationPercent: Double {
        if let custom = Double(customPercent), custom > 0 { return custom }
        return severity.defaultPercent
    }

    private var result: DehydrationCalculator.Result? {
        guard weightKg > 0 else { return nil }
        return DehydrationCalculator.calculate(weightKg: weightKg, dehydrationPercent: dehydrationPercent)
    }

    var body: some View {
        Form {
            Section {
                NumberInputRow(labelKey: "input_weight", unitKey: "unit_kg", value: $weightText, range: 0.1...300)
            }

            Section {
                Picker(selection: $severity) {
                    ForEach(DehydrationSeverity.allCases) { s in
                        Text("\(Text(LocalizedStringKey(s.nameKey))) (\(s.percentRange))")
                            .tag(s)
                    }
                } label: {
                    Text("dehydration_severity")
                }
                .onChange(of: severity) { customPercent = "" }

                NumberInputRow(labelKey: "dehydration_custom_percent", unitKey: "unit_percent", value: $customPercent, placeholder: String(format: "%.1f", severity.defaultPercent), range: 0.1...20)
            } header: {
                Text("dehydration_assessment")
            }

            if let result {
                Section {
                    row("dehydration_deficit", value: "\(formatNumber(result.deficitMl)) mL")
                    row("dehydration_maintenance", value: "\(formatNumber(result.maintenanceMlPerDay)) mL/day")
                    row("dehydration_total_24h", value: "\(formatNumber(result.totalFirst24hMl)) mL")
                } header: {
                    Text("dehydration_plan")
                }
            }
        }
        .scrollDismissesKeyboard(.interactively)
        .modifier(KeyboardDoneButton())
        .safeAreaInset(edge: .bottom) {
            if let result {
                ResultBar {
                    HStack(spacing: 16) {
                        VStack(spacing: 2) {
                            Text("dehydration_deficit_short")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text("\(formatNumber(result.deficitMl)) mL")
                                .font(.subheadline.weight(.bold))
                        }
                        Divider().fixedSize(horizontal: false, vertical: true)
                        VStack(spacing: 2) {
                            Text("dehydration_total_short")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text("\(formatNumber(result.totalFirst24hMl)) mL")
                                .font(.subheadline.weight(.bold))
                                .foregroundStyle(.accent)
                        }
                    }
                }
                .padding(.bottom, 4)
            }
        }
        .navigationTitle("dehydration_title")
        .navigationBarTitleDisplayMode(.inline)
        .modifier(ToolInfoToolbar(toolID: "dehydration"))
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("reset_button") {
                    weightText = ""
                    customPercent = ""
                }
            }
        }
    }

    private func row(_ key: String, value: String) -> some View {
        HStack {
            Text(LocalizedStringKey(key))
            Spacer()
            Text(value).fontWeight(.medium)
        }
    }

    private func formatNumber(_ n: Double) -> String {
        if n == n.rounded() { return String(format: "%.0f", n) }
        return String(format: "%.1f", n)
    }
}
