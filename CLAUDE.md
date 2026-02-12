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
`TipJarManager` uses `@Observable` (the only exception to the @State-only pattern). Three product IDs: `com.pediatrictools.app.tip.{small,medium,large}`. Supporter status is persisted in `UserDefaults`. The StoreKit config file is `Resources/TipJar.storekit`.

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

## Git Workflow

- Commit frequently with small, focused commits (not one big commit)
- Split large features: preparation/refactoring → models → views → wiring → tests
- After any view change, run `./scripts/take-screenshots.sh` and commit updated screenshots
