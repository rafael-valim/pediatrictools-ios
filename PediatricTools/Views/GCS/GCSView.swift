import SwiftUI

struct GCSView: View {
    @State private var ageGroup: GCSAgeGroup = .child
    @State private var scores: [String: Int] = [:]

    private var criteria: [GCSCriterion] {
        GCSCriteria.criteria(for: ageGroup)
    }

    private var total: Int {
        criteria.reduce(0) { $0 + (scores[$1.id] ?? $1.minScore) }
    }

    var body: some View {
        Form {
            Section {
                Picker(selection: $ageGroup) {
                    ForEach(GCSAgeGroup.allCases) { group in
                        Text(LocalizedStringKey(group.localizedKey))
                            .tag(group)
                    }
                } label: {
                    Text("gcs_age_group")
                }
                .pickerStyle(.segmented)
                .onChange(of: ageGroup) {
                    scores.removeValue(forKey: "verbal")
                }
            }

            Section {
                ForEach(criteria) { criterion in
                    ScoreSelectorRow(
                        nameKey: criterion.nameKey,
                        maxScore: criterion.maxScore,
                        descriptions: criterion.descriptions,
                        selectedScore: binding(for: criterion.id, minScore: criterion.minScore),
                        minScore: criterion.minScore
                    )
                }
            } header: {
                Text("gcs_criteria")
            }
        }
        .scrollDismissesKeyboard(.interactively)
        .safeAreaInset(edge: .bottom) {
            ResultBar {
                HStack(spacing: 16) {
                    VStack(spacing: 2) {
                        Text("result_total")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text("\(total)/15")
                            .font(.subheadline.weight(.bold))
                    }
                    Divider().fixedSize(horizontal: false, vertical: true)
                    Text(LocalizedStringKey(GCSCalculator.interpretation(score: total)))
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(total >= 13 ? .green : total >= 9 ? .orange : .red)
                }
            }
            .padding(.bottom, 4)
        }
        .navigationTitle("gcs_title")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("reset_button") { scores = [:] }
            }
        }
    }

    private func binding(for key: String, minScore: Int) -> Binding<Int> {
        Binding(
            get: { scores[key] ?? minScore },
            set: { scores[key] = $0 }
        )
    }
}
