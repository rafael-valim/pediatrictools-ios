import SwiftUI

struct SettingsView: View {
    @AppStorage("appearance") private var appearance = "system"
    @AppStorage("language") private var language = "system"
    @AppStorage("fontSize") private var fontSize = "system"
    @AppStorage("portraitLock") private var portraitLock = false
    @Environment(TipJarManager.self) private var tipJarManager

    var body: some View {
        Form {
            Section {
                Picker("settings_appearance", selection: $appearance) {
                    Text("settings_system").tag("system")
                    Text("settings_light").tag("light")
                    Text("settings_dark").tag("dark")
                }
                .pickerStyle(.segmented)
            } header: {
                Text("settings_appearance_section")
            }

            Section {
                Picker("settings_language", selection: $language) {
                    Text("settings_system").tag("system")
                    Text("settings_english").tag("en")
                    Text("settings_portuguese").tag("pt-BR")
                    Text("settings_spanish").tag("es")
                    Text("settings_french").tag("fr")
                }
            } header: {
                Text("settings_language_section")
            }

            Section {
                Picker("settings_font_size", selection: $fontSize) {
                    Text("font_size_system").tag("system")
                    Text("font_size_xsmall").tag("xSmall")
                    Text("font_size_small").tag("small")
                    Text("font_size_medium").tag("medium")
                    Text("font_size_large").tag("large")
                    Text("font_size_xlarge").tag("xLarge")
                    Text("font_size_xxlarge").tag("xxLarge")
                    Text("font_size_xxxlarge").tag("xxxLarge")
                }
            } header: {
                Text("settings_font_size_section")
            }

            Section {
                Toggle("settings_portrait_lock", isOn: $portraitLock)
                    .accessibilityIdentifier("settings_portrait_lock")
            } header: {
                Text("settings_orientation_section")
            }

            Section {
                NavigationLink {
                    TipJarView()
                } label: {
                    Label("settings_support", systemImage: "heart.fill")
                }
                Button {
                    Task { await tipJarManager.checkExistingPurchases() }
                } label: {
                    Label("tipjar_restore", systemImage: "arrow.clockwise")
                }
            } header: {
                Text("settings_support_section")
            }

            Section {
                NavigationLink {
                    AboutView()
                } label: {
                    Label("settings_about", systemImage: "info.circle")
                }
            }
        }
        .navigationTitle("settings_title")
        .navigationBarTitleDisplayMode(.inline)
    }
}
