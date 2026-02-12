import SwiftUI

struct AboutView: View {
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
                    Text("app_title")
                        .font(.title2.weight(.bold))
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

            Section {
                ForEach(references) { ref in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(LocalizedStringKey(ref.toolKey))
                            .font(.subheadline.weight(.medium))
                        Text(LocalizedStringKey(ref.referenceKey))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 2)
                }
            } header: {
                Text("about_references")
            }
        }
        .navigationTitle("about_title")
        .navigationBarTitleDisplayMode(.inline)
    }

    private struct ToolReference: Identifiable {
        let id: String
        let toolKey: String
        let referenceKey: String
    }

    private let references: [ToolReference] = [
        ToolReference(id: "ballard", toolKey: "ballard_score_title", referenceKey: "about_ref_ballard"),
        ToolReference(id: "apgar", toolKey: "apgar_title", referenceKey: "about_ref_apgar"),
        ToolReference(id: "pews", toolKey: "pews_title", referenceKey: "about_ref_pews"),
        ToolReference(id: "dosage", toolKey: "dosage_title", referenceKey: "about_ref_dosage"),
        ToolReference(id: "ivfluid", toolKey: "ivfluid_title", referenceKey: "about_ref_ivfluid"),
        ToolReference(id: "bsa", toolKey: "bsa_title", referenceKey: "about_ref_bsa"),
        ToolReference(id: "corrected", toolKey: "corrected_title", referenceKey: "about_ref_corrected"),
        ToolReference(id: "growth", toolKey: "growth_title", referenceKey: "about_ref_growth"),
        ToolReference(id: "dehydration", toolKey: "dehydration_title", referenceKey: "about_ref_dehydration"),
        ToolReference(id: "fena", toolKey: "fena_title", referenceKey: "about_ref_fena"),
        ToolReference(id: "ett", toolKey: "ett_title", referenceKey: "about_ref_ett"),
    ]
}
