import SwiftUI

struct BilirubinView: View {
    @State private var bilirubinText = ""
    @State private var ageHoursText = ""
    @State private var gaCategory: BilirubinGACategory = .term
    @State private var hasRiskFactors = false

    private var result: BilirubinCalculator.Result? {
        guard let bili = Double(bilirubinText), bili >= 0,
              let hours = Double(ageHoursText), hours >= 0 else { return nil }
        return BilirubinCalculator.calculate(
            bilirubinMgDL: bili,
            postnatalAgeHours: hours,
            gaCategory: gaCategory,
            hasRiskFactors: hasRiskFactors
        )
    }

    var body: some View {
        Form {
            Section {
                NumberInputRow(labelKey: "bili_tsbr", unitKey: "unit_mg_dl", value: $bilirubinText, range: 0...50)
                NumberInputRow(labelKey: "bili_age_hours", unitKey: "unit_hours", value: $ageHoursText, range: 0...168)
            }

            Section {
                Picker(selection: $gaCategory) {
                    ForEach(BilirubinGACategory.allCases) { cat in
                        Text(LocalizedStringKey(cat.localizedKey))
                            .tag(cat)
                    }
                } label: {
                    Text("bili_ga_category")
                }

                Toggle(isOn: $hasRiskFactors) {
                    VStack(alignment: .leading) {
                        Text("bili_risk_factors")
                        Text("bili_risk_factors_detail")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            } header: {
                Text("bili_risk_section")
            }

            ToolInfoSection(toolID: "bilirubin")
        }
        .scrollDismissesKeyboard(.interactively)
        .modifier(KeyboardDoneButton())
        .safeAreaInset(edge: .bottom) {
            if let result {
                ResultBar {
                    VStack(spacing: 6) {
                        HStack(spacing: 16) {
                            VStack(spacing: 2) {
                                Text("bili_photo_threshold")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                Text(String(format: "%.1f mg/dL", result.phototherapyThreshold))
                                    .font(.subheadline.weight(.bold))
                            }
                            Divider().fixedSize(horizontal: false, vertical: true)
                            VStack(spacing: 2) {
                                Text("bili_exchange_threshold")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                Text(String(format: "%.1f mg/dL", result.exchangeThreshold))
                                    .font(.subheadline.weight(.bold))
                            }
                        }
                        Text(LocalizedStringKey(result.interpretationKey))
                            .font(.subheadline.weight(.bold))
                            .foregroundStyle(result.exceedsExchange ? .red : result.exceedsPhototherapy ? .orange : .green)
                    }
                }
                .padding(.bottom, 4)
            }
        }
        .navigationTitle("bili_title")
        .navigationBarTitleDisplayMode(.inline)
        .modifier(ToolInfoToolbar(toolID: "bilirubin"))
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("reset_button") {
                    bilirubinText = ""
                    ageHoursText = ""
                    hasRiskFactors = false
                }
            }
        }
    }
}
