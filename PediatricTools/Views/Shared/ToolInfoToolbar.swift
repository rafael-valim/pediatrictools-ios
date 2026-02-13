import SwiftUI

struct ToolInfoToolbar: ViewModifier {
    let toolID: String
    @State private var showingInfo = false

    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        showingInfo = true
                    } label: {
                        Image(systemName: "info.circle")
                    }
                    .accessibilityLabel(Text("info_button_label"))
                }
            }
            .sheet(isPresented: $showingInfo) {
                if let info = ToolInfoCatalog.info(for: toolID) {
                    ToolInfoView(info: info)
                }
            }
    }
}
