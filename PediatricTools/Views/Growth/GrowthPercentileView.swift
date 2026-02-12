import SwiftUI

struct GrowthPercentileView: View {
    @State private var sex: Sex = .male
    @State private var measurement: GrowthMeasurement = .weightForAge
    @State private var ageMonthsText = ""
    @State private var valueText = ""

    private var ageMonths: Double { Double(ageMonthsText) ?? 0 }
    private var value: Double { Double(valueText) ?? 0 }

    private var result: (zScore: Double, percentile: Double)? {
        guard ageMonths >= 0, ageMonths <= 24, value > 0 else { return nil }
        return GrowthPercentileCalculator.calculate(
            sex: sex,
            measurement: measurement,
            ageMonths: ageMonths,
            value: value
        )
    }

    var body: some View {
        Form {
            Section {
                Picker(selection: $sex) {
                    ForEach(Sex.allCases) { s in
                        Text(LocalizedStringKey(s.localizedKey)).tag(s)
                    }
                } label: {
                    Text("sex_label")
                }
                .pickerStyle(.segmented)

                Picker(selection: $measurement) {
                    ForEach(GrowthMeasurement.allCases) { m in
                        Text(LocalizedStringKey(m.nameKey)).tag(m)
                    }
                } label: {
                    Text("growth_measurement")
                }
            }

            Section {
                NumberInputRow(labelKey: "growth_age_months", unitKey: "unit_months", value: $ageMonthsText, range: 0...24)
                NumberInputRow(
                    labelKey: measurement == .weightForAge ? "input_weight" : "input_height",
                    unitKey: measurement.unitKey,
                    value: $valueText,
                    range: measurement == .weightForAge ? 0.1...300 : 10...250
                )
            } header: {
                Text("growth_input")
            }

            Section {
                Text("growth_data_note")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .scrollDismissesKeyboard(.interactively)
        .safeAreaInset(edge: .bottom) {
            if let result {
                ResultBar {
                    HStack(spacing: 16) {
                        VStack(spacing: 2) {
                            Text("growth_zscore")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text(String(format: "%.2f", result.zScore))
                                .font(.subheadline.weight(.bold))
                        }
                        Divider().fixedSize(horizontal: false, vertical: true)
                        VStack(spacing: 2) {
                            Text("growth_percentile")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text(String(format: "%.1f%%", result.percentile))
                                .font(.subheadline.weight(.bold))
                                .foregroundStyle(.accent)
                        }
                    }
                }
                .padding(.bottom, 4)
            }
        }
        .navigationTitle("growth_title")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("reset_button") {
                    ageMonthsText = ""
                    valueText = ""
                }
            }
        }
    }
}
