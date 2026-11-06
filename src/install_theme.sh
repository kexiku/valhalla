#!/bin/bash
set -euo pipefail

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
echo "If your screen resolution differs from 1920x1080, you might want to change the font size."
read -rp "Do you want to change it now? (y/n): " change_font

if [[ "$change_font" =~ ^[Yy]$ ]]; then
  source "${SOURCE_DIR}/src/change_font.sh"
fi

echo "🍸 Served"
exit 0
