#!/bin/bash
set -e

SOURCE_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

FONTS_DIR="$HOME/.local/share/fonts"
GRUB_THEMES_DIR="/boot/grub/themes"
THEME_FILE="${GRUB_THEMES_DIR}/valhalla/theme.txt"
BACKGROUND="${GRUB_THEMES_DIR}/valhalla/background.png"

# Copy fonts
echo "🍷 Preparing fonts..."

mkdir -p "$FONTS_DIR"
cp -r "$SOURCE_DIR"/fonts/* "$FONTS_DIR"

# Copy theme directory
echo "🍸 Adding GRUB theme..."

sudo mkdir -p "$GRUB_THEMES_DIR"
sudo cp -r "${SOURCE_DIR}/valhalla" "$GRUB_THEMES_DIR"

# Edit config
echo "🍹 Mixing properties..."

if grep -q "^GRUB_THEME=" /etc/default/grub; then
  sudo sed -i "s|^GRUB_THEME=.*|GRUB_THEME=\"$THEME_FILE\"|" /etc/default/grub
else
  {
    echo "# Custom theme"
    echo "GRUB_THEME=\"$THEME_FILE\""
  } | sudo tee -a /etc/default/grub >/dev/null
fi

if grep -q "^GRUB_BACKGROUND=" /etc/default/grub; then
  sudo sed -i "s|^GRUB_BACKGROUND=.*|GRUB_BACKGROUND=\"$BACKGROUND\"|" /etc/default/grub
else
  {
    echo "# Custom background picture"
    echo "GRUB_BACKGROUND=\"$BACKGROUND\""
  } | sudo tee -a /etc/default/grub >/dev/null
fi

# Update config
echo "🥃 Blending GRUB config..."

if command -v update-grub &>/dev/null; then
  sudo update-grub

elif command -v grub2-mkconfig &>/dev/null; then
  sudo grub2-mkconfig -o /boot/grub2/grub.cfg

elif command -v grub-mkconfig &>/dev/null; then
  sudo grub-mkconfig -o /boot/grub/grub.cfg

else
  echo "Error: Could not find a GRUB configuration command."
  exit 1
fi

# Change font size
echo "If your screen resolution differs from 1920x1080, you might want to change the font size."
read -rp "Do you want to change it now? (y/n): " change_font

if [[ "$change_font" =~ ^[Yy]$ ]]; then
  chmod +x "${SOURCE_DIR}/change_font.sh"
  "${SOURCE_DIR}/change_font.sh"
else
  echo "Fallback to the default font size (42)."
fi

echo "🍺 Served."
