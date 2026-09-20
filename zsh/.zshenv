# GitHub token for tenv/mise release lookups (avoids API rate limits).
# Guarded so only the top-level shell shells out to gh; subshells inherit it.
if [[ -z "$GITHUB_TOKEN" ]] && command -v gh >/dev/null 2>&1; then
  export GITHUB_TOKEN="$(gh auth token 2>/dev/null)"
fi
: "${TENV_GITHUB_TOKEN:=$GITHUB_TOKEN}"
export TENV_GITHUB_TOKEN

# npm/registry auth deliberately lives in ~/.npmrc (owner-only), not in the
# environment: .zshenv is sourced for every shell including non-interactive
# ones, so exporting the token here would hand it to every package lifecycle
# script. Secrets that genuinely need to be in the environment belong in
# ~/.zshenv.local, read from the Keychain there.

# Machine-local env (AWS profiles, account-specific config) — not tracked in dotfiles.
[ -f ~/.zshenv.local ] && source ~/.zshenv.local
