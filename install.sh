#!/bin/bash
set -euo pipefail

# Locate script directory
SOURCE_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
export SOURCE_DIR

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

# Locate GRUB config generator
export GRUB_MKCONFIG=""

for cmd in grub-mkconfig grub2-mkconfig; do
  if command -v $cmd &>/dev/null; then
    GRUB_MKCONFIG=$cmd
    break
  fi
done

if [[ -z $GRUB_MKCONFIG ]]; then
  echo "Error: Could not find a GRUB configuration command." >&2
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
      break
      ;;
    "2")
      bash "$SOURCE_DIR/src/change_font.sh"
      break
      ;;
    "3"|q|Q)
      break
      ;;
    *)
      echo "Invalid choice, please enter the correct value."
      ;;
  esac
done
