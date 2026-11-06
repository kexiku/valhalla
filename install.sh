#!/bin/bash
set -euo pipefail

# Locate script directory
export SOURCE_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

# Set GRUB update command
export GRUB_UPDATE=""

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
export GRUB_DIR=""

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

# Theme variables
export THEME_DIR="${GRUB_DIR}/themes/valhalla"
export THEME_FILE="${THEME_DIR}/theme.txt"
export BACKGROUND="${THEME_DIR}/background.png"

# Menu
echo -e "▱▱▰▰▰ Welcome to VA-11 Hall-A ▰▰▰▱▱\n"

PS3=$'\n🍸 Choose your flavor: '
options=("Install theme" "Change font" "Quit (q)")

select opt in "${options[@]}"; do
  case "$REPLY" in
    "1")
      bash "$SOURCE_DIR/src/install_theme.sh"
      exit 0
      ;;
    "2")
      bash "$SOURCE_DIR/src/change_font.sh"
      exit 0
      ;;
    "3"|q)
      exit 0
      ;;
    *)
      echo "Invalid choice, please enter the value between 1-3."
      ;;
  esac
done
