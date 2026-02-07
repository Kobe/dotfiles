# my dotfiles

personal selection of my most important dotfiles.

## Installation

```bash
git clone git@github.com:Kobe/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

## Post-Install

```bash
# Copy and edit local git config
cp ~/.gitconfig.local.template ~/.gitconfig.local
vi ~/.gitconfig.local

# Apply macOS defaults (optional)
./macos/defaults.sh
```

## Update Brewfile

```bash
./update-brewfile.sh
```

## Uninstall

```bash
./uninstall.sh
```

## Packages

| Package | Contents |
|---------|----------|
| **zsh/** | .zshrc, .aliases |
| **git/** | .gitconfig, .gitignore_global, .gitconfig.local.template |
| **homebrew/** | Brewfile |
| **macos/** | defaults.sh (System-Einstellungen) |
