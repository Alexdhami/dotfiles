#!/bin/bash
echo "Installing Oh My Zsh..."
RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

git clone https://github.com/zsh-users/zsh-autosuggestions \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# Automatically detect the dotfiles directory
DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
BACKUP_DIR="$HOME/dotfiles_backup"

# Files and folders to symlink from $HOME
FILES=(
  .zshrc
)

FOLDERS=(
)

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

echo "📦 Creating backup directory at $BACKUP_DIR"
mkdir -p "$BACKUP_DIR"

# Symlink home-level dotfiles
echo "🔗 Symlinking home files..."
for file in "${FILES[@]}"; do
  if [ -e "$HOME/$file" ]; then
    echo "Backing up $file"
    mv "$HOME/$file" "$BACKUP_DIR/"
  fi
  ln -sfn "$DOTFILES_DIR/$file" "$HOME/$file" done
# Symlink home-level folders (like .vim)
echo "🔗 Symlinking folders..."
for folder in "${FOLDERS[@]}"; do
  if [ -e "$HOME/$folder" ]; then
    echo "Backing up $folder"
    mv "$HOME/$folder" "$BACKUP_DIR/"
  fi
  ln -sfn "$DOTFILES_DIR/$folder" "$HOME/$folder"
done

# Symlink .config subdirectories like hypr
echo "🔗 Symlinking .config directories..."
for dir in "${CONFIG_DIRS[@]}"; do
  if [ -e "$HOME/.config/$dir" ]; then
    echo "Backing up .config/$dir"
    mv "$HOME/.config/$dir" "$BACKUP_DIR/"
  fi
  ln -sfn "$DOTFILES_DIR/.config/$dir" "$HOME/.config/$dir"
done

echo "creating Screenshot folder to save the keybinding screenshot shortcut image"
mkdir -p ~/Pictures/Screenshots
echo "Screenshot directory created "

echo "Installing network-manager-applet, kitty, waybar, gtklock,gammastep"
sudo pacman -S gtklock zoxide tealdeer gammastep kitty waybar network-manager-applet wl-clipboard
tldr --update
sudo pacman -S gsettings-desktop-schemas dconf

echo "Changing Shell to Zsh"
chsh -s "$(which zsh)"

echo "adding permission to custom volume script"
chmod +x ~/.config/waybar/CustomScripts/volume

sudo pacman -S gsettings-desktop-schemas dconf
sudo pacman -S gsettings-desktop-schemas dconf
sudo pacman -S gsettings-desktop-schemas dconf
echo "✅ Done! Your dotfiles have been set up."
