import SwiftUI

struct ToolInfoView: View {
    let info: ToolInfoData
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Text(LocalizedStringKey(info.overviewKey))
                        .font(.subheadline)
                } header: {
                    Text("info_overview")
                }

                if !info.parameters.isEmpty {
                    Section {
                        ForEach(info.parameters) { param in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(LocalizedStringKey(param.nameKey))
                                    .font(.subheadline.weight(.medium))
                                Text(LocalizedStringKey(param.descriptionKey))
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.vertical, 2)
                        }
                    } header: {
                        Text("info_parameters")
                    }
                }

                Section {
                    Text(LocalizedStringKey(info.interpretationKey))
                        .font(.subheadline)
                } header: {
                    Text("info_interpretation")
                }

                if !info.referenceKeys.isEmpty {
                    Section {
                        ForEach(info.referenceKeys, id: \.self) { key in
                            Text(LocalizedStringKey(key))
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    } header: {
                        Text("info_references")
                    }
                }

                if !info.links.isEmpty {
                    Section {
                        ForEach(info.links) { link in
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
                        Text("info_links")
                    }
                }
            }
            .navigationTitle("info_title")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("info_done") { dismiss() }
                }
            }
        }
    }
}
