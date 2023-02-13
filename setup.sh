#!/bin/bash

# Setup Arch Linux

# Check internet connection

# Update the system

echo "Upgrading the system"
sudo pacman -Syyuu

GIT_USERNAME=""
GIT_EMAIL=""

# Install packages

echo "Installing packages"
echo "Installing the most import package -> neofetch"

sudo pacman -S --noconfirm neofetch

neofetch

PACKAGES_PACMAN=("base-devel" "chromium" "neovim" "gimp" "zsh" \
                "curl" "inkscape" "vlc" "tmux" "qbittorrent" "github-cli" \
                "discord" "telegram-desktop" "spotify" "zsh" "zsh-completions" \
                "docker" "docker-compose" "noto-fonts" "noto-fonts-emoji" "noto-fonts-cjk" \
                "ttf-liberation" "ttf-droid" "adobe-source-sans-fonts" \
                "ttf-dejavu" "ttf-hack" "ttf-roboto" "ttf-ubuntu-font-family" \
                "ttf-font-awesome" "ttf-joypixels" "ttf-fira-code" "ttf-fira-mono" \
                "ttf-fira-sans" "ttf-fira-mono" "ttf-fira-sans" "ttf-fira-mono" \
                "xfce4" "xfce4-goodies" "plank" "redshift" "hydra" "shotcut" \
                "wine" "wine-mono" "wine_gecko" "winetricks" "lib32-gnutls" \
                "steam" "llvm" "clang" "cmake" "alsa-utils"  "python-pip" \
                "youtube-dl" "obs-studio" "sdl2" "nmap" "lutris" )

PACKAGES_YAY=( "google-chrome" "visual-studio-code-bin" "ttf-ms-win11-auto" "cc65" \
                "heroic-games-launcher-bin" )

for package in "${PACKAGES_PACMAN[@]}"; do
    echo "Installing $package with PACMAN ================================================================="
    sudo pacman -S --noconfirm --needed $package
done

# Set up git
echo "Setting up Git"
echo "Enter your git username"
read GIT_USERNAME
echo "Enter your git email"
read GIT_EMAIL

git config --global user.name "$GIT_USERNAME"
git config --global user.email "$GIT_EMAIL"

git config --global core.editor "nvim"
git config --global core.pager "less -r"
git config --global init.defaultBranch "main"

# generate ssh key
ssh-keygen -t ed25519 -C "$GIT_EMAIL"

# log with github-cli
gh auth login

# Install yay
echo "Installing yay ================================================================="

cd ~
mkdir clones
cd clones
git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si

for package in "${PACKAGES_YAY[@]}"; do
    echo "Installing $package with YAY ================================================================="
    yay -S --noconfirm --needed $package
done

# Set up docker
echo "Setting up docker"
sudo systemctl enable docker --now

# Set up fonts
echo "Setting up fonts"
sudo mkdir -p /usr/local/share/fonts/otf/Caskaydia
cd /usr/local/share/fonts/otf/Caskaydia

sudo wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/CascadiaCode.zip
sudo unzip CascadiaCode.zip
sudo rm CascadiaCode.zip
sudo find . -type f ! -name '*.otf' -delete
sudo fc-cache -fv

cd

# Set up asdf
echo "Setting up asdf"

cd clones
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.11.1
echo '. /opt/asdf-vm/asdf.sh' >> ~/.zshrc
echo '. "$HOME/.asdf/asdf.sh"' >> ~/.bashrc
echo '. "$HOME/.asdf/completions/asdf.bash"' >> ~/.bashrc
source ~/.bashrc

asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
asdf install nodejs latest
asdf global nodejs latest

# Set up rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Set up Lunar vim
echo "Setting up LunarVim"
LV_BRANCH='release-1.2/neovim-0.8' bash <(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/fc6873809934917b470bff1b072171879899a36b/utils/installer/install.sh)

# Set up zsh
echo "Setting up zsh"
sudo chsh -s /bin/zsh $USER

# Set up games
echo "Setting up games"
# ill use Retroarch on Steam
flatpak install flathub org.ppsspp.PPSSPP

# Set up security
echo "Setting up security"
flatpak install flathub com.github.micahflee.torbrowser-launcher

# Set up tmux
echo "Setting up tmux"
echo 'set -g default-terminal "screen-256color"' >> ~/.tmux.conf
echo 'set -g mouse on' >> ~/.tmux.conf

reboot