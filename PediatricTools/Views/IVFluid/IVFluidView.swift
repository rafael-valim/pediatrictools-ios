import SwiftUI

struct IVFluidView: View {
    @State private var weightText = ""

    private var weightKg: Double { Double(weightText) ?? 0 }

    private var result: HollidaySegarCalculator.Result? {
        guard weightKg > 0 else { return nil }
        return HollidaySegarCalculator.calculate(weightKg: weightKg)
    }

    var body: some View {
        Form {
            Section {
                NumberInputRow(labelKey: "input_weight", unitKey: "unit_kg", value: $weightText)
            }

            Section {
                Text("ivfluid_formula_explanation")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            } header: {
                Text("ivfluid_formula")
            }

            if let result {
                Section {
                    row("ivfluid_daily_rate", value: "\(formatNumber(result.dailyMl)) mL/day")
                    row("ivfluid_hourly_rate", value: "\(formatNumber(result.hourlyMl)) mL/hr")
                    row("ivfluid_per_kg", value: "\(formatNumber(result.dailyPerKg)) mL/kg/day")
                } header: {
                    Text("ivfluid_results")
                }

                Section {
                    Text("ivfluid_electrolytes_info")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                } header: {
                    Text("ivfluid_electrolytes")
                }
            }
        }
        .safeAreaInset(edge: .bottom) {
            if let result {
                ResultBar {
                    HStack(spacing: 16) {
                        VStack(spacing: 2) {
                            Text("ivfluid_daily_short")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text("\(formatNumber(result.dailyMl)) mL")
                                .font(.subheadline.weight(.bold))
                        }
                        Divider().fixedSize(horizontal: false, vertical: true)
                        VStack(spacing: 2) {
                            Text("ivfluid_hourly_short")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text("\(formatNumber(result.hourlyMl)) mL/hr")
                                .font(.subheadline.weight(.bold))
                                .foregroundStyle(.accent)
                        }
                    }
                }
                .padding(.bottom, 4)
            }
        }
        .navigationTitle("ivfluid_title")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("reset_button") { weightText = "" }
            }
        }
    }

    private func row(_ key: String, value: String) -> some View {
        HStack {
            Text(String(localized: String.LocalizationValue(key)))
            Spacer()
            Text(value)
                .fontWeight(.medium)
        }
    }

    private func formatNumber(_ n: Double) -> String {
        if n == n.rounded() { return String(format: "%.0f", n) }
        return String(format: "%.1f", n)
    }
}
