import SwiftUI

struct QTcView: View {
    @State private var qtText = ""
    @State private var hrText = ""
    @State private var sex: Sex = .male

    private var result: QTcCalculator.Result? {
        guard let qt = Double(qtText), qt > 0,
              let hr = Double(hrText), hr > 0 else { return nil }
        return QTcCalculator.calculate(qtInterval: qt, heartRate: hr, sex: sex)
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
                NumberInputRow(labelKey: "qtc_qt_interval", unitKey: "unit_ms", value: $qtText, range: 100...800)
                NumberInputRow(labelKey: "qtc_heart_rate", unitKey: "unit_bpm", value: $hrText, range: 30...300)
            }

            Section {
                Text("qtc_formula_explanation")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            } header: {
                Text("qtc_formula")
            }

            ToolInfoSection(toolID: "qtc")
        }
        .scrollDismissesKeyboard(.interactively)
        .modifier(KeyboardDoneButton())
        .safeAreaInset(edge: .bottom) {
            if let result {
                ResultBar {
                    HStack(spacing: 16) {
                        VStack(spacing: 2) {
                            Text("qtc_result")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text(String(format: "%.0f ms", result.qtc))
                                .font(.subheadline.weight(.bold))
                        }
                        Divider().fixedSize(horizontal: false, vertical: true)
                        Text(LocalizedStringKey(result.interpretationKey))
                            .font(.subheadline.weight(.bold))
                            .foregroundStyle(result.qtc < 440 ? .green : result.qtc < (sex == .male ? 460 : 470) ? .orange : .red)
                    }
                }
                .padding(.bottom, 4)
            }
        }
        .navigationTitle("qtc_title")
        .navigationBarTitleDisplayMode(.inline)
        .modifier(ToolInfoToolbar(toolID: "qtc"))
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("reset_button") {
                    qtText = ""
                    hrText = ""
                }
            }
        }
    }
}
