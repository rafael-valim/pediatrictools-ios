import SwiftUI

struct FLACCScoreView: View {
    @State private var scores: [String: Int] = [:]

    private var total: Int {
        FLACCCriteria.all.reduce(0) { $0 + (scores[$1.id] ?? 0) }
    }

    var body: some View {
        Form {
            Section {
                ForEach(FLACCCriteria.all) { criterion in
                    ScoreSelectorRow(
                        nameKey: criterion.nameKey,
                        maxScore: 2,
                        descriptions: criterion.descriptions,
                        selectedScore: binding(for: criterion.id)
                    )
                }
            } header: {
                Text("flacc_criteria")
            }

            ToolInfoSection(toolID: "flacc")
        }
        .scrollDismissesKeyboard(.interactively)
        .safeAreaInset(edge: .bottom) {
            ResultBar {
                HStack(spacing: 16) {
                    VStack(spacing: 2) {
                        Text("result_total")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text("\(total)/10")
                            .font(.subheadline.weight(.bold))
                    }
                    Divider().fixedSize(horizontal: false, vertical: true)
                    Text(LocalizedStringKey(FLACCCalculator.interpretation(score: total)))
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(total == 0 ? .green : total <= 3 ? .yellow : total <= 6 ? .orange : .red)
                }
            }
            .padding(.bottom, 4)
        }
        .navigationTitle("flacc_title")
        .navigationBarTitleDisplayMode(.inline)
        .modifier(ToolInfoToolbar(toolID: "flacc"))
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
