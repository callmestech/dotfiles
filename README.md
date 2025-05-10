# Dotfiles

This repository contains my dotfiles managed with GNU Stow.

## Prerequisites

* [GNU Stow](https://www.gnu.org/software/stow/)
* Git
* Homebrew (for macOS)

## Installation

To set up a new machine:

```bash
# Clone the repository
git clone https://github.com/dotfiles/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# Run the setup script
./scripts/setup.sh
```

## Using GNU Stow

### Basic Usage

Stow creates symbolic links from your home directory to files in your dotfiles repository:

```bash
# Structure:
# ~/.dotfiles/zsh/.zshrc -> creates symlink at ~/.zshrc

# Apply zsh configuration
stow zsh

# Apply multiple configurations
stow zsh vim tmux
```

### Dry Run Mode

To check what Stow will do without making any changes:

```bash
# Show what would happen but don't create symlinks
stow --no --verbose zsh

# Alternative with short flags
stow -nv zsh
```

### Adding Existing Files to Stow Management

To add existing dotfiles to your repository:

```bash
# 1. Create a directory in your repository for the new package
mkdir -p ~/.dotfiles/newconfig/.config

# 2. Use the adopt command to migrate existing files
stow --adopt newconfig

# 3. Revert changes in the repository to restore original content
cd ~/.dotfiles
git reset --hard

# 4. Now make your changes to the files in the repository
```

The `--adopt` command moves existing files into your repository but keeps them working through symlinks.

### Removing Symlinks

```bash
# Remove symlinks for a specific package
stow -D zsh

# Reinstall symlinks (remove and create again)
stow -R zsh
```

## Repository Structure

Each top-level directory in the repository represents a "package":

```
~/.dotfiles/
├── zsh/         # zsh configuration
│   ├── .zshrc
│   └── .zprofile
├── vim/         # vim configuration
│   └── .vimrc
├── brew/        # Homebrew packages
│   └── .config/
│       └── Brewfile
└── scripts/     # Installation scripts
    └── setup.sh
```
