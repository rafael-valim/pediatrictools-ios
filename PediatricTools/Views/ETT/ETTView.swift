import SwiftUI

struct ETTView: View {
    @State private var mode: ETTMode = .ageBased
    @State private var ageYearsText = ""
    @State private var weightText = ""

    enum ETTMode: String, CaseIterable, Identifiable {
        case ageBased
        case neonatal

        var id: String { rawValue }
        var nameKey: String {
            switch self {
            case .ageBased: return "ett_age_based"
            case .neonatal: return "ett_neonatal"
            }
        }
    }

    private var result: ETTCalculator.Result? {
        switch mode {
        case .ageBased:
            guard let age = Double(ageYearsText), age >= 1 else { return nil }
            return ETTCalculator.calculate(ageYears: age)
        case .neonatal:
            guard let weight = Double(weightText), weight > 0 else { return nil }
            return ETTCalculator.neonatalSize(weightKg: weight)
        }
    }

    var body: some View {
        Form {
            Section {
                Picker(selection: $mode) {
                    ForEach(ETTMode.allCases) { m in
                        Text(LocalizedStringKey(m.nameKey)).tag(m)
                    }
                } label: {
                    Text("ett_mode")
                }
                .pickerStyle(.segmented)
            }

            Section {
                switch mode {
                case .ageBased:
                    NumberInputRow(labelKey: "ett_age_years", unitKey: "unit_years", value: $ageYearsText, range: 0.1...18)
                case .neonatal:
                    NumberInputRow(labelKey: "input_weight", unitKey: "unit_kg", value: $weightText, range: 0.1...300)
                }
            } header: {
                Text("ett_input")
            }

            if let result {
                Section {
                    row("ett_uncuffed", value: "\(formatSize(result.uncuffedSize)) mm")
                    row("ett_cuffed", value: "\(formatSize(result.cuffedSize)) mm")
                    row("ett_depth_oral", value: "\(formatSize(result.depthOralCm)) cm")
                    row("ett_depth_nasal", value: "\(formatSize(result.depthNasalCm)) cm")
                    row("ett_suction", value: "\(formatSize(result.suctionCatheterFr)) Fr")
                } header: {
                    Text("ett_results")
                }
            }

            ToolInfoSection(toolID: "ett")
        }
        .scrollDismissesKeyboard(.interactively)
        .modifier(KeyboardDoneButton())
        .safeAreaInset(edge: .bottom) {
            if let result {
                ResultBar {
                    HStack(spacing: 16) {
                        VStack(spacing: 2) {
                            Text("ett_uncuffed")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text("\(formatSize(result.uncuffedSize))")
                                .font(.subheadline.weight(.bold))
                        }
                        Divider().fixedSize(horizontal: false, vertical: true)
                        VStack(spacing: 2) {
                            Text("ett_cuffed")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text("\(formatSize(result.cuffedSize))")
                                .font(.subheadline.weight(.bold))
                                .foregroundStyle(.accent)
                        }
                        Divider().fixedSize(horizontal: false, vertical: true)
                        VStack(spacing: 2) {
                            Text("ett_depth_oral")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text("\(formatSize(result.depthOralCm)) cm")
                                .font(.subheadline.weight(.bold))
                        }
                    }
                }
                .padding(.bottom, 4)
            }
        }
        .navigationTitle("ett_title")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("reset_button") {
                    ageYearsText = ""
                    weightText = ""
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

    private func formatSize(_ n: Double) -> String {
        if n == n.rounded() { return String(format: "%.0f", n) }
        return String(format: "%.1f", n)
    }
}
