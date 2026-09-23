#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
BREWFILE="$DOTFILES_DIR/homebrew/Brewfile"

# Entries owned by these files must never end up in the main Brewfile.
SPLIT_FILES=(
    "$DOTFILES_DIR/homebrew/Brewfile.company"
    "$DOTFILES_DIR/homebrew/Brewfile.private"
)

echo "Updating Brewfile..."
brew bundle dump --file="$BREWFILE" --force --no-mas

# On this machine the split-out packages are installed, so the dump above picked
# them up — drop them again, together with the description comment that
# `brew bundle dump` writes above each entry.
EXISTING=()
for f in "${SPLIT_FILES[@]}"; do
    [[ -f "$f" ]] && EXISTING+=("$f")
done

if (( ${#EXISTING[@]} )); then
    TMPFILE="$(mktemp -t Brewfile)"
    trap 'rm -f "$TMPFILE"' EXIT

    awk '
        function key(s) {
            return match(s, /^(brew|cask) "[^"]+"/) ? substr(s, RSTART, RLENGTH) : ""
        }
        FILENAME != ARGV[ARGC-1] { if (key($0) != "") drop[key($0)] = 1; next }
        /^#/ { comment = $0; next }
        {
            if (key($0) == "" || !(key($0) in drop)) {
                if (comment != "") print comment
                print
            }
            comment = ""
        }
    ' "${EXISTING[@]}" "$BREWFILE" > "$TMPFILE"

    mv "$TMPFILE" "$BREWFILE"
    trap - EXIT
fi

echo "Done!"
