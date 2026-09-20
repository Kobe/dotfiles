#!/bin/bash
# macOS defaults - exported from current system
# Run: ./macos/defaults.sh

echo "Configuring macOS defaults..."

# Close System Preferences to prevent conflicts
osascript -e 'tell application "System Preferences" to quit'

# --- Finder ---
# Show file extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
# Show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# --- Dock ---
# Auto-hide Dock
defaults write com.apple.dock autohide -bool true
# Auto-hide delay (1 second)
defaults write com.apple.dock autohide-delay -float 1
# Don't show recent apps
defaults write com.apple.dock show-recents -bool false
# Tile size (very small)
defaults write com.apple.dock tilesize -int 16

# --- Screenshots ---
# Save to ~/Pictures/Screenshots: /tmp is world-readable and cleared on reboot,
# and screenshots regularly capture tokens or session data
mkdir -p "$HOME/Pictures/Screenshots"
defaults write com.apple.screencapture location -string "$HOME/Pictures/Screenshots"

# --- Trackpad ---
# Right-click in corner
defaults write com.apple.AppleMultitouchTrackpad TrackpadCornerSecondaryClick -int 2

# Restart affected apps
echo "Restarting Finder and Dock..."
killall Finder
killall Dock

echo "Done! Some changes require a logout/restart to take effect."
