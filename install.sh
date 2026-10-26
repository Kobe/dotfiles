#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "Installing dotfiles from $DOTFILES_DIR"

# Install Homebrew if not present
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to PATH for this session
    if [[ -f /opt/homebrew/bin/brew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -f /usr/local/bin/brew ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi
fi

# Install packages from Brewfile
echo "Installing Homebrew packages..."
brew bundle --file="$DOTFILES_DIR/homebrew/Brewfile"

# Setup fzf key bindings and completions
if [[ -f /opt/homebrew/opt/fzf/install ]]; then
    echo "Setting up fzf..."
    /opt/homebrew/opt/fzf/install --key-bindings --completion --no-update-rc --no-bash --no-fish
fi

# Link dotfiles
echo "Linking dotfiles..."
ln -sfn "$DOTFILES_DIR/zsh/.zshrc" ~/.zshrc
ln -sfn "$DOTFILES_DIR/zsh/.zshenv" ~/.zshenv
ln -sfn "$DOTFILES_DIR/zsh/.aliases" ~/.aliases
ln -sfn "$DOTFILES_DIR/git/.gitconfig" ~/.gitconfig
ln -sfn "$DOTFILES_DIR/git/.gitignore_global" ~/.gitignore_global
ln -sfn "$DOTFILES_DIR/git/.gitconfig.local.template" ~/.gitconfig.local.template
ln -sfn "$DOTFILES_DIR/githooks/.githooks" ~/.githooks
mkdir -p ~/.config/mise
ln -sfn "$DOTFILES_DIR/mise/.config/mise/config.toml" ~/.config/mise/config.toml

echo "Done!"
