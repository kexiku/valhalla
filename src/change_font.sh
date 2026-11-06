#!/bin/bash
set -euo pipefail

# Check if theme installed
if [[ ! -f "$THEME_FILE" ]]; then
  echo "⚠️ Could not locate the theme file in ${THEME_DIR}"
  echo "Seems like the theme isn't installed on your system."
  read -rp "Do you want to install it now? (y/n): " install_theme

if [[ "$install_theme" =~ ^[Yy]$ ]]; then
  source "${SOURCE_DIR}/src/install_theme.sh"
  exit 0
else
  echo "Error: ${THEME_FILE} is missing." >&2
  exit 1
fi

# Locate GRUB font converter
GRUB_MKFONT=""

for cmd in grub-mkfont grub2-mkfont; do
  if command -v $cmd &>/dev/null; then
    GRUB_MKFONT=$cmd
    break
  fi
done

if [[ -z $GRUB_MKFONT ]]; then
  echo "Error: Could not find a GRUB font maker." >&2
  exit 1
fi

FONT_NAME="CyberpunkWaifus"
FONT_SRC="${SOURCE_DIR}/fonts/${FONT_NAME}.ttf"

# Define font size
echo -e "Write your preferred font size.\n"
echo -e "📐 Recommended size values:\n"
echo "╭ Screen resolution -| Font size ---╮"
echo "|-----------------------------------|"
echo "| 1280×720 (HD)      | 28           |"
echo "| 1920x1080 (FullHD) | 42 (default) |"
echo "| 2560×1440 (2K/QHD) | 56           |"
echo "| 3840×2160 (4K/UHD) | 84           |"
echo "╰-----------------------------------╯"
echo

read -rp "Your size: " font_size

if ! [[ "$font_size" =~ ^[1-9][0-9]*$ ]]; then
  echo "Error: size must be a positive integer."
  exit 1
fi

# Generate font
echo "🥃 Generating GRUB font..."

NEW_FONT_PATH="${THEME_DIR}/${FONT_NAME}${font_size}.pf2"

sudo_password_expired() {
  ! sudo -n true 2>/dev/null
}

if sudo_password_expired; then
  echo "⚠️ Root privileges are required to write to the ${GRUB_DIR}"
fi

sudo "$GRUB_MKFONT" -s "$font_size" -o "$NEW_FONT_PATH" "$FONT_SRC"

# Update theme.txt
echo "🍶 Updating font reference in ${THEME_FILE}..."

sudo sed -i -E "s|(${FONT_NAME})[[:space:]]*[0-9]+|\1 ${font_size}|g" "$THEME_FILE"

echo "Font reference set to '${FONT_NAME} ${font_size}'."

# Update GRUB config
echo "🍷 Blending GRUB config..."

echo "[grub]"
sudo "$GRUB_MKCONFIG" -o "${GRUB_DIR}/grub.cfg"

echo "🍸 Served"
exit 0
