#!/usr/bin/env bash
# Quickly configure Fedora 42 with Niri WM
# Get Everything iso and install with only "Custom" selected

# Ensure script is run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root. Please run with sudo or as the root user." 1>&2
   exit 1
fi

echo -e "\e[32;1mInstalling group packages\e[m\n"
dnf group install -y \
core \
networkmanager-submodules \
multimedia \
libreoffice \
printing

echo -e "\e[32;1mEnabling RPM Fusion and codecs\e[m\n"
dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
# Codecs
dnf config-manager setopt fedora-cisco-openh264.enabled=1
dnf swap -y ffmpeg-free ffmpeg --allowerasing
dnf update -y @multimedia --setopt="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin
# AMD acceleration
dnf swap -y mesa-va-drivers mesa-va-drivers-freeworld
dnf swap -y mesa-vdpau-drivers mesa-vdpau-drivers-freeworld
# Intel acceleration
# dnf install -y intel-media-driver

echo -e "\e[32;1mEnabling SDDM and Plymouth\e[m\n"
dnf install -y tuigreet plymouth-system-theme
systemctl enable greetd
systemctl set-default graphical.target
plymouth-set-default-theme spinner -R

cp greetd.conf /etc/greetd/config.toml

echo -e "\e[32;1mInstalling system essentials\e[m\n"

dnf install -y $(< ./swaypackages.txt)

# Spotify
# echo -e "\n\e[32;1mInstalling Spotify...\e[m\n"
# dnf config-manager addrepo --from-repofile=https://negativo17.org/repos/fedora-spotify.repo
# sudo dnf up
# sudo dnf install -y spotify-client

# Remove localsearch package
echo "--------------------------------------------------------"
echo "Installation complete!"
echo "Please take the following steps to finalize your setup:"
echo "1. Reboot the system."
echo "2. Copy your dotfiles with stow.:"
echo "--------------------------------------------------------"
