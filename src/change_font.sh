#!/bin/bash
set -e

SOURCE_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

FONT_NAME="CyberpunkWaifus"

FONTS_DIR="$HOME/.local/share/fonts"
THEME_DIR="/boot/grub/themes/valhalla"
THEME_FILE="${THEME_DIR}/theme.txt"

FONT_SRC="${FONTS_DIR}/${FONT_NAME}.ttf"

# Define font size
echo -e "Write your preferred font size.\n"
echo -e "💡 Recommended size values:\n"
echo "╭ Screen resolution -|- Font size ---╮"
echo "|------------------------------------|"
echo "| 1280×720 (HD)      | 28            |"
echo "| 1920x1080 (FullHD) | 42 (default)  |"
echo "| 2560×1440 (2K/QHD) | 56            |"
echo "| 3840×2160 (4K/UHD) | 84            |"
echo "╰------------------------------------╯"
echo

read -rp "Your size: " font_size

if ! [[ "$font_size" =~ ^[1-9][0-9]*$ ]]; then
  echo "Error: size must be a positive integer."
  exit 1
fi

# Check font source
if [[ ! -f "$FONT_SRC" ]]; then
  echo "Error: font file not found at '$FONTS_DIR'."
  exit 1
fi

# Generate font
NEW_FONT_FILE="${FONT_NAME}${font_size}.pf2"
NEW_FONT_PATH="${THEME_DIR}/${NEW_FONT_FILE}"

echo "🪶 Generating GRUB font..."

if command -v grub-mkfont &>/dev/null; then
  GRUB_MKFONT="grub-mkfont"
elif command -v grub2-mkfont &>/dev/null; then
  GRUB_MKFONT="grub2-mkfont"
else
  echo "Error: Could not locate grub-mkfont."
  exit 1
fi

sudo "$GRUB_MKFONT" -s "$font_size" -o "$NEW_FONT_PATH" "$FONT_SRC"

# Update theme.txt
if [[ ! -f "$THEME_FILE" ]]; then
  echo "Error: theme file is missing."
  exit 1
fi

echo "🗒️ Updating font reference in '$THEME_FILE'..."

sudo sed -i -E "s|(${FONT_NAME})[[:space:]]*[0-9]+|\1 ${font_size}|g" "$THEME_FILE"

echo "Font reference set to '${FONT_NAME} ${font_size}'."

# Update config
"${SOURCE_DIR}/src/update_grub.sh"

echo "Done!"
