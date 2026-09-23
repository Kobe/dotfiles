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

# Install stow if not present
if ! command -v stow &> /dev/null; then
    echo "Installing stow..."
    brew install stow
fi

# Install packages from Brewfile
echo "Installing Homebrew packages..."
brew bundle --file="$DOTFILES_DIR/homebrew/Brewfile"

# Mac App Store apps are tracked separately. Needs an Apple Account signed in to
# the App Store that already owns each app, so failure is not fatal here — a
# fresh machine should still get its dotfiles linked.
if ! "$DOTFILES_DIR/install-mas.sh"; then
    echo "Continuing without them — re-run ./install-mas.sh once signed in."
fi

# Setup fzf key bindings and completions
if [[ -f /opt/homebrew/opt/fzf/install ]]; then
    echo "Setting up fzf..."
    /opt/homebrew/opt/fzf/install --key-bindings --completion --no-update-rc --no-bash --no-fish
fi

# Stow dotfiles
echo "Linking dotfiles..."
stow -d "$DOTFILES_DIR" -t ~ zsh git mise githooks

echo "Done!"
