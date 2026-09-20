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
# Copy and edit local git config (holds name, email, signing key)
cp ~/.gitconfig.local.template ~/.gitconfig.local
vi ~/.gitconfig.local

# Optional machine-local overrides, both sourced only if present
vi ~/.zshenv.local      # env vars, AWS profiles
vi ~/.aliases_company   # company/project-specific aliases

# Keep anything machine-local owner-only
chmod 600 ~/.gitconfig.local ~/.zshenv.local ~/.aliases_company

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
| **zsh/** | .zshrc, .aliases, .zshenv |
| **git/** | .gitconfig, .gitignore_global, .gitconfig.local.template |
| **homebrew/** | Brewfile |
| **mise/** | .config/mise/config.toml (tool versions) |
| **macos/** | defaults.sh (system preferences) |

Machine-local files are not part of any package and stay untracked:
`~/.gitconfig.local`, `~/.zshenv.local`, `~/.aliases_company`.
