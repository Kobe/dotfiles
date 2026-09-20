#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
COMPANYFILE="$DOTFILES_DIR/homebrew/Brewfile.company"

if [[ ! -f "$COMPANYFILE" ]]; then
    echo "Missing $COMPANYFILE"
    exit 1
fi

if ! command -v brew &> /dev/null; then
    echo "Homebrew is not installed — run ./install.sh first."
    exit 1
fi

echo "Installing work packages from $(basename "$COMPANYFILE")..."
brew bundle --file="$COMPANYFILE"

echo "Done!"
