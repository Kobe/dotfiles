#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
PRIVATEFILE="$DOTFILES_DIR/homebrew/Brewfile.private"

if [[ ! -f "$PRIVATEFILE" ]]; then
    echo "Missing $PRIVATEFILE"
    exit 1
fi

if ! command -v brew &> /dev/null; then
    echo "Homebrew is not installed — run ./install.sh first."
    exit 1
fi

echo "Installing personal apps from $(basename "$PRIVATEFILE")..."
brew bundle --file="$PRIVATEFILE"

echo "Done!"
