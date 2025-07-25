
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
    fontconfig
    kitty
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



echo "🔗 Symlinking systemd services..."

# Symlink the auto-lock services (those we tracked in Git)
if [ -e "$DOTFILES_DIR/systemd/idle-lock.service" ]; then
    ln -sfn "$DOTFILES_DIR/systemd/idle-lock.service" "$HOME/.config/systemd/user"
fi
if [ -e "$DOTFILES_DIR/systemd/lid-lock.service" ]; then
    ln -sfn "$DOTFILES_DIR/systemd/lid-lock.service" "$HOME/.config/systemd/user"
fi
if [ -e "$DOTFILES_DIR/systemd/lid-lock.path" ]; then
    ln -sfn "$DOTFILES_DIR/systemd/lid-lock.path" "$HOME/.config/systemd/user"
fi

systemctl --user enable --now idle-lock.service
systemctl --user enable --now lid-lock.path

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
    gsettings-desktop-schemas \
    dconf \
    qt5ct \
    qt6ct \
    pipewire \
    pipewire-paulse \
    wireplumber \
    grim \
    slurp \
    libcanberra \
    noto-fonts-emoji \
    rtkit \ 
    bc \ 
    gnome-themes-extra || true# Update tldr cache

tldr --update

fc-cache -fv
echo "💻 Changing shell to Zsh..."
chsh -s "$(which zsh)"
systemctl --user enable --now pipewire pipewire-paulse wireplumber
sudo systemctl enable --now rtkit-daemon.service

echo "🔊 Setting executable permission to volume script..."
chmod +x "$HOME/.config/waybar/CustomScripts/volume"
chmod +x "$HOME/.config/waybar/CustomScripts/volume_up"


echo "✅ Setup complete."

