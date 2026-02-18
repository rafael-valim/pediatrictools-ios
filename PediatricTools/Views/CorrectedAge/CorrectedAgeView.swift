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
                    "corrected_birth_date",
                    selection: $birthDate,
                    in: ...Date(),
                    displayedComponents: .date
                )

                Picker("corrected_ga_weeks", selection: $gestationalWeeks) {
                    ForEach(22...42, id: \.self) { week in
                        Text("\(week)").tag(week)
                    }
                }

                Picker("corrected_ga_days", selection: $gestationalDays) {
                    ForEach(0...6, id: \.self) { day in
                        Text("\(day)").tag(day)
                    }
                }
            } header: {
                Text("corrected_input")
            }

            Section {
                row("corrected_chrono_age") {
                    Text("\(result.chronologicalAgeWeeks)w \(result.chronologicalAgeDays)d")
                }
                row("corrected_prematurity") {
                    Text("\(result.prematurityWeeks) ") + Text(LocalizedStringKey("unit_weeks"))
                }
                row("corrected_result") {
                    Text("\(result.correctedAgeWeeks)w \(result.correctedAgeDays)d")
                }
            } header: {
                Text("corrected_results")
            }

            ToolInfoSection(toolID: "corrected")
        }
        .scrollDismissesKeyboard(.interactively)
        .modifier(KeyboardDoneButton())
        .safeAreaInset(edge: .bottom) {
            ResultBar {
                HStack(spacing: 4) {
                    Text("corrected_age_label")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    (Text("\(result.correctedAgeWeeks) ") + Text(LocalizedStringKey("unit_weeks")) + Text(", \(result.correctedAgeDays) ") + Text(LocalizedStringKey("unit_days")))
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(.accent)
                }
            }
            .padding(.bottom, 4)
        }
        .navigationTitle("corrected_title")
        .navigationBarTitleDisplayMode(.inline)
        .modifier(ToolInfoToolbar(toolID: "corrected"))
    }

    private func row(_ key: String, @ViewBuilder value: () -> Text) -> some View {
        HStack {
            Text(LocalizedStringKey(key))
            Spacer()
            value().fontWeight(.medium)
        }
    }
}
