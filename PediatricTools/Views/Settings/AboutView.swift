import SwiftUI

struct AboutView: View {
    @AppStorage("isSupporter") private var isSupporter = false

    private var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    }

    private var buildNumber: String {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
    }

    var body: some View {
        List {
            Section {
                VStack(spacing: 8) {
                    Image(systemName: "stethoscope")
                        .font(.system(size: 48))
                        .foregroundStyle(.accent)
                    HStack(spacing: 6) {
                        Text("app_title")
                            .font(.title2.weight(.bold))
                        if isSupporter {
                            Label("about_supporter_badge", systemImage: "heart.fill")
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 3)
                                .background(.pink, in: Capsule())
                        }
                    }
                    Text("about_version \(appVersion) (\(buildNumber))")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text("about_description")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
            }

            ForEach(ToolInfoCatalog.all) { tool in
                Section {
                    ForEach(tool.referenceKeys, id: \.self) { key in
                        Text(LocalizedStringKey(key))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    ForEach(tool.links) { link in
                        Link(destination: link.url) {
                            HStack {
                                Text(LocalizedStringKey(link.titleKey))
                                    .font(.subheadline)
                                Spacer()
                                Image(systemName: "arrow.up.right.square")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                } header: {
                    Text(LocalizedStringKey(toolTitleKey(for: tool.id)))
                }
            }
        }
        .navigationTitle("about_title")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func toolTitleKey(for id: String) -> String {
        switch id {
        case "ballard": return "ballard_score_title"
        case "bilirubin": return "bili_title"
        case "phoenix": return "phoenix_title"
        default: return "\(id)_title"
        }
    }
}
