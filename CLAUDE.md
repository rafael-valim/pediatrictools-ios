# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build & Test Commands

```bash
# Build
xcodebuild build -scheme PediatricTools -destination 'platform=iOS Simulator,name=iPhone 17 Pro'

# Run all unit tests
xcodebuild test -scheme PediatricTools -destination 'platform=iOS Simulator,name=iPhone 17 Pro' -only-testing:PediatricToolsTests

# Run a single unit test file
xcodebuild test -scheme PediatricTools -destination 'platform=iOS Simulator,name=iPhone 17 Pro' -only-testing:PediatricToolsTests/ApgarScoreTests

# Run a single test method
xcodebuild test -scheme PediatricTools -destination 'platform=iOS Simulator,name=iPhone 17 Pro' -only-testing:PediatricToolsTests/ApgarScoreTests/testScore10IsNormal

# Regenerate screenshots (run after ANY view change)
./scripts/take-screenshots.sh

# Generate App Store screenshots (iPhone 17 Pro Max + iPad Pro 13")
./scripts/take-appstore-screenshots.sh

# Bump build number (required before every App Store Connect submission)
cd PediatricTools.xcodeproj/.. && agvtool next-version -all

# Fastlane lanes
bundle exec fastlane screenshots       # App Store screenshots
bundle exec fastlane build             # Archive .ipa
bundle exec fastlane upload_metadata   # Push metadata to App Store Connect
bundle exec fastlane upload_screenshots # Upload screenshots to App Store Connect
bundle exec fastlane upload_binary     # Upload existing .ipa to TestFlight
bundle exec fastlane build_and_upload  # Build + upload to TestFlight
bundle exec fastlane release           # Full pipeline: build → upload → deliver → submit

# View local metadata
./scripts/show-metadata.sh
```

## Architecture

**iOS 17+ / Swift 5 / SwiftUI-only / zero external dependencies.**

### Models (pure logic, no UI)
All models are **stateless `enum` namespaces** with `static` functions. They never import SwiftUI. Calculation functions take raw values and return numeric results. Interpretation functions return **localization keys** (not user-facing strings).

### Views (`@State` only)
Views use `@State` exclusively — no view models, no Combine, no ObservableObject (except TipJarManager which uses `@Observable`). Each tool view is a `Form` with:
- `NumberInputRow` for numeric inputs (with optional `range` for red-highlight validation)
- `ScoreSelectorRow` for criteria-based scoring tools (Apgar, PEWS)
- `ResultBar` as a `.safeAreaInset(edge: .bottom)` overlay for results
- `.scrollDismissesKeyboard(.interactively)` on every Form

### Navigation
`HomeView` uses `NavigationStack` with a `List` of `NavigationLink`. Each tool is registered as a `ToolItem` in the `tools` array. The view rebuilds when language changes via `.id(language)`.

### Settings & Preferences
Four `@AppStorage` preferences: `"appearance"` (system/light/dark), `"language"` (system/en/pt-BR/es/fr), `"portraitLock"` (bool), `"disclaimerAccepted"` (bool). Orientation lock is applied via `AppDelegate.orientationLock` and skipped during UI tests when `-UITesting` is present in launch arguments.

### Tip Jar (StoreKit 2)
`TipJarManager` uses `@Observable` (the only exception to the @State-only pattern). Three product IDs: `com.RV.pediatrictools.app.tip.{small,medium,large}`. Supporter status is persisted in `UserDefaults`. The StoreKit config file is `Resources/TipJar.storekit`.

### Privacy Manifest
`Resources/PrivacyInfo.xcprivacy` declares UserDefaults access (CA92.1), no tracking, no data collection. Required by Apple since 2024.

### Localization
Four languages: **en** (source), **pt-BR**, **es**, **fr**. All strings go through `Localizable.xcstrings` (Xcode String Catalog). Use `LocalizedStringKey` (not `String(localized:)`) so SwiftUI text views react to in-app locale changes via `.environment(\.locale)`. Keys use snake_case: `"apgar_title"`, `"ballard_posture_0"`. Language is applied at the root view via a `LocaleModifier` that sets `.environment(\.locale)`.

## Adding a New Tool

1. Create model in `Models/` — pure `enum` with `static` functions
2. Create view in `Views/<ToolName>/` — `Form`-based, `@State`-only, using shared components
3. Add localization keys to `Localizable.xcstrings` for all 4 languages
4. Register in `HomeView.swift` by adding a `ToolItem` to the `tools` array
5. Write unit tests in `PediatricToolsTests/`
6. Write screenshot tests in `PediatricToolsUITests/` (subclass `ScreenshotTestCase`)
7. Update `project.pbxproj` — add files to PBXBuildFile, PBXFileReference, PBXGroup, PBXSourcesBuildPhase for the correct targets

## Testing Patterns

**Unit tests** verify formulas, edge cases, clamping, and interpretation thresholds. One test file per model.

**UI screenshot tests** subclass `ScreenshotTestCase`, which provides:
- `navigateToTool(id:)` — finds and taps a tool link from the home screen
- `takeScreenshot(named:subfolder:)` — saves to `Screenshots/{subfolder}/` on disk
- `navigateToSettings()` / `navigateBack()` — navigation helpers
- App launches with `-UITesting -disclaimerAccepted 1` to skip the disclaimer and disable orientation lock

Each screenshot test captures **empty** and **filled** states.

## App Store Submission

**Before every build submission:** bump the build number with `agvtool next-version -all`, then commit.

**App Store screenshots** show 10 screens per device (Home + Settings + 8 features in filled state): Apgar, Bilirubin, Dosage, Growth, BP, GCS, PEWS, PECARN. Regenerate with `./scripts/take-appstore-screenshots.sh` after any view change.

The project uses Fastlane for App Store automation. Key files:

- **`Gemfile`** — Fastlane dependency (`bundle install` to set up)
- **`fastlane/Appfile`** — app identifier (`com.RV.pediatrictools.app`) + team ID (`CJXZNY36RV`)
- **`fastlane/Fastfile`** — lanes: `screenshots`, `build`, `upload_metadata`, `upload_screenshots`, `upload_binary`, `build_and_upload`, `release`
- **`fastlane/Deliverfile`** — deliver configuration (category, pricing, metadata paths)
- **`fastlane/iap_products.json`** — 3 IAP products with localizations in 4 languages
- **`fastlane/metadata/{en-US,pt-BR,es-MX,fr-FR}/`** — App Store metadata text files
- **`scripts/take-appstore-screenshots.sh`** — generates screenshots on iPhone 17 Pro Max + iPad Pro 13"
- **`scripts/show-metadata.sh`** — prints all local metadata per locale
- **`scripts/store-credentials.sh`** — one-time setup to store API credentials in macOS Keychain

App Store Connect API credentials are read from **macOS Keychain** (preferred) with fallback to environment variables. To set up Keychain storage, run:
```bash
./scripts/store-credentials.sh
```
This stores Key ID, Issuer ID, and P8 key content under the Keychain service `pediatrictools-fastlane`. Environment variables still work as a fallback (e.g., for CI):
- `APP_STORE_CONNECT_API_KEY_KEY_ID`
- `APP_STORE_CONNECT_API_KEY_ISSUER_ID`
- `APP_STORE_CONNECT_API_KEY_KEY`

GitHub Pages (privacy policy + support) are served from `docs/` at:
- https://rafael-valim.github.io/pediatrictools-ios/privacy-policy
- https://rafael-valim.github.io/pediatrictools-ios/support

## Git Workflow

- Commit frequently with small, focused commits (not one big commit)
- Split large features: preparation/refactoring → models → views → wiring → tests
- After any view change, run `./scripts/take-screenshots.sh` and commit updated screenshots
