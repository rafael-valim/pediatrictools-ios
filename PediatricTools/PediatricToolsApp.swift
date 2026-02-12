import SwiftUI

@main
struct PediatricToolsApp: App {
    @AppStorage("appearance") private var appearance = "system"
    @AppStorage("language") private var language = "system"
    @AppStorage("disclaimerAccepted") private var disclaimerAccepted = false
    @State private var showDisclaimer = false

    private var colorScheme: ColorScheme? {
        switch appearance {
        case "light": return .light
        case "dark": return .dark
        default: return nil
        }
    }

    private var locale: Locale? {
        switch language {
        case "en": return Locale(identifier: "en")
        case "pt-BR": return Locale(identifier: "pt-BR")
        default: return nil
        }
    }

    var body: some Scene {
        WindowGroup {
            HomeView()
                .preferredColorScheme(colorScheme)
                .modifier(LocaleModifier(locale: locale))
                .alert("disclaimer_title", isPresented: $showDisclaimer) {
                    Button("disclaimer_accept") {
                        disclaimerAccepted = true
                    }
                } message: {
                    Text("disclaimer_message")
                }
                .onAppear {
                    if !disclaimerAccepted {
                        showDisclaimer = true
                    }
                }
        }
    }
}

private struct LocaleModifier: ViewModifier {
    let locale: Locale?

    func body(content: Content) -> some View {
        if let locale {
            content.environment(\.locale, locale)
        } else {
            content
        }
    }
}
