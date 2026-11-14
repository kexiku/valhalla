#!/bin/bash
set -euo pipefail

# Load config
source "${ROOT_DIR}/lib/config.sh"

# Copy theme directory
echo "🧊 Adding GRUB theme..."

need_sudo_password() {
  ! sudo -n true 2>/dev/null
}

if need_sudo_password; then
  echo "🚬 Root privileges are required to write to the ${GRUB_DIR}"
fi

sudo mkdir -p "$THEME_DIR"
sudo cp -r "$ROOT_DIR"/valhalla/* "$THEME_DIR"

# Edit config
echo "🍹 Mixing properties..."

# Make a config backup
[[ -f /etc/default/grub.bak ]] || sudo cp /etc/default/grub /etc/default/grub.bak

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
sudo "$GRUB_MKCONFIG" -o "${GRUB_DIR}/grub.cfg"

# Change font size
echo "If your screen resolution differs from 1920x1080, you might want to change the font size."
read -rp "Do you want to change it now? (y/n): " change_font

if [[ "$change_font" =~ ^[Yy]$ ]]; then
  bash "${ROOT_DIR}/src/change_font.sh"
fi

echo "🍸 Served"
