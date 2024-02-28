#!/bin/bash

echo ""
echo "=== Brew ==="
echo ""

brew update
brew outdated
brew outdated --cask
brew upgrade
brew upgrade --cask --greedy
brew cleanup

echo ""
echo "=== VSCodium ==="
echo ""

codium --update-extensions

echo ""
echo "=== Krew ==="
echo ""

kubectl krew upgrade

echo ""
echo "=== App Store ==="
echo ""

mas outdated
mas upgrade

echo ""
echo "=== Mac ==="
echo ""

softwareupdate -l

echo ""
echo "=== Dump configs ==="
echo ""

msg="# This file was generated using ./update.sh"
Brewfile=$HOME/.config/Brewfile
VSCodiumExtensions=$HOME/.config/VSCodiumExtensions.txt
KrewPlugins=$HOME/.config/KrewPlugins.txt

brew bundle dump --force --file=$Brewfile.tmp
codium --list-extensions >$VSCodiumExtensions.tmp
kubectl krew list >$KrewPlugins.tmp

(echo $msg && cat $Brewfile.tmp) >$Brewfile
(echo $msg && cat $VSCodiumExtensions.tmp) >$VSCodiumExtensions
(echo $msg && cat $KrewPlugins.tmp) >$KrewPlugins

rm $Brewfile.tmp $VSCodiumExtensions.tmp $KrewPlugins.tmp

echo ""
echo "Good, we're done"
echo ""
