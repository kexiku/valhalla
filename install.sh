#!/bin/bash
set -euo pipefail

# Locate script directory
SOURCE_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

# Set GRUB update command
if command -v update-grub &>/dev/null; then
  GRUB_UPDATE="update-grub"

elif command -v grub-mkconfig &>/dev/null; then
  GRUB_UPDATE="grub-mkconfig -o /boot/grub/grub.cfg"

elif command -v grub2-mkconfig &>/dev/null; then
  GRUB_UPDATE="grub2-mkconfig -o /boot/grub2/grub.cfg"

else
  echo "Error: Could not find a GRUB configuration command." >&2
  exit 1
fi

# Locate GRUB directory
GRUB_DIR=""

for dir in /boot/grub /boot/grub2; do
  if [[ -d $dir ]]; then
    GRUB_DIR=$dir
    break
  fi
done

if [[ -z $GRUB_DIR ]]; then
  echo "Error: could not locate the GRUB directory." >&2
  exit 1
fi

# Other variables
FONTS_DIR="${HOME}/.local/share/fonts"
THEME_DIR="${GRUB_DIR}/themes/valhalla"
THEME_FILE="${THEME_DIR}/theme.txt"
BACKGROUND="${THEME_DIR}/background.png"

# Copy theme directory
echo "🍺 Adding GRUB theme..."

need_sudo_password() {
  ! sudo -n true 2>/dev/null
}

if need_sudo_password; then
  echo "⚠️ Root privileges are required to write to the ${GRUB_DIR}"
fi

sudo mkdir -p "${GRUB_DIR}/themes"
sudo cp -r "${SOURCE_DIR}/valhalla" "${GRUB_DIR}/themes"

# Edit config
echo "🍹 Mixing properties..."

sudo cp /etc/default/grub /etc/default/grub.bak # Make a config backup

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

# Update GRUB config
echo "🍷 Blending GRUB config..."

echo "[grub]"
sudo "$GRUB_UPDATE"

# Change font size
echo "💡 If your screen resolution differs from 1920x1080, you might want to change the font size."
read -rp "Do you want to change it now? (y/n): " change_font

if [[ "$change_font" =~ ^[Yy]$ ]]; then
  chmod +x "${SOURCE_DIR}/src/change_font.sh"
  "${SOURCE_DIR}/src/change_font.sh"
else
  echo "Fallback to the default font size (42)"
fi

echo "🍸 Served"
