import SwiftUI

struct SettingsView: View {
    @AppStorage("appearance") private var appearance = "system"
    @AppStorage("language") private var language = "system"
    @AppStorage("portraitLock") private var portraitLock = false

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
                Toggle("settings_portrait_lock", isOn: $portraitLock)
            } header: {
                Text("settings_orientation_section")
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
