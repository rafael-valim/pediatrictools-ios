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
declare -A SIZE_LABELS
SIZE_LABELS["iPhone_17_Pro_Max"]="6.9inch"
SIZE_LABELS["iPad_Pro_13-inch_(M5)"]="13inch"

FASTLANE_SCREENSHOTS_DIR="$PROJECT_DIR/fastlane/screenshots/en-US"

# ─── Banner ───────────────────────────────────────────────────────────────────
echo -e "${BOLD}${CYAN}📸 App Store Screenshot Generator${RESET}"
echo -e "${CYAN}Devices:    ${RESET}${DEVICES[*]}"
echo -e "${CYAN}Output:     ${RESET}${FASTLANE_SCREENSHOTS_DIR}"
echo ""

# ─── Run screenshots on each device ──────────────────────────────────────────
for DEVICE in "${DEVICES[@]}"; do
    echo -e "${BOLD}${YELLOW}Running screenshots on: ${DEVICE}${RESET}"
    "$SCRIPT_DIR/take-screenshots.sh" --device "$DEVICE"
    echo ""
done

# ─── Organize into Fastlane structure ─────────────────────────────────────────
echo -e "${YELLOW}Organizing screenshots for Fastlane...${RESET}"
mkdir -p "$FASTLANE_SCREENSHOTS_DIR"

# Clear old Fastlane screenshots
rm -f "$FASTLANE_SCREENSHOTS_DIR"/*.png

SCREENSHOTS_DIR="$PROJECT_DIR/Screenshots"
COUNTER=1

# Process screenshots from each device
for DEVICE in "${DEVICES[@]}"; do
    DEVICE_SLUG=$(echo "$DEVICE" | tr ' ' '_' | tr -cd 'A-Za-z0-9_()-')
    SIZE_LABEL="${SIZE_LABELS[$DEVICE_SLUG]:-unknown}"

    # Find all screenshots for this device, sorted by name
    while IFS= read -r file; do
        BASENAME=$(basename "$file" .png)
        # Remove the device suffix to get the tool name
        TOOL_NAME="${BASENAME%_${DEVICE_SLUG}}"
        # Create sequential name: 01_ToolName_size.png
        SEQ=$(printf "%02d" "$COUNTER")
        cp "$file" "$FASTLANE_SCREENSHOTS_DIR/${SEQ}_${TOOL_NAME}_${SIZE_LABEL}.png"
        echo -e "  ${GREEN}•${RESET} ${SEQ}_${TOOL_NAME}_${SIZE_LABEL}.png"
        COUNTER=$((COUNTER + 1))
    done < <(find "$SCREENSHOTS_DIR" -name "*_${DEVICE_SLUG}.png" 2>/dev/null | sort)
done

TOTAL=$((COUNTER - 1))
echo ""
echo -e "${GREEN}${BOLD}✓ Generated ${TOTAL} App Store screenshots${RESET}"
echo -e "${CYAN}Location: ${FASTLANE_SCREENSHOTS_DIR}${RESET}"
echo ""
echo -e "${BOLD}Done.${RESET}"
