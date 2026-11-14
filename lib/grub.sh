# Locate GRUB directory
get_grub_dir() {
  local dir

  for dir in /boot/grub /boot/grub2; do
    if [[ -d $dir ]]; then
      echo "$dir"
      return 0
    fi
  done

  echo "Error: could not locate the GRUB directory." >&2
  return 1
}

# Locate GRUB config generator
get_grub_mkconfig() {
  local cmd

  for cmd in grub-mkconfig grub2-mkconfig; do
    if command -v "$cmd" &>/dev/null; then
      echo "$cmd"
      return 0
    fi
  done

  echo "Error: Could not find a GRUB configuration command." >&2
  return 1
}

# Locate GRUB font converter
get_grub_mkfont() {
  local cmd

  for cmd in grub-mkfont grub2-mkfont; do
    if command -v "$cmd" &>/dev/null; then
      echo "$cmd"
      return 0
    fi
  done

  echo "Error: Could not find a GRUB font maker." >&2
  return 1
}
