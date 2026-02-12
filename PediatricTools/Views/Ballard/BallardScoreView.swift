import SwiftUI

struct BallardScoreView: View {
    @State private var sex: Sex = .male
    @State private var neuromuscularScores: [String: Int] = [:]
    @State private var physicalScores: [String: Int] = [:]

    private var neuromuscularTotal: Int {
        BallardCriteria.neuromuscular.reduce(0) { $0 + (neuromuscularScores[$1.id] ?? 0) }
    }

    private var physicalTotal: Int {
        BallardCriteria.physical(for: sex).reduce(0) { $0 + (physicalScores[$1.id] ?? 0) }
    }

    var body: some View {
        Form {
            // Sex picker
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
                .onChange(of: sex) {
                    // Reset genital scores when sex changes
                    physicalScores.removeValue(forKey: BallardCriteria.genitalsMale.id)
                    physicalScores.removeValue(forKey: BallardCriteria.genitalsFemale.id)
                }
            }

            // Neuromuscular maturity
            Section {
                ForEach(BallardCriteria.neuromuscular) { criterion in
                    BallardCriterionRow(
                        criterion: criterion,
                        selectedScore: neuromuscularBinding(for: criterion.id)
                    )
                }
            } header: {
                Text("section_neuromuscular")
            }

            // Physical maturity
            Section {
                ForEach(BallardCriteria.physical(for: sex)) { criterion in
                    BallardCriterionRow(
                        criterion: criterion,
                        selectedScore: physicalBinding(for: criterion.id)
                    )
                }
            } header: {
                Text("section_physical")
            }
        }
        .scrollDismissesKeyboard(.interactively)
        .safeAreaInset(edge: .bottom) {
            BallardResultView(
                neuromuscularScore: neuromuscularTotal,
                physicalScore: physicalTotal
            )
            .padding(.bottom, 4)
        }
        .navigationTitle("ballard_score_title")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("reset_button") {
                    reset()
                }
            }
        }
    }

    private func reset() {
        neuromuscularScores = [:]
        physicalScores = [:]
    }

    private func neuromuscularBinding(for key: String) -> Binding<Int> {
        Binding(
            get: { neuromuscularScores[key] ?? 0 },
            set: { neuromuscularScores[key] = $0 }
        )
    }

    private func physicalBinding(for key: String) -> Binding<Int> {
        Binding(
            get: { physicalScores[key] ?? 0 },
            set: { physicalScores[key] = $0 }
        )
    }
}

#Preview {
    NavigationStack {
        BallardScoreView()
    }
}
