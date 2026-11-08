#!/bin/bash
set -euo pipefail

# Locate script directory
SOURCE_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
export SOURCE_DIR

# Menu
echo -e "▱▱▰▰▰ Welcome to VA-11 Hall-A ▰▰▰▱▱\n"

PS3=$'\n🍸 Choose your flavor: '
options=("Install theme" "Change font" "Quit (q)")

select opt in "${options[@]}"; do
  case "$REPLY" in
    1)
      bash "$SOURCE_DIR/src/install_theme.sh"
      break
      ;;
    2)
      bash "$SOURCE_DIR/src/change_font.sh"
      break
      ;;
    3|q|Q)
      break
      ;;
    *)
      echo "Invalid choice, please enter the correct value."
      ;;
  esac
done
