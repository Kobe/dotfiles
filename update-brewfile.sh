#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "Updating Brewfile..."
brew bundle dump --file="$DOTFILES_DIR/homebrew/Brewfile" --force

echo "Done!"
