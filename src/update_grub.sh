#!/bin/bash
set -e

echo "[grub]"

if command -v update-grub &>/dev/null; then
  sudo update-grub

elif command -v grub2-mkconfig &>/dev/null; then
  sudo grub2-mkconfig -o /boot/grub2/grub.cfg

elif command -v grub-mkconfig &>/dev/null; then
  sudo grub-mkconfig -o /boot/grub/grub.cfg

else
  echo "Error: Could not find a GRUB configuration command."
  exit 1
fi
