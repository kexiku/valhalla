# GRUB variables
source "${ROOT_DIR}/lib/grub.sh"

GRUB_DIR=$(get_grub_dir) || exit 1
GRUB_MKCONFIG=$(get_grub_mkconfig) || exit 1
GRUB_MKFONT=$(get_grub_mkfont) || exit 1

# Theme variables
THEME_DIR="${GRUB_DIR}/themes/valhalla"
THEME_FILE="${THEME_DIR}/theme.txt"
BACKGROUND="${THEME_DIR}/background.png"

# Font variables
FONT_NAME="CyberpunkWaifus"
FONT_SRC="${ROOT_DIR}/fonts/${FONT_NAME}.ttf"
