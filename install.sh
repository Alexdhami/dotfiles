
#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status
set -u  # Treat unset variables as an error

echo "📦 Installing Oh My Zsh..."
RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install Zsh Autosuggestions plugin
git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"

# Automatically detect the dotfiles directory (where this script is)
DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
BACKUP_DIR="$HOME/dotfiles_backup"

# Files and folders to symlink from $HOME
FILES=(.zshrc .profile)
FOLDERS=()

# .config subfolders to link individually
CONFIG_DIRS=(
    kitty
    systemd
    swayidle
    hypr
    wlogout
    waybar
    gtk-3.0
    gtk-4.0
    rofi
)

echo "📁 Creating backup directory at $BACKUP_DIR"
mkdir -p "$BACKUP_DIR"

echo "🔗 Symlinking home files..."
for file in "${FILES[@]}"; do
    if [ -e "$HOME/$file" ]; then
        echo "📦 Backing up $file"
        mv "$HOME/$file" "$BACKUP_DIR/"
    fi
    ln -sfn "$DOTFILES_DIR/$file" "$HOME/$file"
done

echo "🔗 Symlinking home folders..."
for folder in "${FOLDERS[@]}"; do
    if [ -e "$HOME/$folder" ]; then
        echo "📦 Backing up $folder"
        mv "$HOME/$folder" "$BACKUP_DIR/"
    fi
    ln -sfn "$DOTFILES_DIR/$folder" "$HOME/$folder"
done

echo "🔗 Symlinking .config directories..."
for dir in "${CONFIG_DIRS[@]}"; do
    if [ -e "$HOME/.config/$dir" ]; then
        echo "📦 Backing up .config/$dir"
        mv "$HOME/.config/$dir" "$BACKUP_DIR/"
    fi
    ln -sfn "$DOTFILES_DIR/.config/$dir" "$HOME/.config/$dir"
done

echo "🔁 Reloading systemd user services..."

systemctl --user daemon-reexec
systemctl --user daemon-reload
systemctl --user enable --now idle-lock.service
systemctl --user enable --now lid-lock.path

echo "📸 Creating screenshot folder..."
mkdir -p "$HOME/Pictures/Screenshots"

echo "📦 Installing packages..."
sudo pacman -S --noconfirm \
    swaylock \
    swayidle \
    lxappearance \
    zoxide \
    tealdeer \
    gammastep \
    kitty \
    waybar \
    network-manager-applet \
    wl-clipboard \
    tealdeer \
    gsettings-desktop-schemas \
    dconf \ 
sudo pacman -S qt5ct 
sudo pacman -S qt6ct 
sudo pacman -S gnome-themes-extra
sudo pacman -S swayidle 

# Update tldr cache
tldr --update

echo "💻 Changing shell to Zsh..."
chsh -s "$(which zsh)"

echo "🔊 Setting executable permission to volume script..."
chmod +x "$HOME/.config/waybar/CustomScripts/volume"
chmod +x "$HOME/.config/waybar/CustomScripts/volume_up"
echo "✅ Setup complete."

