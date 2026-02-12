# Pediatric Tools

A native iOS app providing essential pediatric clinical calculators for healthcare professionals. Built with SwiftUI, fully localized in English and Brazilian Portuguese (PT-BR), with no external dependencies.

## Features

The app includes 11 evidence-based clinical tools:

| Tool | Description |
|------|-------------|
| **New Ballard Score** | Estimates neonatal gestational age (20-44 weeks) from 12 neuromuscular and physical maturity criteria |
| **APGAR Score** | Evaluates newborn vitality at birth across 5 criteria (appearance, pulse, grimace, activity, respiration) |
| **PEWS Score** | Pediatric Early Warning Score assessing behavior, cardiovascular, and respiratory status |
| **Dosage Calculator** | Weight-based pediatric dosing for 9 common medications with multiple concentrations |
| **IV Fluid (Holliday-Segar)** | Maintenance IV fluid calculation with electrolyte recommendations |
| **BSA Calculator** | Body surface area via the Mosteller formula |
| **Corrected Age** | Corrected gestational age for premature infants |
| **Growth Percentile** | WHO 0-24 month growth charts (weight-for-age, length-for-age) with Z-scores |
| **Dehydration** | Fluid deficit and 24h replacement plan based on weight and dehydration severity |
| **FENa Calculator** | Fractional Excretion of Sodium to differentiate prerenal vs intrinsic renal failure |
| **ETT Size** | Endotracheal tube sizing by age or neonatal weight, with depth and suction catheter |

## Requirements

- iOS 17.0+
- Xcode 15.0+
- Swift 5

## Project Structure

```
PediatricTools/
├── PediatricToolsApp.swift          # App entry point
├── Models/                          # Pure calculation logic (no UI dependencies)
│   ├── ApgarScore.swift
│   ├── BallardScore.swift
│   ├── BSACalculator.swift
│   ├── CorrectedAgeCalculator.swift
│   ├── DehydrationCalculator.swift
│   ├── ETTCalculator.swift
│   ├── FENaCalculator.swift
│   ├── GrowthPercentile.swift
│   ├── HollidaySegar.swift
│   ├── PediatricDosage.swift
│   └── PEWSScore.swift
├── Views/
│   ├── HomeView.swift               # Main navigation list
│   ├── Shared/                      # Reusable UI components
│   │   ├── NumberInputRow.swift     # Numeric input with unit label and range validation
│   │   ├── ResultBar.swift          # Bottom result display bar
│   │   └── ScoreSelectorRow.swift   # Score picker for criteria-based tools
│   ├── Apgar/
│   ├── Ballard/
│   ├── BSA/
│   ├── CorrectedAge/
│   ├── Dehydration/
│   ├── Dosage/
│   ├── ETT/
│   ├── FENa/
│   ├── Growth/
│   ├── IVFluid/
│   ├── PEWS/
│   └── Settings/
│       ├── SettingsView.swift     # Appearance, language, and about link
│       └── AboutView.swift        # App info and clinical references
└── Resources/
    ├── Assets.xcassets
    └── Localizable.xcstrings        # String catalog (EN + PT-BR)

PediatricToolsTests/                 # Unit tests for all 11 calculators
PediatricToolsUITests/               # UI screenshot tests for every tool
```

## Architecture

- **Models** are pure `enum` namespaces with `static` functions — no instances, no side effects, easily testable
- **Views** use `@State` only — no view models, no Combine, no external state management
- **Shared components** (`NumberInputRow`, `ResultBar`, `ScoreSelectorRow`) are reused across all tools
- **Navigation** uses `NavigationStack` with a `List` of `NavigationLink` items
- **Zero external dependencies** — the entire app uses only Apple frameworks

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

The app uses Xcode String Catalogs (`Localizable.xcstrings`) with two languages:
- **English (en)** — development language
- **Brazilian Portuguese (pt-BR)**

All user-facing strings use localization keys (e.g., `"ballard_score_title"`) resolved via `LocalizedStringKey` so they react to in-app locale changes.

To add a new language:
1. Open `Localizable.xcstrings` in Xcode
2. Click the **+** button in the language sidebar
3. Translate all entries for the new locale

## Testing

### Unit Tests

The `PediatricToolsTests` target contains 11 test files — one per calculator model. Tests verify formulas, edge cases, clamping behavior, and interpretation logic.

```bash
xcodebuild test \
  -scheme PediatricTools \
  -destination 'platform=iOS Simulator,name=iPhone 16 Pro' \
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
3. **Add localization keys** to `Localizable.xcstrings` for both EN and PT-BR
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
- **New localization keys:** Add entries to `Localizable.xcstrings` for both EN and PT-BR
- **New files:** Register in `project.pbxproj` (PBXBuildFile, PBXFileReference, PBXGroup, PBXSourcesBuildPhase)

### After Code Changes

> Whenever a code change modifies any view under `Views/`, run `./scripts/take-screenshots.sh` (no flags needed — defaults to iPhone 17 Pro) to regenerate screenshots. Run it only once, on the default device.

## License

All rights reserved.
