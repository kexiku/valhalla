# <p align="center"> :cocktail: Grubhalla :cocktail: </p>
### <p align="center"> <i> · Cyberpunk Sysadmin Action · </i> </p>

<p align="center">
  <img src="/assets/preview.png" alt="Theme preview" />
</p>

> [!NOTE]
> This project is a fork of [valhallaDots](https://github.com/happyzxzxz/valhallaDots) by happyzxzxz

### Fork changes

- Add terminal background image
- Clean everything except GRUB theme
- Make installation more accessible for different setups

## :takeout_box: Installation

> :warning: Make sure your GRUB directory is `/boot/grub`

```bash
# clone this repo
git clone https://github.com/kexiku/valhalla.git

# run the installation script
 chmod +x install.sh
./install.sh
```

## :ramen: Manual installation

If you prefer the DIY way:

- Clone this repo:

```bash
git clone https://github.com/kexiku/valhalla.git
```

- Copy the theme directory to the GRUB themes folder:

```bash
sudo mkdir -p /boot/grub/themes
sudo cp -r ./valhalla/valhalla /boot/grub/themes
```

- Open GRUB config (`/etc/default/grub`)

- Add these lines to the end of the config file:

```bash
# Custom theme
GRUB_THEME="/boot/grub/themes/valhalla/theme.txt"

# Custom background picture
GRUB_BACKGROUND="/boot/grub/themes/valhalla/background.png"
```

- Rebuild the config file:

```bash
sudo update-grub # Debian | Ubuntu
sudo grub-mkconfig -o /boot/grub/grub.cfg # Arch
sudo grub2-mkconfig -o /boot/grub2/grub.cfg # Fedora
```

### :black_cat: Troubleshooting

If your resolution is something else than `1920x1080`, you might want to change the font size:

```bash
cd ./valhalla/src
chmod +x change_font.sh
sudo ./change_font.sh
```

### <p align="center"> 𓆩♡𓆪 </p>
