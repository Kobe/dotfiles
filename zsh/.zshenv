# npm/registry auth deliberately lives in ~/.npmrc (owner-only), not in the
# environment: .zshenv is sourced for every shell including non-interactive
# ones, so exporting a token here would hand it to every package lifecycle
# script. Secrets that genuinely need to be in the environment belong in
# ~/.zshenv.local, read from the Keychain there.

# Machine-local env (AWS profiles, account-specific config) — not tracked in dotfiles.
[ -f ~/.zshenv.local ] && source ~/.zshenv.local
