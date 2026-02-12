import SwiftUI

struct BPView: View {
    @State private var systolicText = ""
    @State private var diastolicText = ""
    @State private var ageYears = 5
    @State private var sex: Sex = .male
    @State private var heightPercentile: HeightPercentileCategory = .p50

    private var result: BPPercentileCalculator.Result? {
        guard let sys = Double(systolicText), sys > 0,
              let dia = Double(diastolicText), dia > 0 else { return nil }
        return BPPercentileCalculator.calculate(
            systolic: sys,
            diastolic: dia,
            ageYears: ageYears,
            sex: sex,
            heightPercentile: heightPercentile
        )
    }

    var body: some View {
        Form {
            Section {
                Picker(selection: $sex) {
                    ForEach(Sex.allCases) { s in
                        Text(LocalizedStringKey(s.localizedKey))
                            .tag(s)
                    }
                } label: {
                    Text("sex_label")
                }
                .pickerStyle(.segmented)
            }

            Section {
                Picker("bp_age", selection: $ageYears) {
                    ForEach(1...17, id: \.self) { age in
                        Text("\(age)").tag(age)
                    }
                }
                Picker("bp_height_percentile", selection: $heightPercentile) {
                    ForEach(HeightPercentileCategory.allCases) { hp in
                        Text(LocalizedStringKey(hp.localizedKey)).tag(hp)
                    }
                }
            }

            Section {
                NumberInputRow(labelKey: "bp_systolic", unitKey: "unit_mmhg", value: $systolicText, range: 40...250)
                NumberInputRow(labelKey: "bp_diastolic", unitKey: "unit_mmhg", value: $diastolicText, range: 20...200)
            }
        }
        .scrollDismissesKeyboard(.interactively)
        .safeAreaInset(edge: .bottom) {
            if let result {
                ResultBar {
                    HStack(spacing: 16) {
                        VStack(spacing: 2) {
                            Text("bp_sys_percentile")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text(String(format: "%.0f%%", result.systolicPercentile))
                                .font(.subheadline.weight(.bold))
                        }
                        Divider().fixedSize(horizontal: false, vertical: true)
                        VStack(spacing: 2) {
                            Text("bp_dia_percentile")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text(String(format: "%.0f%%", result.diastolicPercentile))
                                .font(.subheadline.weight(.bold))
                        }
                        Divider().fixedSize(horizontal: false, vertical: true)
                        Text(LocalizedStringKey(result.classification.localizedKey))
                            .font(.subheadline.weight(.bold))
                            .foregroundStyle(classificationColor(result.classification))
                    }
                }
                .padding(.bottom, 4)
            }
        }
        .navigationTitle("bp_title")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("reset_button") {
                    systolicText = ""
                    diastolicText = ""
                }
            }
        }
    }

    private func classificationColor(_ c: BPClassification) -> Color {
        switch c {
        case .normal: return .green
        case .elevated: return .yellow
        case .stageOneHTN: return .orange
        case .stageTwoHTN: return .red
        }
    }
}
