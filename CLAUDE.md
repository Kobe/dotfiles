# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

Personal macOS dotfiles, managed with GNU `stow`. Each top-level directory is a stow "package" whose contents mirror `$HOME` (e.g. `zsh/.zshrc` → `~/.zshrc`).

## Commands

```bash
./install.sh          # installs Homebrew + stow, brew bundle from homebrew/Brewfile, runs ./install-mas.sh (non-fatal), stows zsh git mise githooks
./install-mas.sh      # Mac App Store apps from homebrew/Brewfile.mas; installs `mas` if missing, then reports outdated apps limited to the ids that file tracks. Standalone-safe, exits non-zero if an app could not be installed
./uninstall.sh         # removes symlinks (stow -D) for zsh git
./install-company.sh   # work-only packages from homebrew/Brewfile.company; deliberately NOT called by install.sh, so a personal machine stays clean
./install-private.sh   # personal apps from homebrew/Brewfile.private (browsers, chat, media, games); also opt-in, same reasoning
./update-brewfile.sh   # regenerates homebrew/Brewfile from current system state (brew bundle dump --force --no-mas), then drops every entry listed in homebrew/Brewfile.company and homebrew/Brewfile.private (plus its description comment) so a dump cannot merge the split files back into the main one
./macos/defaults.sh    # applies macOS system defaults (NSGlobalDomain, Finder, Dock, WindowManager, menu bar clock, screenshots, trackpad, Terminal); destructive/idempotent `defaults write` calls, restarts Finder/Dock/SystemUIServer
```

Stow is called explicitly per package (`stow -d "$DOTFILES_DIR" -t ~ zsh git mise githooks`) — `install.sh` and `uninstall.sh` list the packages separately, keep both in sync if packages change.

## Structure

- `zsh/` — `.zshrc` (interactive shell config: PATH, mise/nvm/fzf/docker-completions activation, prompt), `.aliases`, `.zshenv` (secrets/tokens, loaded for every shell incl. non-interactive)
- `git/` — `.gitconfig` (tracked, no identity), `.gitconfig.local.template` (copy to `~/.gitconfig.local`, gitignored, holds `user.name`/`email`/`signingkey`), `.gitignore_global`
- `homebrew/Brewfile` — the tooling a dotfiles checkout needs: `tap`, `brew`, `cask`, `npm`. Regenerate via `update-brewfile.sh`, don't hand-edit entries that came from `brew bundle dump`. Holds no `mas` lines (`--no-mas`) and no `vscode` lines — VS Code was removed from this setup.
- `homebrew/Brewfile.company` — work-only packages (3 formulae, 6 casks), split out so a personal machine doesn't pull in company tooling. Installed only via `./install-company.sh`.
- `homebrew/Brewfile.private` — personal-machine apps (22 casks: browsers, chat, media, design, Steam), so the main Brewfile stays the tooling a dotfiles checkout needs. Installed only via `./install-private.sh`.
- Both split files are filtered back out of `homebrew/Brewfile` by `update-brewfile.sh` after every dump. Add entries to them by hand — nothing moves packages between the files automatically. Keep the `SPLIT_FILES` array in `update-brewfile.sh` in sync if another split file is added.
- `homebrew/Brewfile.mas` — Mac App Store apps, **hand-curated, games deliberately excluded**. Never touched by `brew bundle dump` (`update-brewfile.sh` passes `--no-mas`), so newly installed App Store apps are not picked up automatically — add them here by hand. Installed via `./install-mas.sh`, which `install.sh` calls non-fatally — `mas install` needs a signed-in Apple Account that already owns each app, and mas 7 dropped `mas account`, so there is no way to check that up front.
- `mise/.config/mise/config.toml` — polyglot tool versions (java, gradle, maven, kotlin, node, pnpm, yarn), activated from `.zshrc`
- `githooks/.githooks/pre-commit` — gitleaks scan of staged changes, applied to every repo via `core.hooksPath` in `.gitconfig`; exits 0 when gitleaks is absent so a fresh machine isn't blocked
- `macos/defaults.sh` — one-shot system preference script, not idempotent-safe to re-run blindly (kills Finder/Dock/SystemUIServer). Values mirror the working machine, not Apple's stock defaults; keys already matching stock are deliberately omitted. Trackpad keys are written to both `com.apple.AppleMultitouchTrackpad` (built-in) and `com.apple.driver.AppleBluetoothMultitouch.trackpad` (Magic Trackpad) — they don't share storage. Screenshot location needs all three of `location`, `location-screenshot`, `location-screenrecording`; the bare `location` key is a no-op from macOS 15 on.

## Secrets model

- `~/.gitconfig.local` and `~/.zshenv.local` are machine-local and gitignored — never add real credentials to tracked files.
- Runtime secrets (npm/GitHub tokens) are pulled from the macOS Keychain in `.zshenv` via `security find-generic-password`, not stored in the repo.

## Conventions

- Alias names in `.aliases` use camelCase for multi-word aliases (e.g. `dockerRemoveDanglingVolumes`), short lowercase for common ones (`dc`, `k`, `ll`).
- `.zshrc` guards expensive/optional integrations (`nvm`, `fzf`, mise) behind lazy-load or `command -v` checks — follow that pattern when adding new tool activations rather than eval'ing unconditionally at shell start.
