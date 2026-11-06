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

# Set GRUB font converter
if command -v grub-mkfont &>/dev/null; then
  GRUB_MKFONT="grub-mkfont"

elif command -v grub2-mkfont &>/dev/null; then
  GRUB_MKFONT="grub2-mkfont"

else
  echo "Error: Could not locate grub-mkfont." >&2
  exit 1
fi

FONT_NAME="CyberpunkWaifus"
USER_FONTS_DIR="$HOME/.local/share/fonts"
FONT_SRC="${USER_FONTS_DIR}/${FONT_NAME}.ttf"

# Copy fonts
echo "🥤 Preparing fonts..."

mkdir -p "$USER_FONTS_DIR"
cp -r "$SOURCE_DIR"/fonts/* "$USER_FONTS_DIR"

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

need_sudo_password() {
  ! sudo -n true 2>/dev/null
}

if need_sudo_password; then
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
sudo "$GRUB_UPDATE"

echo "🍸 Served"
exit 0
