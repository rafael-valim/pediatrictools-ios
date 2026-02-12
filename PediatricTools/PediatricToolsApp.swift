import SwiftUI

@main
struct PediatricToolsApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @AppStorage("appearance") private var appearance = "system"
    @AppStorage("language") private var language = "system"
    @AppStorage("disclaimerAccepted") private var disclaimerAccepted = false
    @AppStorage("portraitLock") private var portraitLock = false
    @State private var showDisclaimer = false
    @State private var tipJarManager = TipJarManager()

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
        case "es": return Locale(identifier: "es")
        case "fr": return Locale(identifier: "fr")
        default: return nil
        }
    }

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(tipJarManager)
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
                    applyOrientationLock(portraitLock)
                }
                .onChange(of: portraitLock) { _, newValue in
                    applyOrientationLock(newValue)
                }
        }
    }

    private func applyOrientationLock(_ locked: Bool) {
        AppDelegate.orientationLock = locked ? .portrait : .allButUpsideDown
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        windowScene.windows.first?.rootViewController?.setNeedsUpdateOfSupportedInterfaceOrientations()
        if locked {
            windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: .portrait))
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
