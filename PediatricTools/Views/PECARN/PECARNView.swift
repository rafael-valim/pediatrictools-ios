import SwiftUI

struct PECARNView: View {
    @State private var ageGroup: PECARNAgeGroup = .twoAndOver
    @State private var positiveCriteria: Set<String> = []

    private var criteria: [PECARNCriterion] {
        PECARNCriteria.criteria(for: ageGroup)
    }

    private var risk: PECARNRisk {
        PECARNCalculator.evaluate(ageGroup: ageGroup, positiveCriteria: positiveCriteria)
    }

    var body: some View {
        Form {
            Section {
                Picker(selection: $ageGroup) {
                    ForEach(PECARNAgeGroup.allCases) { group in
                        Text(LocalizedStringKey(group.localizedKey))
                            .tag(group)
                    }
                } label: {
                    Text("pecarn_age_group")
                }
                .pickerStyle(.segmented)
                .onChange(of: ageGroup) {
                    positiveCriteria = []
                }
            }

            Section {
                ForEach(criteria) { criterion in
                    Toggle(isOn: toggleBinding(for: criterion.id)) {
                        VStack(alignment: .leading) {
                            Text(LocalizedStringKey(criterion.nameKey))
                            if let detail = criterion.detailKey {
                                Text(LocalizedStringKey(detail))
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            } header: {
                Text("pecarn_criteria")
            }

            ToolInfoSection(toolID: "pecarn")
        }
        .scrollDismissesKeyboard(.interactively)
        .modifier(KeyboardDoneButton())
        .safeAreaInset(edge: .bottom) {
            ResultBar {
                VStack(spacing: 4) {
                    Text(LocalizedStringKey(risk.localizedKey))
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(riskColor)
                    Text(LocalizedStringKey(risk.recommendationKey))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
            }
            .padding(.bottom, 4)
        }
        .navigationTitle("pecarn_title")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("reset_button") { positiveCriteria = [] }
            }
        }
    }

    private var riskColor: Color {
        switch risk {
        case .veryLow: return .green
        case .intermediate: return .orange
        case .higher: return .red
        }
    }

    private func toggleBinding(for id: String) -> Binding<Bool> {
        Binding(
            get: { positiveCriteria.contains(id) },
            set: { isOn in
                if isOn {
                    positiveCriteria.insert(id)
                } else {
                    positiveCriteria.remove(id)
                }
            }
        )
    }
}
