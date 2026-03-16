#!/usr/bin/env bash
#
# Sensible macOS defaults. Run once on a fresh machine, then log out/in.
# Inspired by mathiasbynens/dotfiles. Review before running — tweak to taste.

set -euo pipefail

echo "Applying macOS defaults..."

# Close System Settings to prevent it from overriding
osascript -e 'tell application "System Settings" to quit' 2>/dev/null || true

# ───────────────────────────────────────────────────
# General UI
# ───────────────────────────────────────────────────

# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# Expand print panel by default
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# Save to disk (not iCloud) by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Disable automatic termination of inactive apps
defaults write NSGlobalDomain NSDisableAutomaticTermination -bool true

# ───────────────────────────────────────────────────
# Keyboard & Input
# ───────────────────────────────────────────────────

# Fast key repeat and short delay
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# Disable auto-correct, smart dashes, smart quotes, and auto-capitalize
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

# Enable full keyboard access for all controls (Tab through dialogs)
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# ───────────────────────────────────────────────────
# Trackpad
# ───────────────────────────────────────────────────

# Enable tap to click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# ───────────────────────────────────────────────────
# Finder
# ───────────────────────────────────────────────────

# Show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Show status bar and path bar
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder ShowPathbar -bool true

# Display full POSIX path in title bar
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# Keep folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# Default to list view
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Disable warning when changing file extensions
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Avoid creating .DS_Store on network and USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Show ~/Library
chflags nohidden ~/Library

# ───────────────────────────────────────────────────
# Dock
# ───────────────────────────────────────────────────

# Minimize using scale effect (faster than genie)
defaults write com.apple.dock mineffect -string "scale"

# Don't show recent apps
defaults write com.apple.dock show-recents -bool false

# Auto-hide the Dock
defaults write com.apple.dock autohide -bool true

# Speed up auto-hide animation
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0.4

# ───────────────────────────────────────────────────
# Mission Control & Spaces
# ───────────────────────────────────────────────────

# Don't automatically rearrange Spaces based on most recent use
defaults write com.apple.dock mru-spaces -bool false

# Group windows by application in Mission Control
defaults write com.apple.dock expose-group-apps -bool true

# ───────────────────────────────────────────────────
# Screenshots
# ───────────────────────────────────────────────────

# Save screenshots to ~/Screenshots
mkdir -p "${HOME}/Screenshots"
defaults write com.apple.screencapture location -string "${HOME}/Screenshots"

# Save as PNG
defaults write com.apple.screencapture type -string "png"

# Disable shadow in screenshots
defaults write com.apple.screencapture disable-shadow -bool true

# ───────────────────────────────────────────────────
# Activity Monitor
# ───────────────────────────────────────────────────

# Show all processes
defaults write com.apple.ActivityMonitor ShowCategory -int 0

# Sort by CPU usage
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0

# ───────────────────────────────────────────────────
# Finder (additional)
# ───────────────────────────────────────────────────

# Show hidden files
defaults write com.apple.finder AppleShowAllFiles -bool true

# ───────────────────────────────────────────────────
# Safari
# ───────────────────────────────────────────────────

# Show full URL in address bar
defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true

# Enable Develop menu and Web Inspector
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true

# Enable Web Inspector in all web views globally
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

# ───────────────────────────────────────────────────
# TextEdit
# ───────────────────────────────────────────────────

# Default to plain text
defaults write com.apple.TextEdit RichText -int 0

# Open and save as UTF-8
defaults write com.apple.TextEdit PlainTextEncoding -int 4
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4

# ───────────────────────────────────────────────────
# Security
# ───────────────────────────────────────────────────

# Require password immediately after sleep or screensaver
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# ───────────────────────────────────────────────────
# Spotlight
# ───────────────────────────────────────────────────

# Disable Spotlight keyboard shortcut (Cmd+Space) to free it for Raycast/Alfred
# Note: re-enable in System Settings > Keyboard > Shortcuts if needed
/usr/libexec/PlistBuddy -c "Set :AppleSymbolicHotKeys:64:enabled false" ~/Library/Preferences/com.apple.symbolichotkeys.plist 2>/dev/null || true

# ───────────────────────────────────────────────────
# Apply changes
# ───────────────────────────────────────────────────

echo "Restarting affected apps..."
for app in "Finder" "Dock" "SystemUIServer" "Safari"; do
  killall "$app" &>/dev/null || true
done

echo "Done. Some changes require a logout/restart to take effect."
