#!/bin/bash

# Install Xcode Command Line Tools if not already installed
if ! xcode-select -p &>/dev/null; then
  echo "Installing Xcode Command Line Tools..."
  xcode-select --install
fi

# Check for Homebrew and install if not present
if ! command -v brew &>/dev/null; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >>~/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  echo "Homebrew is already installed."
fi

# Install everything from a Brewfile at a relative path (e.g., ../Brewfile)
BREWFILE_PATH="../brew/.config/Brewfile"
if [ -f "$BREWFILE_PATH" ]; then
  echo "Installing Homebrew packages from $BREWFILE_PATH..."
  brew bundle --file="$BREWFILE_PATH"
fi
