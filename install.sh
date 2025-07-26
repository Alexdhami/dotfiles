
#!/bin/bash

set -e
set -u

echo "📦 Installing Oh My Zsh..."
RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo "🔌 Cloning Zsh Autosuggestions..."
git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
BACKUP_DIR="$HOME/dotfiles_backup"

FILES=(.zshrc .profile)
FOLDERS=()

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
mkdir -p "$HOME/.config/systemd/user"

echo "🔗 Ensuring and symlinking systemd services..."
for service in idle-lock.service lid-lock.service lid-lock.path; do
    SOURCE="$DOTFILES_DIR/systemd/$service"
    TARGET="$HOME/.config/systemd/user/$service"

    if [ ! -f "$SOURCE" ]; then
        echo "🆕 Creating empty systemd service: $SOURCE"
        mkdir -p "$(dirname "$SOURCE")"
        touch "$SOURCE"
    fi

    ln -sfn "$SOURCE" "$TARGET"
done

echo "🔗 Symlinking home files..."
for file in "${FILES[@]}"; do
    if [ -e "$HOME/$file" ]; then
        echo "📦 Backing up $file"
        mv "$HOME/$file" "$BACKUP_DIR/"
    fi

    if [ ! -f "$DOTFILES_DIR/$file" ]; then
        echo "🆕 Creating empty file: $DOTFILES_DIR/$file"
        touch "$DOTFILES_DIR/$file"
    fi

    ln -sfn "$DOTFILES_DIR/$file" "$HOME/$file"
done

echo "🔗 Symlinking home folders..."
for folder in "${FOLDERS[@]}"; do
    if [ -e "$HOME/$folder" ]; then
        echo "📦 Backing up $folder"
        mv "$HOME/$folder" "$BACKUP_DIR/"
    fi

    if [ ! -d "$DOTFILES_DIR/$folder" ]; then
        echo "🆕 Creating empty folder: $DOTFILES_DIR/$folder"
        mkdir -p "$DOTFILES_DIR/$folder"
    fi

    ln -sfn "$DOTFILES_DIR/$folder" "$HOME/$folder"
done

echo "🔗 Symlinking .config directories..."
for dir in "${CONFIG_DIRS[@]}"; do
    if [ -e "$HOME/.config/$dir" ]; then
        echo "📦 Backing up .config/$dir"
        mv "$HOME/.config/$dir" "$BACKUP_DIR/"
    fi

    if [ ! -d "$DOTFILES_DIR/.config/$dir" ]; then
        echo "🆕 Creating empty config dir: $DOTFILES_DIR/.config/$dir"
        mkdir -p "$DOTFILES_DIR/.config/$dir"
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

echo "💻 Changing shell to Zsh..."
chsh -s "$(which zsh)"

echo "🔊 Setting executable permission to volume scripts..."
chmod +x "$HOME/.config/waybar/CustomScripts/volume" || true
chmod +x "$HOME/.config/waybar/CustomScripts/volume_up" || true

echo "✅ Setup complete."

