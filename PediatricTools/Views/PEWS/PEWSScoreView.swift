import SwiftUI

struct PEWSScoreView: View {
    @State private var scores: [String: Int] = [:]

    private var total: Int {
        PEWSCriteria.all.reduce(0) { $0 + (scores[$1.id] ?? 0) }
    }

    var body: some View {
        Form {
            Section {
                ForEach(PEWSCriteria.all) { criterion in
                    ScoreSelectorRow(
                        nameKey: criterion.nameKey,
                        maxScore: criterion.maxScore,
                        descriptions: criterion.descriptions,
                        selectedScore: binding(for: criterion.id)
                    )
                }
            } header: {
                Text("pews_criteria")
            }

            ToolInfoSection(toolID: "pews")
        }
        .scrollDismissesKeyboard(.interactively)
        .safeAreaInset(edge: .bottom) {
            ResultBar {
                HStack(spacing: 16) {
                    VStack(spacing: 2) {
                        Text("result_total")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text("\(total)/9")
                            .font(.subheadline.weight(.bold))
                    }
                    Divider().fixedSize(horizontal: false, vertical: true)
                    Text(LocalizedStringKey(PEWSCalculator.interpretation(score: total)))
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(total <= 2 ? .green : total <= 4 ? .orange : .red)
                }
            }
            .padding(.bottom, 4)
        }
        .navigationTitle("pews_title")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("reset_button") { scores = [:] }
            }
        }
    }

    private func binding(for key: String) -> Binding<Int> {
        Binding(
            get: { scores[key] ?? 0 },
            set: { scores[key] = $0 }
        )
    }
}
