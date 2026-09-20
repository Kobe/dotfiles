#!/bin/bash
# macOS defaults, mirrored from the working machine (macOS 27).
# Run: ./macos/defaults.sh
#
# Not a full export — a curated set of deliberate preferences. Application state
# (window positions, recent items, view settings per folder, analytics stamps) is
# left out on purpose: it is noise and meaningless on another machine. Same for
# machine-specific values (AppleLocale, display identifiers).
#
# Values are the ones read off the machine, not Apple's stock defaults. Where a key
# already matches stock it is omitted rather than restated.

echo "Configuring macOS defaults..."

# Close System Settings so it cannot overwrite what we write. Guarded by a running
# check: `tell application X to quit` would otherwise launch it just to quit it.
# The pane was renamed in macOS 13 — quitting "System Preferences" is now a no-op.
if pgrep -xq "System Settings"; then
	osascript -e 'tell application "System Settings" to quit' >/dev/null 2>&1
fi

# --- Global (NSGlobalDomain) ---
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
# Full Keyboard Access: Tab moves focus between all controls, not just text fields
defaults write NSGlobalDomain AppleKeyboardUIMode -int 2
defaults write NSGlobalDomain AppleInterfaceStyleSwitchesAutomatically -bool true
# Double-clicking a title bar zooms instead of minimising
defaults write NSGlobalDomain AppleMiniaturizeOnDoubleClick -bool false
# Don't turn horizontal two-finger scrolling into back/forward navigation
defaults write NSGlobalDomain AppleEnableMouseSwipeNavigateWithScrolls -bool false
# Force Click off — it misfires constantly with a low click threshold
defaults write NSGlobalDomain com.apple.trackpad.forceClick -bool false
# German typographic quotes for the smart-quote substitution
defaults write NSGlobalDomain KB_DoubleQuoteOption -string '„abc“'
defaults write NSGlobalDomain KB_SingleQuoteOption -string '‚abc‘'
# No calendar-invite data detectors in text fields
defaults write NSGlobalDomain shouldShowRSVPDataDetectors -bool false

# --- Appearance (cosmetic, macOS 26+) ---
# These keys are new and Apple renames them freely between releases; if a future
# macOS ignores them, drop them rather than hunting for a replacement.
defaults write NSGlobalDomain AppleIconAppearanceTintColor -string "Orange"
defaults write NSGlobalDomain NSGlassDiffusionSetting -bool false

# --- Finder ---
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowSidebar -bool true
# New windows open the Desktop (PfDe); list view by default (Nlsv)
defaults write com.apple.finder NewWindowTarget -string "PfDe"
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
defaults write com.apple.finder FXArrangeGroupViewBy -string "Name"
defaults write com.apple.finder _FXSortFoldersFirst -bool true
# Desktop icons: internal disk off, anything removable on — the signal is "something
# got plugged in", not "this Mac has a disk"
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true
# Purge Trash items older than 30 days
defaults write com.apple.finder FXRemoveOldTrashItems -bool true
# FXICloudDrive{Enabled,Desktop,Documents} are deliberately not written: they are
# status Finder mirrors from CloudDocs, not settings it reads. The switch is in
# System Settings > Apple ID > iCloud Drive, which also migrates the files.

# --- Dock ---
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 1
defaults write com.apple.dock show-recents -bool false
defaults write com.apple.dock tilesize -int 16
# Hot corner bottom-right: Quick Note (14). The modifier is written explicitly as 0
# so the behaviour is reproducible instead of relying on the unset default.
defaults write com.apple.dock wvous-br-corner -int 14
defaults write com.apple.dock wvous-br-modifier -int 0
# Disable the show-desktop and Mission Control trackpad gestures — they fire by
# accident while three-finger swiping between apps
defaults write com.apple.dock showDesktopGestureEnabled -bool false
defaults write com.apple.dock showMissionControlGestureEnabled -bool false

# --- Window Manager (Stage Manager, tiling) ---
# Tiled windows sit flush, no gap between them
defaults write com.apple.WindowManager EnableTiledWindowMargins -bool false
# Remaining keys are mirrored as read off the machine. Apple documents none of them;
# the names are self-describing enough to keep, but don't trust a guessed meaning —
# change them in System Settings and re-read rather than editing values here.
defaults write com.apple.WindowManager HideDesktop -bool true
defaults write com.apple.WindowManager AppWindowGroupingBehavior -int 1
defaults write com.apple.WindowManager AutoHide -bool false
defaults write com.apple.WindowManager StageManagerHideWidgets -bool false
defaults write com.apple.WindowManager StandardHideWidgets -bool false

# --- Menu bar clock ---
# Weekday shown, date not. ShowDate is tri-state, not a boolean — 0 is what the
# machine reports, don't "fix" it to a bool.
defaults write com.apple.menuextra.clock ShowDayOfWeek -bool true
defaults write com.apple.menuextra.clock ShowDate -int 0
defaults write com.apple.menuextra.clock ShowAMPM -bool true

# --- Screenshots ---
# Save to ~/Pictures/Screenshots: /tmp is world-readable and cleared on reboot,
# and screenshots regularly capture tokens or session data.
#
# Three keys, because the plain `location` key is dead: `strings /usr/sbin/screencapture`
# on macOS 27 references only the two per-type keys, so setting `location` alone is a
# silent no-op. It is kept for machines still on macOS 14 or older.
SCREENSHOT_DIR="$HOME/Pictures/Screenshots"
mkdir -p "$SCREENSHOT_DIR"
defaults write com.apple.screencapture location                 -string "$SCREENSHOT_DIR"
defaults write com.apple.screencapture location-screenshot      -string "$SCREENSHOT_DIR"
defaults write com.apple.screencapture location-screenrecording -string "$SCREENSHOT_DIR"
# Default capture mode in the Cmd-Shift-5 UI, and write to file rather than clipboard
defaults write com.apple.screencapture style -string "window"
defaults write com.apple.screencapture target-screenshot -string "file"
defaults write com.apple.screencapture target-screenrecording -string "file"

# --- Trackpad ---
# Written to both domains: AppleMultitouchTrackpad is the built-in trackpad,
# AppleBluetoothMultitouch.trackpad an external Magic Trackpad. They do not share
# storage, so a script touching only the first silently does nothing on a Mac mini
# or a MacBook with an external trackpad attached.
#
# UserPreferences = 1 is what makes the driver honour these values at all — keep it.
# `version` is deliberately not written: it is the schema version the system owns.
for domain in com.apple.AppleMultitouchTrackpad \
              com.apple.driver.AppleBluetoothMultitouch.trackpad; do
	defaults write "$domain" UserPreferences -bool true
	# Tap to click and tap-dragging off — physical click only
	defaults write "$domain" Clicking -bool false
	defaults write "$domain" Dragging -bool false
	defaults write "$domain" DragLock -int 0
	defaults write "$domain" TrackpadThreeFingerDrag -bool false
	# Right-click via bottom-right corner (2), not two-finger click
	defaults write "$domain" TrackpadCornerSecondaryClick -int 2
	defaults write "$domain" TrackpadRightClick -bool false
	defaults write "$domain" TrackpadScroll -bool true
	defaults write "$domain" TrackpadHorizScroll -int 1
	defaults write "$domain" TrackpadMomentumScroll -bool true
	# Zoom and rotate off — they trigger while scrolling in editors
	defaults write "$domain" TrackpadPinch -bool false
	defaults write "$domain" TrackpadRotate -bool false
	# Launchpad (4-finger pinch) and Show Desktop (5-finger spread) off
	defaults write "$domain" TrackpadFourFingerPinchGesture -int 0
	defaults write "$domain" TrackpadFiveFingerPinchGesture -int 0
	# Smart zoom stays on (1) — a two-finger double tap is hard to hit by accident
	defaults write "$domain" TrackpadTwoFingerDoubleTapGesture -int 1
	# Three- and four-finger horizontal swipe = switch full-screen apps (2);
	# vertical swipes and three-finger tap disabled
	defaults write "$domain" TrackpadThreeFingerHorizSwipeGesture -int 2
	defaults write "$domain" TrackpadFourFingerHorizSwipeGesture -int 2
	defaults write "$domain" TrackpadThreeFingerVertSwipeGesture -int 0
	defaults write "$domain" TrackpadFourFingerVertSwipeGesture -int 0
	defaults write "$domain" TrackpadThreeFingerTapGesture -int 0
	defaults write "$domain" TrackpadTwoFingerFromRightEdgeSwipeGesture -int 0
	# Ignore palm contact, and keep the trackpad live when a USB mouse is attached
	defaults write "$domain" TrackpadHandResting -bool true
	defaults write "$domain" USBMouseStopsTrackpad -int 0
done

# --- Terminals: Secure Keyboard Entry ---
# Without it, any process holding Accessibility permissions can read keystrokes typed
# into the terminal — passwords, tokens pasted at a prompt. Costs the ability to drive
# the app from AppleScript, and can break password-manager autofill.
#
# Set per emulator, there is no global switch. Warp (dev.warp.Warp-Stable) exposes no
# equivalent key, so it stays uncovered — keep that in mind before pasting a secret
# into it.
defaults write com.apple.Terminal SecureKeyboardEntry -bool true
# iTerm2's key is the literal string "Secure Input" (confirmed in the app binary),
# not the Apple Terminal name.
defaults write com.googlecode.iterm2 "Secure Input" -bool true

# --- Warp ---
# Forward mouse events to full-screen (alt-screen) apps. With this off, Warp keeps the
# wheel for its own scrollback and alternate scroll mode turns every notch into an
# Up/Down keypress instead — inside a TUI that lands in the input line, so scrolling a
# Claude Code session pages through prompt history rather than the output.
#
# Cost: click-drag selects for the app, not for Warp. Hold Shift to select text anyway.
# Scroll forwarding has its own key (scroll_reporting_enabled, in ~/.warp/settings.toml)
# that only takes effect while mouse reporting is on; it defaults to true and is left
# alone here.
#
# Warp rewrites this domain when it quits, so it must not be running when this is
# applied, or the old value is flushed back over it.
# Match the bundle path, not the process name: Warp's executable is called `stable`
# (CFBundleExecutable), so `pgrep -x Warp` never matches.
if pgrep -fq "/Applications/Warp.app/"; then
	echo "  ! Warp is running — quit it and re-run, or its own state will overwrite MouseReportingEnabled."
fi
defaults write dev.warp.Warp-Stable MouseReportingEnabled -bool true

echo "Restarting Finder, Dock and SystemUIServer..."
killall Finder
killall Dock
killall SystemUIServer

echo "Done."
echo "  - Trackpad settings are read by the driver at login: log out and back in."
echo "  - Secure Keyboard Entry applies to Terminal windows opened afterwards."
echo "  - Warp mouse reporting applies on its next launch."
