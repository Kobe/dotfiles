#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "Removing dotfiles symlinks..."
stow -d "$DOTFILES_DIR" -t ~ -D zsh git mise githooks

echo "Done!"
