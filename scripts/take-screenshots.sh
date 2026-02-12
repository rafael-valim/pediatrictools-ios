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

# ─── Defaults ─────────────────────────────────────────────────────────────────
DEVICE="iPhone 17 Pro"
OPEN_FINDER=false

# ─── Parse arguments ─────────────────────────────────────────────────────────
while [[ $# -gt 0 ]]; do
    case "$1" in
        --device)
            DEVICE="$2"
            shift 2
            ;;
        --open)
            OPEN_FINDER=true
            shift
            ;;
        -h|--help)
            echo "Usage: $(basename "$0") [OPTIONS]"
            echo ""
            echo "Run PediatricTools UI tests to capture screenshots."
            echo ""
            echo "Options:"
            echo "  --device NAME   Simulator device name (default: iPhone 17 Pro)"
            echo "  --open          Open Screenshots/ in Finder when done"
            echo "  -h, --help      Show this help message"
            exit 0
            ;;
        *)
            echo -e "${RED}Unknown option: $1${RESET}" >&2
            echo "Run with --help for usage." >&2
            exit 1
            ;;
    esac
done

SCREENSHOTS_DIR="$PROJECT_DIR/Screenshots"

# ─── Banner ───────────────────────────────────────────────────────────────────
echo -e "${BOLD}${CYAN}📸 PediatricTools Screenshot Runner${RESET}"
echo -e "${CYAN}Device:     ${RESET}${DEVICE}"
echo -e "${CYAN}Output:     ${RESET}${SCREENSHOTS_DIR}"
echo ""

# ─── Find and boot simulator ──────────────────────────────────────────────────
echo -e "${YELLOW}Looking up simulator...${RESET}"
DEVICE_UDID=$(xcrun simctl list devices available -j \
    | python3 -c "
import json, sys
data = json.load(sys.stdin)
for runtime, devs in data['devices'].items():
    for d in devs:
        if d['name'] == '$DEVICE' and d['isAvailable']:
            print(d['udid']); sys.exit(0)
sys.exit(1)
" 2>/dev/null) || true

if [[ -z "$DEVICE_UDID" ]]; then
    echo -e "${RED}Error: Simulator '${DEVICE}' not found.${RESET}" >&2
    echo "" >&2
    echo "Available simulators:" >&2
    xcrun simctl list devices available | grep -E "iPhone|iPad" >&2
    exit 1
fi

echo -e "${GREEN}Found: ${DEVICE} (${DEVICE_UDID})${RESET}"
echo -e "${YELLOW}Booting simulator...${RESET}"
xcrun simctl boot "$DEVICE_UDID" 2>/dev/null || true
xcrun simctl bootstatus "$DEVICE_UDID" -b 2>/dev/null
echo -e "${GREEN}Simulator ready.${RESET}"

# ─── Clean old screenshots for this device ───────────────────────────────────
DEVICE_SLUG=$(echo "$DEVICE" | tr ' ' '_' | tr -cd 'A-Za-z0-9_-')
mkdir -p "$SCREENSHOTS_DIR"
OLD_COUNT=$(find "$SCREENSHOTS_DIR" -name "*_${DEVICE_SLUG}.png" 2>/dev/null | wc -l | tr -d ' ')
if [[ "$OLD_COUNT" -gt 0 ]]; then
    echo -e "${YELLOW}Removing ${OLD_COUNT} old screenshots for ${DEVICE}...${RESET}"
    find "$SCREENSHOTS_DIR" -name "*_${DEVICE_SLUG}.png" -delete
else
    echo -e "${YELLOW}No old screenshots for ${DEVICE} to clean.${RESET}"
fi

# ─── Run UI tests ────────────────────────────────────────────────────────────
echo -e "${YELLOW}Running UI tests (this may take a few minutes)...${RESET}"
echo ""

# Remove stale result bundle (xcodebuild refuses to overwrite)
rm -rf "$PROJECT_DIR/.build/screenshots.xcresult"

# Target the already-booted UDID to prevent xcodebuild from spawning clones
XCODEBUILD_EXIT=0
(cd "$PROJECT_DIR" && xcodebuild test \
    -project PediatricTools.xcodeproj \
    -scheme PediatricTools \
    -destination "platform=iOS Simulator,id=$DEVICE_UDID" \
    -only-testing:PediatricToolsUITests \
    -disable-concurrent-testing \
    -parallel-testing-enabled NO \
    -resultBundlePath .build/screenshots.xcresult \
    2>&1) | while IFS= read -r line; do
        if echo "$line" | grep -qE "Test Case.*passed|Test Case.*failed|error:|BUILD SUCCEEDED|BUILD FAILED|Testing started|Executed [0-9]+ test"; then
            echo "$line"
        fi
    done || XCODEBUILD_EXIT=$?

# ─── Results ──────────────────────────────────────────────────────────────────
echo ""

if [[ $XCODEBUILD_EXIT -ne 0 ]]; then
    echo -e "${RED}${BOLD}✗ Screenshot tests failed (exit code: $XCODEBUILD_EXIT)${RESET}"
    echo -e "${YELLOW}Check the full log or .build/screenshots.xcresult for details.${RESET}"
    exit $XCODEBUILD_EXIT
fi

# Count screenshots
SCREENSHOT_COUNT=$(find "$SCREENSHOTS_DIR" -name "*.png" 2>/dev/null | wc -l | tr -d ' ')

echo -e "${GREEN}${BOLD}✓ Screenshot tests passed${RESET}"
echo -e "${CYAN}Captured ${SCREENSHOT_COUNT} screenshots:${RESET}"
echo ""

# List screenshots grouped by subfolder
find "$SCREENSHOTS_DIR" -name "*.png" | sort | while IFS= read -r file; do
    relative="${file#"$SCREENSHOTS_DIR/"}"
    echo -e "  ${GREEN}•${RESET} $relative"
done

echo ""

# ─── Open in Finder ──────────────────────────────────────────────────────────
if $OPEN_FINDER; then
    echo -e "${CYAN}Opening Screenshots folder...${RESET}"
    open "$SCREENSHOTS_DIR"
fi

echo -e "${BOLD}Done.${RESET}"
