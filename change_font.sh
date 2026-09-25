#!/bin/bash
set -e

FONT_NAME="CyberpunkWaifus"
FONT_FAMILY="$FONT_NAME"

FONTS_DIR="$HOME/.local/share/fonts"
THEME_DIR="/boot/grub/themes/valhalla"
THEME_FILE="${THEME_DIR}/theme.txt"

FONT_SRC="${FONTS_DIR}/${FONT_FAMILY}/${FONT_NAME}.ttf"

# Define font size
echo -e "Write your preferred font size.\n"
echo -e "💡 Recommended size values:\n"
echo "╭ Screen resolution -| Font size ---╮"
echo "|-----------------------------------|"
echo "| 1280×720 (HD)      | 28           |"
echo "| 1920x1080 (FullHD) | 42 (default) |"
echo "| 2560×1440 (2K/QHD) | 56           |"
echo "| 3840×2160 (4K/UHD) | 84           |"
echo "╰-----------------------------------╯"
echo
read -rp "Your size: " font_size

if ! [[ "$font_size" =~ ^[0-9]+$ ]]; then
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
sudo grub-mkfont -s "$font_size" -o "$NEW_FONT_PATH" "$FONT_SRC"

# Update theme.txt
update_theme_file() {
  local theme_file="$1"

  if [[ ! -f "$theme_file" ]]; then
    echo "Error: theme file is missing."
    exit 1
  fi

  echo "🗒️ Updating font reference in '$theme_file'..."

  # Replace font name occurrences
  sudo sed -i -E "s|(${FONT_NAME})[[:space:]]*[0-9]+|\1 ${font_size}|g" "$theme_file"
}

update_theme_file "$THEME_FILE"

echo "Font reference set to '${FONT_NAME} ${font_size}'."
echo "Done!"
