import SwiftUI

struct ToolInfoSection: View {
    let toolID: String
    @State private var showingInfo = false

    var body: some View {
        if let info = ToolInfoCatalog.info(for: toolID) {
            Section {
                Button {
                    showingInfo = true
                } label: {
                    Label {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("info_section_title")
                                .font(.subheadline.weight(.medium))
                            Text("info_section_subtitle")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    } icon: {
                        Image(systemName: "book.closed")
                            .foregroundStyle(.accent)
                    }
                }
                .sheet(isPresented: $showingInfo) {
                    ToolInfoView(info: info)
                }
            }
        }
    }
}
