# Pediatric Tools

A native iOS app providing essential pediatric clinical calculators for healthcare professionals. Built entirely with SwiftUI, localized in four languages, with zero external dependencies.

**[Privacy Policy](https://rafael-valim.github.io/pediatrictools-ios/privacy-policy)** | **[Support](https://rafael-valim.github.io/pediatrictools-ios/support)**

## Features

The app includes 20 evidence-based clinical tools:

### Scoring & Assessment Tools

| Tool | Description |
|------|-------------|
| **New Ballard Score** | Estimates neonatal gestational age (20-44 weeks) from 12 neuromuscular and physical maturity criteria |
| **APGAR Score** | Evaluates newborn vitality at birth across 5 criteria (appearance, pulse, grimace, activity, respiration) |
| **PEWS Score** | Pediatric Early Warning Score assessing behavior, cardiovascular, and respiratory status |
| **FLACC Score** | Pain assessment for pre-verbal and non-verbal patients (Faces, Legs, Activity, Cry, Consolability) |
| **Glasgow Coma Scale** | Consciousness level assessment adapted for pediatric patients |
| **PRAM Score** | Preschool Respiratory Assessment Measure for asthma severity |
| **PECARN Head Injury** | CT decision support for pediatric head trauma |
| **Phoenix Sepsis** | Pediatric sepsis organ dysfunction criteria |

### Calculators

| Tool | Description |
|------|-------------|
| **Dosage Calculator** | Weight-based pediatric dosing for 9 common medications with multiple concentrations |
| **IV Fluid (Holliday-Segar)** | Maintenance IV fluid calculation with electrolyte recommendations |
| **BSA Calculator** | Body surface area via the Mosteller formula |
| **Corrected Age** | Corrected gestational age for premature infants |
| **Growth Percentile** | WHO 0-24 month growth charts (weight-for-age, length-for-age) with Z-scores |
| **Dehydration** | Fluid deficit and 24h replacement plan based on weight and dehydration severity |
| **FENa Calculator** | Fractional Excretion of Sodium to differentiate prerenal vs intrinsic renal failure |
| **ETT Size** | Endotracheal tube sizing by age or neonatal weight, with depth and suction catheter |
| **Schwartz GFR** | Estimated glomerular filtration rate for children |
| **QTc Calculator** | Corrected QT interval using Bazett formula |
| **Blood Pressure Percentile** | Age, sex, and height-based BP evaluation |
| **Bilirubin Risk** | Neonatal jaundice phototherapy threshold assessment |

## App Settings

The app includes a **Settings** screen (gear icon in the toolbar) with the following preferences, all persisted via `@AppStorage`:

| Setting | Options | Default |
|---------|---------|---------|
| **Appearance** | System / Light / Dark | System |
| **Language** | System / English / Português (BR) / Español / Français | System |
| **Portrait Lock** | On / Off | Off |

On first launch, the app shows a **medical disclaimer** alert that must be accepted before use. This preference is also stored via `@AppStorage`.

### Tip Jar

The Settings screen includes a **Tip Jar** powered by StoreKit 2 (configured in `TipJar.storekit`). It offers three tip tiers (small, medium, large). Users who tip receive a **Supporter badge** displayed on the About screen. The `TipJarManager` uses Swift's `@Observable` macro and listens for transaction updates in the background.

### About Screen

Displays the app icon, version, build number, and an optional Supporter badge. Includes a **References** section listing the evidence-based source for each of the 20 clinical tools.

## Requirements

- iOS 17.0+
- Xcode 15.0+
- Swift 5

## Project Structure

```
PediatricTools/
├── PediatricToolsApp.swift          # App entry point
├── AppDelegate.swift                # Orientation lock management
├── Models/                          # Pure calculation logic (no UI dependencies)
│   ├── ApgarScore.swift
│   ├── BallardScore.swift
│   ├── BilirubinCalculator.swift
│   ├── BPPercentile.swift
│   ├── BSACalculator.swift
│   ├── CorrectedAgeCalculator.swift
│   ├── DehydrationCalculator.swift
│   ├── ETTCalculator.swift
│   ├── FENaCalculator.swift
│   ├── FLACCScore.swift
│   ├── GlasgowComaScale.swift
│   ├── GrowthPercentile.swift
│   ├── HollidaySegar.swift
│   ├── PECARNRule.swift
│   ├── PediatricDosage.swift
│   ├── PEWSScore.swift
│   ├── PhoenixSepsis.swift
│   ├── PRAMScore.swift
│   ├── QTcCalculator.swift
│   ├── SchwartzGFR.swift
│   └── TipJarManager.swift         # StoreKit 2 in-app purchase manager (@Observable)
├── Views/
│   ├── HomeView.swift               # Main navigation list
│   ├── Shared/                      # Reusable UI components
│   │   ├── NumberInputRow.swift     # Numeric input with unit label and range validation
│   │   ├── ResultBar.swift          # Bottom result display bar
│   │   └── ScoreSelectorRow.swift   # Score picker for criteria-based tools
│   ├── Apgar/
│   ├── Ballard/
│   ├── Bilirubin/
│   ├── BP/
│   ├── BSA/
│   ├── CorrectedAge/
│   ├── Dehydration/
│   ├── Dosage/
│   ├── ETT/
│   ├── FENa/
│   ├── FLACC/
│   ├── GCS/
│   ├── GFR/
│   ├── Growth/
│   ├── IVFluid/
│   ├── PECARN/
│   ├── PEWS/
│   ├── Phoenix/
│   ├── PRAM/
│   ├── QTc/
│   └── Settings/
│       ├── SettingsView.swift       # Appearance, language, portrait lock
│       ├── AboutView.swift          # App info, supporter badge, clinical references
│       └── TipJarView.swift         # StoreKit 2 tip jar UI
└── Resources/
    ├── Assets.xcassets
    ├── Localizable.xcstrings        # String catalog (EN, PT-BR, ES, FR)
    ├── PrivacyInfo.xcprivacy        # Apple privacy manifest
    └── TipJar.storekit             # StoreKit 2 configuration for testing

PediatricToolsTests/                 # Unit tests for all 20 calculators
PediatricToolsUITests/               # UI screenshot tests for every tool

docs/                                # GitHub Pages (live at rafael-valim.github.io/pediatrictools-ios)
├── index.html                       # Landing page
├── privacy-policy.html              # Privacy policy
└── support.html                     # Support page with FAQ

fastlane/                            # App Store submission automation
├── Appfile                          # App identifier + team ID
├── Fastfile                         # Lanes: screenshots, build, upload_metadata, upload_screenshots, upload_binary, build_and_upload, release
├── Deliverfile                      # deliver configuration
├── iap_products.json                # IAP product definitions with localizations
└── metadata/                        # App Store metadata (4 locales)
    ├── en-US/                       # name, subtitle, description, keywords, etc.
    ├── pt-BR/
    ├── es-MX/
    └── fr-FR/

scripts/
├── take-screenshots.sh              # UI test screenshots (single device)
├── take-appstore-screenshots.sh     # App Store screenshots (iPhone + iPad)
├── show-metadata.sh                 # Print local metadata per locale
└── store-credentials.sh             # Store ASC API credentials in macOS Keychain

Gemfile                              # Fastlane dependency
```

## Architecture

- **Models** are pure `enum` namespaces with `static` functions — no instances, no side effects, easily testable
- **Views** use `@State` only — no view models, no Combine, no external state management
- **TipJarManager** is the sole exception: it uses `@Observable` for StoreKit 2 integration
- **Shared components** (`NumberInputRow`, `ResultBar`, `ScoreSelectorRow`) are reused across all tools
- **Navigation** uses `NavigationStack` with a `List` of `NavigationLink` items
- **Settings persistence** uses `@AppStorage` for all user preferences
- **Orientation control** via `AppDelegate` — supports portrait lock toggle; automatically disabled during UI tests via `-UITesting` launch argument
- **Zero external dependencies** — the entire app uses only Apple frameworks (SwiftUI, UIKit, StoreKit)

## Input Validation

`NumberInputRow` accepts an optional `range: ClosedRange<Double>?` parameter. When a value is outside the valid range, the input and unit label turn red to alert the user. Values are not silently clamped — the user can see their input is unreasonable.

| Field | Valid Range | Notes |
|-------|------------|-------|
| Weight (kg) | 0.1 – 300 | Premature neonates to obese adolescents |
| Height (cm) | 10 – 250 | Premature to tall teen |
| Age (years) | 0.1 – 18 | Pediatric range |
| Age (months) | 0 – 24 | Growth charts |
| Dehydration % | 0.1 – 20 | Clinical max ~15-20% |
| Sodium (mEq/L) | 0.1 – 500 | Lab value range |
| Creatinine (mg/dL) | 0.01 – 50 | Lab value range |

All `Form`-based views use `.scrollDismissesKeyboard(.interactively)` so the keyboard dismisses when the user scrolls.

## Localization

The app uses Xcode String Catalogs (`Localizable.xcstrings`) with four languages:
- **English (en)** — development language
- **Brazilian Portuguese (pt-BR)**
- **Spanish (es)**
- **French (fr)**

Users can switch languages in-app via the Settings screen. The language preference is applied using a `LocaleModifier` that sets `.environment(\.locale)` on the root view, so all SwiftUI text views react immediately without restarting the app.

All user-facing strings use localization keys (e.g., `"ballard_score_title"`) resolved via `LocalizedStringKey`.

To add a new language:
1. Open `Localizable.xcstrings` in Xcode
2. Click the **+** button in the language sidebar
3. Translate all entries for the new locale
4. Add the new language option to the language picker in `SettingsView.swift`

## Testing

### Unit Tests

The `PediatricToolsTests` target contains 20+ test files — one per calculator model. Tests verify formulas, edge cases, clamping behavior, and interpretation logic.

```bash
xcodebuild test \
  -scheme PediatricTools \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro' \
  -only-testing:PediatricToolsTests
```

### UI Screenshot Tests

The `PediatricToolsUITests` target captures screenshots of every tool in empty and filled states. Screenshots are saved both as XCTest attachments (in the `.xcresult` bundle) and as PNG files on disk.

A convenience script runs the tests on a single simulator per execution (default: **iPhone 17 Pro**):

```bash
./scripts/take-screenshots.sh                          # default: iPhone 17 Pro
./scripts/take-screenshots.sh --device "iPhone Air"    # custom device
./scripts/take-screenshots.sh --open                   # open Screenshots/ in Finder when done
```

The script only removes screenshots for the targeted device before each run, so you can accumulate screenshots from multiple devices by running the script once per device:

```bash
./scripts/take-screenshots.sh --device "iPhone 17 Pro"
./scripts/take-screenshots.sh --device "iPad Pro 13-inch (M5)"
```

Screenshots are saved to `Screenshots/` organized by tool name, with the device name appended to each file (e.g., `Screenshots/Ballard/Ballard_Empty_iPhone_17_Pro.png`). This directory is gitignored.

> **AI Agents:** Whenever a code change modifies any view under `Views/`, run `./scripts/take-screenshots.sh` (no flags needed — defaults to iPhone 17 Pro) to regenerate screenshots. Run it only once, on the default device.

## App Store Submission

The project includes a fully automated App Store submission pipeline powered by [Fastlane](https://fastlane.tools/).

### Prerequisites

1. **Install Fastlane:**
   ```bash
   bundle install
   ```

2. **Store App Store Connect API credentials in macOS Keychain (recommended):**
   - Go to [App Store Connect](https://appstoreconnect.apple.com/) > Users and Access > Integrations > App Store Connect API
   - Generate a key with **Admin** or **App Manager** role
   - Download the `.p8` file and note the **Key ID** and **Issuer ID**
   - Run the one-time setup script:
     ```bash
     ./scripts/store-credentials.sh
     ```
     This prompts for Key ID, Issuer ID, and the path to your `.p8` file, then stores all three securely in macOS Keychain (service: `pediatrictools-fastlane`). You can safely delete the `.p8` file afterward.

   - **Alternative (CI/environment variables):** If Keychain is not available (e.g., CI runners), set environment variables instead:
     ```bash
     export APP_STORE_CONNECT_API_KEY_KEY_ID="your-key-id"
     export APP_STORE_CONNECT_API_KEY_ISSUER_ID="your-issuer-id"
     export APP_STORE_CONNECT_API_KEY_KEY="$(cat path/to/AuthKey.p8)"
     ```

   Fastlane reads from Keychain first, falling back to environment variables automatically.

   **New machine?** Credentials are backed up in a separate private repository with a restore script that imports everything into Keychain automatically.

### App Store Metadata

Metadata for all 4 locales lives in `fastlane/metadata/`:

```
fastlane/metadata/
├── en-US/          # English
├── pt-BR/          # Portuguese (Brazil)
├── es-MX/          # Spanish (Mexico)
├── fr-FR/          # French
│   ├── name.txt
│   ├── subtitle.txt
│   ├── description.txt
│   ├── keywords.txt          # Comma-separated, max 100 characters
│   ├── release_notes.txt
│   ├── privacy_url.txt
│   └── support_url.txt
```

To update metadata, edit the text files directly. Fastlane's `deliver` reads them automatically during upload.

### Versioning

The app uses two version numbers, both defined in `project.pbxproj` (no static Info.plist — Xcode auto-generates it):

| Setting | Purpose | When to bump |
|---------|---------|-------------|
| `MARKETING_VERSION` | User-facing version (e.g., `1.0`) | New App Store release |
| `CURRENT_PROJECT_VERSION` | Build number (e.g., `2`) | **Every** App Store Connect submission |

Bump the build number before every submission:
```bash
agvtool next-version -all    # Increments build number across all targets
agvtool what-version          # Verify current build number
```

### App Store Screenshots

The App Store shows **10 screenshots per device** (Apple's maximum). The selection strategy:

| # | Screen | State |
|---|--------|-------|
| 1 | Home | Default |
| 2-9 | Apgar, Bilirubin, Dosage, Growth, BP, GCS, PEWS, PECARN | Filled |
| 10 | Settings | Default |

These 8 features were chosen as the most representative clinical tools covering neonatal assessment, medication dosing, growth monitoring, vital signs, emergency scoring, and trauma decision support.

Generate screenshots for both required device sizes (iPhone 6.9" and iPad 13"):

```bash
./scripts/take-appstore-screenshots.sh
```

This script:
1. Runs the UI test suite on **iPhone 17 Pro Max** and **iPad Pro 13-inch (M5)** (one at a time)
2. Extracts the 10 selected screenshots per device into `fastlane/screenshots/en-US/` with sequential naming
3. The same screenshots are used for all locales (the app handles localization internally)

Regenerate after any view change, then upload with `bundle exec fastlane upload_screenshots`.

### In-App Purchases

IAP product definitions are in `fastlane/iap_products.json` (3 tip jar products with localizations in all 4 languages). IAPs must be created manually in App Store Connect (the Spaceship API does not support programmatic IAP creation).

### Submission Workflow

```bash
# Full pipeline (build → upload → deliver → submit):
bundle exec fastlane release

# Individual operations:
bundle exec fastlane screenshots       # Generate App Store screenshots
bundle exec fastlane build             # Archive .ipa for App Store
bundle exec fastlane upload_metadata   # Push metadata to App Store Connect
bundle exec fastlane upload_screenshots # Upload screenshots to App Store Connect
bundle exec fastlane upload_binary     # Upload existing .ipa to TestFlight
bundle exec fastlane build_and_upload  # Build + upload to TestFlight

# View local metadata:
./scripts/show-metadata.sh
```

### Privacy

The app includes `PrivacyInfo.xcprivacy` (Apple's required privacy manifest since 2024) declaring:
- **UserDefaults** access (reason: `CA92.1` — app preferences)
- **No tracking**
- **No data collection**

The privacy policy and support pages are hosted via GitHub Pages:
- Privacy: https://rafael-valim.github.io/pediatrictools-ios/privacy-policy
- Support: https://rafael-valim.github.io/pediatrictools-ios/support

## CI/CD

The project uses two GitHub Actions workflows that default to a **self-hosted** macOS runner, with automatic fallback to `macos-15` (GitHub-hosted) when the self-hosted runner is offline.

### Build and Test

**File:** `.github/workflows/build-and-test.yml`

Runs automatically on pushes to `main` and pull requests. Builds the project and runs all unit tests with prettified output via **xcbeautify**.

To manually trigger with screenshots included:
1. Go to **Actions > Build and Test > Run workflow**
2. Set **Also run screenshot tests** to `true`
3. Optionally force a specific runner (`self-hosted` or `macos-15`) instead of the default `auto`

### Screenshots

**File:** `.github/workflows/screenshots.yml`

Captures screenshots of every tool in empty and filled states. Can be triggered in two ways:

- **Standalone:** Go to **Actions > Screenshots > Run workflow**
- **From Build and Test:** Enable the `run_screenshots` option when manually triggering the build workflow

Screenshots and the `.xcresult` bundle are uploaded as workflow artifacts.

### Runner behavior

| Trigger | Default runner |
|---------|---------------|
| Push / PR | Auto-detect (self-hosted, fallback to `macos-15`) |
| Manual (`workflow_dispatch`) | `auto` — same fallback logic, or choose a specific runner from the dropdown |

The auto-detect logic queries the GitHub API for online self-hosted runners. If none are available, it falls back to `macos-15`.

## Adding a New Tool

1. **Create the model** in `Models/` — a pure `enum` with `static` calculation functions
2. **Create the view** in `Views/<ToolName>/` — a `Form`-based SwiftUI view using `@State` for inputs
   - Use `NumberInputRow` for numeric inputs (with appropriate `range`)
   - Use `ResultBar` for bottom result display
   - Add `.scrollDismissesKeyboard(.interactively)` on the `Form`
3. **Add localization keys** to `Localizable.xcstrings` for all 4 languages (EN, PT-BR, ES, FR)
4. **Register the tool** in `HomeView.swift` by adding a new `ToolItem` to the `tools` array
5. **Write unit tests** in `PediatricToolsTests/` covering the model logic
6. **Write UI screenshot tests** in `PediatricToolsUITests/` capturing empty and filled states
7. **Update `project.pbxproj`** to include the new files in the appropriate targets

## Contributing Guidelines (for AI Agents)

When working on this codebase, follow these conventions:

### Git Workflow

- **Commit frequently** — do not bundle all changes into a single large commit
- **Break large changes into smaller, focused commits** — each commit should represent a single logical change and be independently reviewable
- Examples of how to split a large feature:
  1. Refactoring/preparation changes (e.g., converting localization patterns)
  2. New files and models
  3. Wiring up new features to the app root
  4. UI changes (toolbar, navigation links, etc.)
- Write clear commit messages that explain **why** the change was made, not just what changed
- Use imperative mood in commit subjects (e.g., "Add settings screen" not "Added settings screen")

### Code Conventions

- **Localization:** Use `LocalizedStringKey` (not `String(localized:)`) so that SwiftUI text views react to in-app locale changes via `.environment(\.locale)`
- **Views:** Use `@State` only — no view models, no Combine, no external state management
- **Models:** Pure `enum` namespaces with `static` functions — no instances, no side effects
- **Shared components:** Reuse `NumberInputRow`, `ResultBar`, and `ScoreSelectorRow` across tools
- **Settings persistence:** Use `@AppStorage` for user preferences
- **New localization keys:** Add entries to `Localizable.xcstrings` for all 4 languages (EN, PT-BR, ES, FR)
- **New files:** Register in `project.pbxproj` (PBXBuildFile, PBXFileReference, PBXGroup, PBXSourcesBuildPhase)

### After Code Changes

> Whenever a code change modifies any view under `Views/`, run `./scripts/take-screenshots.sh` (no flags needed — defaults to iPhone 17 Pro) to regenerate screenshots. Run it only once, on the default device.

## License

All rights reserved.
