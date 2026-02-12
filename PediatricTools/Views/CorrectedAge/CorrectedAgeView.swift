import SwiftUI

struct CorrectedAgeView: View {
    @State private var birthDate = Date()
    @State private var gestationalWeeks = 28
    @State private var gestationalDays = 0

    private var result: CorrectedAgeCalculator.Result {
        CorrectedAgeCalculator.calculate(
            birthDate: birthDate,
            currentDate: Date(),
            gestationalAgeWeeks: gestationalWeeks,
            gestationalAgeDays: gestationalDays
        )
    }

    var body: some View {
        Form {
            Section {
                DatePicker(
                    String(localized: String.LocalizationValue("corrected_birth_date")),
                    selection: $birthDate,
                    in: ...Date(),
                    displayedComponents: .date
                )

                Picker(String(localized: String.LocalizationValue("corrected_ga_weeks")), selection: $gestationalWeeks) {
                    ForEach(22...42, id: \.self) { week in
                        Text("\(week)").tag(week)
                    }
                }

                Picker(String(localized: String.LocalizationValue("corrected_ga_days")), selection: $gestationalDays) {
                    ForEach(0...6, id: \.self) { day in
                        Text("\(day)").tag(day)
                    }
                }
            } header: {
                Text("corrected_input")
            }

            Section {
                row("corrected_chrono_age", value: "\(result.chronologicalAgeWeeks)w \(result.chronologicalAgeDays)d")
                row("corrected_prematurity", value: "\(result.prematurityWeeks) \(String(localized: String.LocalizationValue("unit_weeks")))")
                row("corrected_result", value: "\(result.correctedAgeWeeks)w \(result.correctedAgeDays)d")
            } header: {
                Text("corrected_results")
            }
        }
        .safeAreaInset(edge: .bottom) {
            ResultBar {
                HStack(spacing: 4) {
                    Text("corrected_age_label")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text("\(result.correctedAgeWeeks) \(String(localized: String.LocalizationValue("unit_weeks"))), \(result.correctedAgeDays) \(String(localized: String.LocalizationValue("unit_days")))")
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(.accent)
                }
            }
            .padding(.bottom, 4)
        }
        .navigationTitle("corrected_title")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func row(_ key: String, value: String) -> some View {
        HStack {
            Text(String(localized: String.LocalizationValue(key)))
            Spacer()
            Text(value).fontWeight(.medium)
        }
    }
}
