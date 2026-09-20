# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

Personal macOS dotfiles, managed with GNU `stow`. Each top-level directory is a stow "package" whose contents mirror `$HOME` (e.g. `zsh/.zshrc` → `~/.zshrc`).

## Commands

```bash
./install.sh          # installs Homebrew + stow, brew bundle from homebrew/Brewfile, stows zsh git mise
./uninstall.sh         # removes symlinks (stow -D) for zsh git
./update-brewfile.sh   # regenerates homebrew/Brewfile from current system state (brew bundle dump --force)
./macos/defaults.sh    # applies macOS system defaults (Finder, Dock, trackpad, screenshots); destructive/idempotent `defaults write` calls, restarts Finder/Dock
```

Stow is called explicitly per package (`stow -d "$DOTFILES_DIR" -t ~ zsh git mise`) — `uninstall.sh` only unstows `zsh git` (not `mise`), keep that in sync if packages change.

## Structure

- `zsh/` — `.zshrc` (interactive shell config: PATH, mise/nvm/fzf/docker-completions activation, prompt), `.aliases`, `.zshenv` (secrets/tokens, loaded for every shell incl. non-interactive)
- `git/` — `.gitconfig` (tracked, no identity), `.gitconfig.local.template` (copy to `~/.gitconfig.local`, gitignored, holds `user.name`/`email`/`signingkey`), `.gitignore_global`
- `homebrew/Brewfile` — full package list (brew/cask/mas/vscode); regenerate via `update-brewfile.sh`, don't hand-edit entries that came from `brew bundle dump`
- `mise/.config/mise/config.toml` — polyglot tool versions (java, gradle, maven, kotlin, node, pnpm, yarn), activated from `.zshrc`
- `macos/defaults.sh` — one-shot system preference script, not idempotent-safe to re-run blindly (kills Finder/Dock)

## Secrets model

- `~/.gitconfig.local` and `~/.zshenv.local` are machine-local and gitignored — never add real credentials to tracked files.
- Runtime secrets (npm/GitHub tokens) are pulled from the macOS Keychain in `.zshenv` via `security find-generic-password`, not stored in the repo.

## Conventions

- Alias names in `.aliases` use camelCase for multi-word aliases (e.g. `dockerRemoveDanglingVolumes`), short lowercase for common ones (`dc`, `k`, `ll`).
- `.zshrc` guards expensive/optional integrations (`nvm`, `fzf`, mise) behind lazy-load or `command -v` checks — follow that pattern when adding new tool activations rather than eval'ing unconditionally at shell start.
