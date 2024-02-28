#!/bin/bash

defaults write com.apple.Dock showhidden -boolean yes; killall Dock
defaults write com.apple.desktopservices DSDontWriteNetworkStores true
