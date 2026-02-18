#!/usr/bin/env bash
set -euo pipefail

# ─── Colors ───────────────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

# ─── Project root (one level up from scripts/) ───────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

# ─── Devices for App Store screenshots ────────────────────────────────────────
# iPhone 17 Pro Max — 6.9" display (covers all iPhone sizes in ASC)
# iPad Pro 13-inch (M5) — covers all iPad sizes in ASC
DEVICES=(
    "iPhone 17 Pro Max"
    "iPad Pro 13-inch (M5)"
)

# ─── Size labels for Fastlane naming ─────────────────────────────────────────
# Maps device slug → size label (bash 3 compatible)
size_label_for() {
    case "$1" in
        iPhone_17_Pro_Max)     echo "6.9inch" ;;
        "iPad_Pro_13-inch_(M5)") echo "13inch" ;;
        *)                     echo "unknown" ;;
    esac
}

# ─── App Store screenshot selection (8 per device) ──────────────────────────
# Home + About + 3 calculators (Apgar, Ballard, Bilirubin) × (Filled + Details)
APP_STORE_TESTS=(
    "PediatricToolsUITests/HomeScreenshots"
    "PediatricToolsUITests/AboutScreenshots"
    "PediatricToolsUITests/ApgarScreenshots"
    "PediatricToolsUITests/BallardScreenshots"
    "PediatricToolsUITests/BilirubinScreenshots"
)

# Screenshots to keep for the store (8 total)
APP_STORE_FILES=(
    "Home/Home_Default"
    "About/About_Default"
    "Apgar/Apgar_Filled"
    "Apgar/Apgar_Details"
    "Ballard/Ballard_Filled"
    "Ballard/Ballard_Details"
    "Bilirubin/Bilirubin_Filled"
    "Bilirubin/Bilirubin_Details"
)

FASTLANE_SCREENSHOTS_DIR="$PROJECT_DIR/fastlane/screenshots/en-US"
SCREENSHOTS_DIR="$PROJECT_DIR/Screenshots"

# ─── Banner ───────────────────────────────────────────────────────────────────
echo -e "${BOLD}${CYAN}📸 App Store Screenshot Generator${RESET}"
echo -e "${CYAN}Devices:    ${RESET}${DEVICES[*]}"
echo -e "${CYAN}Output:     ${RESET}${FASTLANE_SCREENSHOTS_DIR}"
echo -e "${CYAN}Limit:      ${RESET}8 screenshots per device"
echo ""

# Build the -only-testing arguments
ONLY_TESTING_ARGS=""
for TEST in "${APP_STORE_TESTS[@]}"; do
    ONLY_TESTING_ARGS="$ONLY_TESTING_ARGS -only-testing:$TEST"
done

# ─── Run screenshots on each device ──────────────────────────────────────────
for DEVICE in "${DEVICES[@]}"; do
    echo -e "${BOLD}${YELLOW}Running screenshots on: ${DEVICE}${RESET}"
    "$SCRIPT_DIR/take-screenshots.sh" --device "$DEVICE"
    echo ""
done

# ─── Organize into Fastlane structure ─────────────────────────────────────────
echo -e "${YELLOW}Organizing screenshots for Fastlane (8 per device)...${RESET}"
mkdir -p "$FASTLANE_SCREENSHOTS_DIR"

# Clear old Fastlane screenshots
rm -f "$FASTLANE_SCREENSHOTS_DIR"/*.png

COUNTER=1

# Process screenshots from each device
for DEVICE in "${DEVICES[@]}"; do
    DEVICE_SLUG=$(echo "$DEVICE" | tr ' ' '_' | tr -cd 'A-Za-z0-9_()-')
    SIZE_LABEL="$(size_label_for "$DEVICE_SLUG")"

    for FILE_PREFIX in "${APP_STORE_FILES[@]}"; do
        # Find the screenshot matching this prefix and device
        MATCH=$(find "$SCREENSHOTS_DIR" -path "*/${FILE_PREFIX}_*${DEVICE_SLUG}.png" 2>/dev/null | head -1)
        if [[ -n "$MATCH" ]]; then
            BASENAME=$(basename "$MATCH" .png)
            TOOL_NAME="${BASENAME%_${DEVICE_SLUG}}"
            SEQ=$(printf "%02d" "$COUNTER")
            cp "$MATCH" "$FASTLANE_SCREENSHOTS_DIR/${SEQ}_${TOOL_NAME}_${SIZE_LABEL}.png"
            echo -e "  ${GREEN}•${RESET} ${SEQ}_${TOOL_NAME}_${SIZE_LABEL}.png"
            COUNTER=$((COUNTER + 1))
        else
            echo -e "  ${YELLOW}⚠${RESET} Not found: ${FILE_PREFIX} for ${DEVICE}"
        fi
    done
done

TOTAL=$((COUNTER - 1))
echo ""
echo -e "${GREEN}${BOLD}✓ Generated ${TOTAL} App Store screenshots${RESET}"
echo -e "${CYAN}Location: ${FASTLANE_SCREENSHOTS_DIR}${RESET}"
echo ""
echo -e "${BOLD}Done.${RESET}"
