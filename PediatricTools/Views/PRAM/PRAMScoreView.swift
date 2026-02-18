import SwiftUI

struct PRAMScoreView: View {
    @State private var scores: [String: Int] = [:]

    private var total: Int {
        PRAMCriteria.all.reduce(0) { $0 + (scores[$1.id] ?? 0) }
    }

    var body: some View {
        Form {
            Section {
                ForEach(PRAMCriteria.all) { criterion in
                    ScoreSelectorRow(
                        nameKey: criterion.nameKey,
                        maxScore: criterion.maxScore,
                        descriptions: criterion.descriptions,
                        selectedScore: binding(for: criterion.id)
                    )
                }
            } header: {
                Text("pram_criteria")
            }

            ToolInfoSection(toolID: "pram")
        }
        .scrollDismissesKeyboard(.interactively)
        .safeAreaInset(edge: .bottom) {
            ResultBar {
                HStack(spacing: 16) {
                    VStack(spacing: 2) {
                        Text("result_total")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text("\(total)/12")
                            .font(.subheadline.weight(.bold))
                    }
                    Divider().fixedSize(horizontal: false, vertical: true)
                    Text(LocalizedStringKey(PRAMCalculator.interpretation(score: total)))
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(total <= 3 ? .green : total <= 7 ? .orange : .red)
                }
            }
            .padding(.bottom, 4)
        }
        .navigationTitle("pram_title")
        .navigationBarTitleDisplayMode(.inline)
        .modifier(ToolInfoToolbar(toolID: "pram"))
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
