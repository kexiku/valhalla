#!/bin/bash
set -euo pipefail

# Find root directory
ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
export ROOT_DIR

# Menu
echo -e "▱▱▰▰▰▰▰ \033[1;36mWelcome to VA-11 Hall-A\033[0m ▰▰▰▰▰▱▱\n"

PS3=$'\n🍸 Choose your flavor: '
options=("Install theme" "Change font" "Quit (q)")

select opt in "${options[@]}"; do
  case "$REPLY" in
    1)
      bash "${ROOT_DIR}/src/install_theme.sh"
      break
      ;;
    2)
      bash "${ROOT_DIR}/src/change_font.sh"
      break
      ;;
    3|q)
      break
      ;;
    *)
      echo "⚠️ Invalid value, please choose the correct option (1-3)"
      ;;
  esac
done
