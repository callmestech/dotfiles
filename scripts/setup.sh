#!/bin/bash

set -e  # Stop the script on any error

# Function for displaying messages with highlighting
print_message() {
  echo "====================================================================="
  echo ">>> $1"
  echo "====================================================================="
}

print_message "Starting environment setup..."

# Determine the dotfiles root directory
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$DOTFILES_DIR"

# Install Xcode Command Line Tools if not already installed
if ! xcode-select -p &>/dev/null; then
  print_message "Installing Xcode Command Line Tools..."
  xcode-select --install
  
  # Wait for Command Line Tools installation to complete
  print_message "Press Enter after Xcode Command Line Tools installation completes..."
  read -r
else
  print_message "Xcode Command Line Tools already installed."
fi

# Check for Homebrew and install if not present
if ! command -v brew &>/dev/null; then
  print_message "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  
  # Add Homebrew to PATH for current session
  if [[ -d "/opt/homebrew/bin/" ]]; then
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >>~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -d "/home/linuxbrew/.linuxbrew/bin/" ]]; then
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >>~/.zprofile
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  elif [[ -d "/usr/local/bin/" ]]; then
    echo 'export PATH="/usr/local/bin:$PATH"' >>~/.zprofile
    export PATH="/usr/local/bin:$PATH"
  fi
else
  print_message "Homebrew already installed."
fi

# Install GNU Stow if not installed
if ! command -v stow &>/dev/null; then
  print_message "Installing GNU Stow..."
  brew install stow
else
  print_message "GNU Stow already installed."
fi

# Install everything from a Brewfile
BREWFILE_PATH="$DOTFILES_DIR/brew/.config/Brewfile"
if [ -f "$BREWFILE_PATH" ]; then
  print_message "Installing Homebrew packages from $BREWFILE_PATH..."
  brew bundle --file="$BREWFILE_PATH"
else
  print_message "Brewfile not found at $BREWFILE_PATH"
fi

# Apply configurations using stow
print_message "Applying configurations using GNU Stow..."

# Get list of all directories for stow (with exceptions)
STOW_PACKAGES=()
for dir in */; do
  dir=${dir%*/}  # Remove trailing slash
  if [[ "$dir" != "scripts" && "$dir" != "README.md" && "$dir" != ".git" ]]; then
    STOW_PACKAGES+=("$dir")
  fi
done

if [ ${#STOW_PACKAGES[@]} -eq 0 ]; then
  print_message "No configuration packages found."
else
  # First do a dry run for safety
  print_message "Performing a dry run before applying configurations..."
  stow -nv "${STOW_PACKAGES[@]}" 2>&1 | grep -v "BUG in find_stowed_path" || true
  
  # Ask the user if they want to proceed
  read -p "Apply the configurations shown above? (y/n) " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    # Apply all packages
    stow -v "${STOW_PACKAGES[@]}" 2>&1 | grep -v "BUG in find_stowed_path" || true
    print_message "Configurations successfully applied!"
  else
    print_message "Configuration application canceled."
  fi
fi

print_message "Setup complete! You may need to restart your terminal for all changes to take effect."
