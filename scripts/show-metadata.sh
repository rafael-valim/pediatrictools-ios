#!/usr/bin/env bash
set -euo pipefail

# ─── Colors ───────────────────────────────────────────────────────────────────
BOLD='\033[1m'
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RESET='\033[0m'

# ─── Project root (one level up from scripts/) ───────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
METADATA_DIR="$PROJECT_DIR/fastlane/metadata"

# ─── Locales ──────────────────────────────────────────────────────────────────
LOCALES=("en-US" "pt-BR" "es-MX" "fr-FR")

echo -e "${BOLD}${CYAN}App Store Metadata${RESET}"
echo ""

for LOCALE in "${LOCALES[@]}"; do
    LOCALE_DIR="$METADATA_DIR/$LOCALE"
    if [ ! -d "$LOCALE_DIR" ]; then
        echo -e "${YELLOW}Skipping $LOCALE (directory not found)${RESET}"
        continue
    fi

    echo -e "${BOLD}${GREEN}── $LOCALE ──${RESET}"

    for FIELD in name subtitle keywords; do
        FILE="$LOCALE_DIR/$FIELD.txt"
        if [ -f "$FILE" ]; then
            VALUE=$(cat "$FILE")
            echo -e "  ${CYAN}$FIELD:${RESET} $VALUE"
        fi
    done

    # Description — show first 2 lines
    DESC_FILE="$LOCALE_DIR/description.txt"
    if [ -f "$DESC_FILE" ]; then
        EXCERPT=$(head -2 "$DESC_FILE")
        echo -e "  ${CYAN}description:${RESET} $EXCERPT ..."
    fi

    for FIELD in privacy_url support_url; do
        FILE="$LOCALE_DIR/$FIELD.txt"
        if [ -f "$FILE" ]; then
            VALUE=$(cat "$FILE")
            echo -e "  ${CYAN}$FIELD:${RESET} $VALUE"
        fi
    done

    echo ""
done

echo -e "${BOLD}Done.${RESET}"
