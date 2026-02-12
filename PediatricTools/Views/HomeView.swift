import SwiftUI

private struct ToolItem: Identifiable {
    let id: String
    let titleKey: String
    let subtitleKey: String
    let icon: String
    let destination: AnyView
}

struct HomeView: View {
    @AppStorage("language") private var language = "system"

    private let tools: [ToolItem] = [
        ToolItem(id: "ballard", titleKey: "ballard_score_title", subtitleKey: "ballard_score_subtitle", icon: "calendar.badge.clock", destination: AnyView(BallardScoreView())),
        ToolItem(id: "apgar", titleKey: "apgar_title", subtitleKey: "apgar_subtitle", icon: "heart.text.clipboard", destination: AnyView(ApgarScoreView())),
        ToolItem(id: "dosage", titleKey: "dosage_title", subtitleKey: "dosage_subtitle", icon: "pills", destination: AnyView(DosageView())),
        ToolItem(id: "ivfluid", titleKey: "ivfluid_title", subtitleKey: "ivfluid_subtitle", icon: "ivfluid.bag", destination: AnyView(IVFluidView())),
        ToolItem(id: "bsa", titleKey: "bsa_title", subtitleKey: "bsa_subtitle", icon: "figure.stand", destination: AnyView(BSAView())),
        ToolItem(id: "corrected", titleKey: "corrected_title", subtitleKey: "corrected_subtitle", icon: "calendar", destination: AnyView(CorrectedAgeView())),
        ToolItem(id: "pews", titleKey: "pews_title", subtitleKey: "pews_subtitle", icon: "waveform.path.ecg", destination: AnyView(PEWSScoreView())),
        ToolItem(id: "growth", titleKey: "growth_title", subtitleKey: "growth_subtitle", icon: "chart.line.uptrend.xyaxis", destination: AnyView(GrowthPercentileView())),
        ToolItem(id: "dehydration", titleKey: "dehydration_title", subtitleKey: "dehydration_subtitle", icon: "drop.triangle", destination: AnyView(DehydrationView())),
        ToolItem(id: "fena", titleKey: "fena_title", subtitleKey: "fena_subtitle", icon: "testtube.2", destination: AnyView(FENaView())),
        ToolItem(id: "ett", titleKey: "ett_title", subtitleKey: "ett_subtitle", icon: "lungs", destination: AnyView(ETTView())),
    ]

    private func localizedString(_ key: String) -> String {
        guard language != "system",
              let path = Bundle.main.path(forResource: language, ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            return NSLocalizedString(key, comment: "")
        }
        return NSLocalizedString(key, bundle: bundle, comment: "")
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(tools) { tool in
                    NavigationLink {
                        tool.destination
                    } label: {
                        Label {
                            VStack(alignment: .leading) {
                                Text(LocalizedStringKey(tool.titleKey))
                                    .font(.headline)
                                Text(LocalizedStringKey(tool.subtitleKey))
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        } icon: {
                            Image(systemName: tool.icon)
                                .foregroundStyle(.accent)
                                .font(.title2)
                        }
                    }
                    .accessibilityIdentifier(tool.id)
                }

                Section {
                    Text("disclaimer_home_label")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle(localizedString("app_title"))
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        SettingsView()
                    } label: {
                        Image(systemName: "gearshape")
                    }
                }
            }
        }
        .id(language)
    }
}

#Preview {
    HomeView()
}
