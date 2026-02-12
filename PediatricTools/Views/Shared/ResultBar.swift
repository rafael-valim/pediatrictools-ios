import SwiftUI

/// A generic bottom result bar matching the Ballard result view style.
struct ResultBar<Content: View>: View {
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(spacing: 6) {
            content()
        }
        .padding(12)
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.1), radius: 4, y: -2)
        .padding(.horizontal)
    }
}
