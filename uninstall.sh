#!/bin/bash
set -e

echo "Removing dotfiles symlinks..."
for f in ~/.zshrc ~/.zshenv ~/.aliases ~/.gitconfig ~/.gitignore_global ~/.gitconfig.local.template ~/.githooks ~/.config/mise/config.toml; do
    [[ -L "$f" ]] && rm "$f"
done

echo "Done!"
