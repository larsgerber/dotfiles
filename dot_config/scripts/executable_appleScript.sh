#!/bin/bash

defaults write NSGlobalDomain com.apple.sound.beep.flash -bool false
defaults write com.apple.universalaccess flashScreen -bool false; sudo killall coreaudiod
defaults write com.apple.Dock showhidden -boolean yes; killall Dock
defaults write com.apple.desktopservices DSDontWriteNetworkStores true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

