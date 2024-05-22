#!/bin/bash

# Stolen from https://github.com/michaelfriderich :D

echo ""
echo "=== Brew ==="
echo ""

brew update
brew outdated
brew outdated --cask --greedy
brew upgrade
brew upgrade --cask --greedy
brew cleanup

echo ""
echo "=== VSCodium ==="
echo ""

codium --update-extensions

echo ""
echo "=== Helm ==="
echo ""

helm repo update
helm plugin list | awk '{if (NR!=1) {print $1}}' | xargs helm plugin update

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

msg="# This file was generated using ~/.config/scripts/update.sh"
Brewfile=$HOME/.config/brew/Brewfile
VSCodiumExtensions=$HOME/.config/dumps/VSCodiumExtensions.txt
HelmRepos=$HOME/.config/dumps/HelmRepos.txt
HelmPlugins=$HOME/.config/dumps/HelmPlugins.txt
KrewPlugins=$HOME/.config/dumps/KrewPlugins.txt

brew bundle dump --force --file=$Brewfile.tmp
codium --list-extensions >$VSCodiumExtensions.tmp
helm repo list | awk '{if (NR!=1) {print $1}}' >$HelmRepos.tmp
helm plugin list | awk '{if (NR!=1) {print $1}}' >$HelmPlugins.tmp
kubectl krew list >$KrewPlugins.tmp

(echo $msg && cat $Brewfile.tmp) >$Brewfile
(echo $msg && cat $VSCodiumExtensions.tmp) >$VSCodiumExtensions
(echo $msg && cat $HelmRepos.tmp) >$HelmRepos
(echo $msg && cat $HelmPlugins.tmp) >$HelmPlugins
(echo $msg && cat $KrewPlugins.tmp) >$KrewPlugins

rm $HOME/.config/*/*.tmp

echo ""
echo "Good, we're done"
echo ""
