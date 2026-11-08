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

# Locate GRUB config generator
GRUB_MKCONFIG=""

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

# Locate GRUB font converter
GRUB_MKFONT=""

for cmd in grub-mkfont grub2-mkfont; do
  if command -v $cmd &>/dev/null; then
    GRUB_MKFONT=$cmd
    break
  fi
done

if [[ -z $GRUB_MKFONT ]]; then
  echo "Error: Could not find a GRUB font maker." >&2
  exit 1
fi
