# GitHub token for tenv/mise release lookups (avoids API rate limits).
# Guarded so only the top-level shell shells out to gh; subshells inherit it.
if [[ -z "$GITHUB_TOKEN" ]] && command -v gh >/dev/null 2>&1; then
  export GITHUB_TOKEN="$(gh auth token 2>/dev/null)"
fi
: "${TENV_GITHUB_TOKEN:=$GITHUB_TOKEN}"
export TENV_GITHUB_TOKEN

# Secrets are read from the macOS Keychain instead of being stored in plain text.
# Manage them with:  security add-generic-password -U -a "$USER" -s <service> -w <value>
# Guarded so only the top-level shell hits the Keychain; subshells inherit the values.
_kc() { security find-generic-password -a "$USER" -s "$1" -w 2>/dev/null; }

if [[ -z "$NPM_AUTH_TOKEN" ]]; then
  export NPM_AUTH_TOKEN="$(_kc npm_auth_token)"
fi
export NODE_AUTH_TOKEN=$NPM_AUTH_TOKEN
export GITHUB_NPM_AUTH_TOKEN=$NPM_AUTH_TOKEN
export GITHUB_PAT_TOKEN=$NPM_AUTH_TOKEN

unset -f _kc

# Machine-local env (AWS profiles, account-specific config) — not tracked in dotfiles.
[ -f ~/.zshenv.local ] && source ~/.zshenv.local
