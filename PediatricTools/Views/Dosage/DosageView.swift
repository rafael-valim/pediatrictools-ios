import SwiftUI

struct DosageView: View {
    @State private var weightText = ""
    @State private var selectedMedication: Medication?
    @State private var selectedConcentration: MedicationConcentration?

    private var weightKg: Double { Double(weightText) ?? 0 }

    private var result: PediatricDosageCalculator.DoseResult? {
        guard let med = selectedMedication, weightKg > 0 else { return nil }
        return PediatricDosageCalculator.calculate(
            medication: med,
            weightKg: weightKg,
            concentration: selectedConcentration
        )
    }

    var body: some View {
        Form {
            Section {
                NumberInputRow(labelKey: "input_weight", unitKey: "unit_kg", value: $weightText, range: 0.1...300)
            }

            Section {
                ForEach(Medications.all) { med in
                    Button {
                        selectedMedication = med
                        selectedConcentration = nil
                    } label: {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(LocalizedStringKey(med.nameKey))
                                    .font(.subheadline.weight(.medium))
                                (Text("\(formatNumber(med.dosePerKg))–\(formatNumber(med.maxDosePerKg)) mg/kg  ") + Text(LocalizedStringKey(med.frequencyKey)))
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            if selectedMedication?.id == med.id {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(.accent)
                            }
                        }
                    }
                    .foregroundStyle(.primary)
                }
            } header: {
                Text("dosage_select_medication")
            }

            if let med = selectedMedication {
                Section {
                    ForEach(med.concentrations) { conc in
                        Button {
                            selectedConcentration = conc
                        } label: {
                            HStack {
                                Text(LocalizedStringKey(conc.labelKey))
                                Spacer()
                                if selectedConcentration?.id == conc.id {
                                    Image(systemName: "checkmark")
                                        .foregroundStyle(.accent)
                                }
                            }
                        }
                        .foregroundStyle(.primary)
                    }
                } header: {
                    Text("dosage_concentration")
                }
            }

            ToolInfoSection(toolID: "dosage")
        }
        .scrollDismissesKeyboard(.interactively)
        .modifier(KeyboardDoneButton())
        .safeAreaInset(edge: .bottom) {
            if let result, let med = selectedMedication {
                ResultBar {
                    if result.lowDoseMg == result.highDoseMg {
                        (Text("\(formatNumber(result.lowDoseMg)) mg ") + Text(LocalizedStringKey(med.frequencyKey)))
                            .font(.subheadline.weight(.bold))
                            .foregroundStyle(.accent)
                    } else {
                        (Text("\(formatNumber(result.lowDoseMg))–\(formatNumber(result.highDoseMg)) mg ") + Text(LocalizedStringKey(med.frequencyKey)))
                            .font(.subheadline.weight(.bold))
                            .foregroundStyle(.accent)
                    }
                    if result.cappedHigh {
                        Text("dosage_max_reached")
                            .font(.caption)
                            .foregroundStyle(.orange)
                    }
                    if let vol = result.volumeMl, let volHigh = result.volumeHighMl {
                        if vol == volHigh {
                            Text("dosage_volume \(formatNumber(vol))")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        } else {
                            Text("dosage_volume_range \(formatNumber(vol)) \(formatNumber(volHigh))")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .padding(.bottom, 4)
            }
        }
        .navigationTitle("dosage_title")
        .navigationBarTitleDisplayMode(.inline)
        .modifier(ToolInfoToolbar(toolID: "dosage"))
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("reset_button") {
                    weightText = ""
                    selectedMedication = nil
                    selectedConcentration = nil
                }
            }
        }
    }

    private func formatNumber(_ n: Double) -> String {
        if n == n.rounded() { return String(format: "%.0f", n) }
        return String(format: "%.1f", n)
    }
}
