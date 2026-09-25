# <p align="center"> :cocktail: Grubhalla :cocktail: </p>
### <p align="center"> <i> · Cyberpunk Sysadmin Action · </i> </p>

<p align="center">
  <img src="/assets/preview.png" alt="Theme preview" />
</p>

> [!NOTE]
> This project is a fork of [valhallaDots](https://github.com/happyzxzxz/valhallaDots) by happyzxzxz

## :hammer_and_wrench: Installation

> :warning: Make sure your GRUB directory is `/boot/grub`

```bash
# clone this repo
git clone https://github.com/kexiku/valhalla.git
cd valhalla

# run the installation script
 chmod +x install.sh
./install.sh
```

### :screwdriver: Manual installation

If you'd like to do the work manually:

- Clone this repo:

```bash
git clone https://github.com/kexiku/valhalla.git
```

- Resize the GRUB background image with ImageMagick:  
  <details>
  <summary><i>Why?</i></summary>

  Cause it's the only workaround to keep the theme's layout consistent across different screen resolutions
  </details>

```bash
# Set your screen resolution:
export SCREEN_WIDTH=1920 # for FUllHD screens
export SCREEN_HEIGHT=1080 # for FUllHD screens

# Find 90% of your screen height:
export GRUB_BG_HEIGHT=$(echo $((${SCREEN_HEIGHT} * 90 / 100)))

# Resize the background image:
magick convert valhalla/valhalla/background_original.png \
  -resize x${GRUB_BG_HEIGHT} \
  -gravity NorthWest \
  -background none \
  -extent ${SCREEN_WIDTH}x${SCREEN_HEIGHT} \
  valhalla/valhalla/background.png
```

- Copy the theme directory to the custom themes folder:

```bash
sudo mkdir /boot/grub/themes # if it doesn't exist
sudo cp -r valhalla/valhalla /boot/grub/themes
```

- Open GRUB config (`/etc/default/grub`)

- Add these lines to the end of the config file:

```bash
# Path to custom theme
GRUB_THEME="/boot/grub/themes/valhalla/theme.txt"

# Path to custom background
GRUB_BACKGROUND="/boot/grub/themes/valhalla/background.png"
```

- Rebuild the config file:

```bash
sudo update-grub # Debian | Ubuntu
sudo grub-mkconfig -o /boot/grub/grub.cfg # Arch
sudo grub2-mkconfig -o /boot/grub2/grub.cfg # Fedora
```

### :toolbox: Troubleshooting

If your resolution is something else than `1920x1080`, you might need to change the font size:

```bash
chmod +x changeFont.sh
sudo ./changeFont.sh <size> # default for FullHD is 42
```

### <p align="center"> 𓆩♡𓆪 </p>
