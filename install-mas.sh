#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
MASFILE="$DOTFILES_DIR/homebrew/Brewfile.mas"

if [[ ! -f "$MASFILE" ]]; then
    echo "Missing $MASFILE"
    exit 1
fi

if ! command -v brew &> /dev/null; then
    echo "Homebrew is not installed — run ./install.sh first."
    exit 1
fi

# The main Brewfile declares mas, but this script is also meant to run on its
# own, so don't assume ./install.sh has been through already.
if ! command -v mas &> /dev/null; then
    echo "Installing mas..."
    brew install mas
fi

# mas 7 dropped `mas account`, so there is no way to test for a signed-in Apple
# Account up front — an unauthenticated run simply fails per app. Let it try and
# explain the likely cause afterwards.
echo "Installing Mac App Store apps from $(basename "$MASFILE")..."
if brew bundle --file="$MASFILE"; then
    echo "Done!"
else
    echo
    echo "One or more apps could not be installed. Common causes:"
    echo "  - not signed in to the App Store (open App Store.app and sign in)"
    echo "  - the Apple Account does not own the app yet — mas cannot buy it"
    echo "  - the app is not available in this account's country store"
    echo
    echo "Re-run this script once resolved; installed apps are skipped."
    exit 1
fi

# Surface updates while we are here — `brew bundle` installs but never upgrades.
# `mas outdated` covers every App Store app, including the ones deliberately kept
# out of Brewfile.mas, so restrict it to the ids this file actually tracks.
IDS="$(sed -n 's/^mas .*id: \([0-9][0-9]*\).*/\1/p' "$MASFILE")"
if [[ -n "$IDS" ]]; then
    OUTDATED="$(mas outdated 2>/dev/null | grep -E "^($(echo "$IDS" | paste -sd'|' -))[[:space:]]" || true)"
    if [[ -n "$OUTDATED" ]]; then
        echo
        echo "Outdated apps from this Brewfile (upgrade with 'mas upgrade <id>'):"
        echo "$OUTDATED" | sed 's/^/  /'
    fi
fi
