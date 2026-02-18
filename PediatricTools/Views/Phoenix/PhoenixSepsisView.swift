import SwiftUI

struct PhoenixSepsisView: View {
    // Respiratory
    @State private var paoFioText = ""
    @State private var spoFioText = ""
    @State private var onInvasiveVent = false

    // Cardiovascular
    @State private var vasoactiveCount = 0
    @State private var lactateText = ""
    @State private var lowMAPForAge = false

    // Coagulation
    @State private var plateletsText = ""
    @State private var inrText = ""
    @State private var dDimerText = ""
    @State private var fibrinogenText = ""

    // Neurologic
    @State private var gcsScore = 15

    private var respScore: Int {
        let pf = Double(paoFioText)
        let sf = Double(spoFioText)
        return PhoenixSepsis.respiratoryScore(paoFioRatio: pf, spoFioRatio: pf == nil ? sf : nil, onInvasiveVent: onInvasiveVent)
    }

    private var cardioScore: Int {
        let lactate = Double(lactateText)
        return PhoenixSepsis.cardiovascularScore(vasoactiveCount: vasoactiveCount, lactateMmol: lactate, mapForAge: !lowMAPForAge)
    }

    private var coagScore: Int {
        let plt = Double(plateletsText)
        let inr = Double(inrText)
        let dd = Double(dDimerText)
        let fib = Double(fibrinogenText)
        return PhoenixSepsis.coagulationScore(platelets: plt, inr: inr, dDimer: dd, fibrinogen: fib)
    }

    private var neuroScore: Int {
        PhoenixSepsis.neurologicScore(gcs: gcsScore)
    }

    private var result: PhoenixSepsis.Result {
        PhoenixSepsis.calculate(
            respiratoryScore: respScore,
            cardiovascularScore: cardioScore,
            coagulationScore: coagScore,
            neurologicScore: neuroScore
        )
    }

    var body: some View {
        Form {
            // Respiratory
            Section {
                NumberInputRow(labelKey: "phoenix_pao_fio", unitKey: "phoenix_ratio", value: $paoFioText, range: 0...700)
                NumberInputRow(labelKey: "phoenix_spo_fio", unitKey: "phoenix_ratio", value: $spoFioText, range: 0...500)
                Toggle("phoenix_invasive_vent", isOn: $onInvasiveVent)
            } header: {
                HStack {
                    Text("phoenix_respiratory")
                    Spacer()
                    Text("\(respScore)/3")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            // Cardiovascular
            Section {
                Picker("phoenix_vasoactives", selection: $vasoactiveCount) {
                    Text("0").tag(0)
                    Text("1").tag(1)
                    Text("≥2").tag(2)
                }
                NumberInputRow(labelKey: "phoenix_lactate", unitKey: "unit_mmol_l", value: $lactateText, range: 0...30)
                Toggle("phoenix_low_map", isOn: $lowMAPForAge)
            } header: {
                HStack {
                    Text("phoenix_cardiovascular")
                    Spacer()
                    Text("\(cardioScore)/6")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            // Coagulation
            Section {
                NumberInputRow(labelKey: "phoenix_platelets", unitKey: "phoenix_unit_thousand", value: $plateletsText, range: 0...1000)
                NumberInputRow(labelKey: "phoenix_inr", unitKey: "", value: $inrText, range: 0...20)
                NumberInputRow(labelKey: "phoenix_d_dimer", unitKey: "unit_mg_l", value: $dDimerText, range: 0...100)
                NumberInputRow(labelKey: "phoenix_fibrinogen", unitKey: "unit_mg_dl", value: $fibrinogenText, range: 0...1000)
            } header: {
                HStack {
                    Text("phoenix_coagulation")
                    Spacer()
                    Text("\(coagScore)/2")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            // Neurologic
            Section {
                Picker("phoenix_gcs", selection: $gcsScore) {
                    ForEach(3...15, id: \.self) { score in
                        Text("\(score)").tag(score)
                    }
                }
            } header: {
                HStack {
                    Text("phoenix_neurologic")
                    Spacer()
                    Text("\(neuroScore)/2")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            ToolInfoSection(toolID: "phoenix")
        }
        .scrollDismissesKeyboard(.interactively)
        .modifier(KeyboardDoneButton())
        .safeAreaInset(edge: .bottom) {
            ResultBar {
                HStack(spacing: 16) {
                    VStack(spacing: 2) {
                        Text("result_total")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text("\(result.totalScore)/13")
                            .font(.subheadline.weight(.bold))
                    }
                    Divider().fixedSize(horizontal: false, vertical: true)
                    Text(LocalizedStringKey(result.interpretationKey))
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(result.isSepticShock ? .red : result.isSepsis ? .orange : .green)
                }
            }
            .padding(.bottom, 4)
        }
        .navigationTitle("phoenix_title")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("reset_button") { reset() }
            }
        }
    }

    private func reset() {
        paoFioText = ""
        spoFioText = ""
        onInvasiveVent = false
        vasoactiveCount = 0
        lactateText = ""
        lowMAPForAge = false
        plateletsText = ""
        inrText = ""
        dDimerText = ""
        fibrinogenText = ""
        gcsScore = 15
    }
}
