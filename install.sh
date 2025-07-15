
#!/bin/bash

set -e  # Exit if any command fails

echo "📥 Installing Oh My Zsh..."
RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo "📦 Installing zsh-autosuggestions..."
git clone https://github.com/zsh-users/zsh-autosuggestions \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# Automatically detect the dotfiles directory
DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
BACKUP_DIR="$HOME/dotfiles_backup"

# Files and folders to symlink from $HOME
FILES=(.zshrc)
FOLDERS=()

# .config subfolders to link individually
CONFIG_DIRS=(
  kitty
  hypr
  wlogout
  waybar
  gtk-3.0
  gtk-4.0
  rofi
)

echo "📁 Creating backup directory at $BACKUP_DIR"
mkdir -p "$BACKUP_DIR"

# Symlink home-level dotfiles
echo "🔗 Symlinking home files..."
for file in "${FILES[@]}"; do
  if [ -e "$HOME/$file" ]; then
    echo "📤 Backing up $file"
    mv "$HOME/$file" "$BACKUP_DIR/"
  fi
  ln -sfn "$DOTFILES_DIR/$file" "$HOME/$file"
done

# Symlink home-level folders (like .vim)
echo "🔗 Symlinking folders..."
for folder in "${FOLDERS[@]}"; do
  if [ -e "$HOME/$folder" ]; then
    echo "📤 Backing up $folder"
    mv "$HOME/$folder" "$BACKUP_DIR/"
  fi
  ln -sfn "$DOTFILES_DIR/$folder" "$HOME/$folder"
done

# Symlink .config subdirectories
echo "🔗 Symlinking .config directories..."
for dir in "${CONFIG_DIRS[@]}"; do
  if [ -e "$HOME/.config/$dir" ]; then
    echo "📤 Backing up .config/$dir"
    mv "$HOME/.config/$dir" "$BACKUP_DIR/"
  fi
  ln -sfn "$DOTFILES_DIR/.config/$dir" "$HOME/.config/$dir"
done

# Create screenshot folder
echo "🖼️ Creating Screenshot folder..."
mkdir -p ~/Pictures/Screenshots
echo "✅ Screenshot directory created"

# Install packages
echo "📦 Installing packages..."
sudo pacman -S --noconfirm gtklock zoxide tealdeer gammastep kitty waybar network-manager-applet wl-clipboard tldr gsettings-desktop-schemas dconf

# Change shell to zsh
echo "💻 Changing shell to Zsh..."
chsh -s "$(which zsh)"

# Add execute permission to volume script if it exists
VOLUME_SCRIPT="$HOME/.config/waybar/CustomScripts/volume"
if [ -f "$VOLUME_SCRIPT" ]; then
  echo "🔐 Adding execute permission to volume script"
  chmod +x "$VOLUME_SCRIPT"
else
  echo "⚠️ Volume script not found at $VOLUME_SCRIPT"
fi

echo "✅ Setup complete!"

