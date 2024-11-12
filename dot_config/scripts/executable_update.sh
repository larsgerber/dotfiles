#!/usr/bin/env bash

writeBanner() {
  echo -e "\n=== $1 ===\n"
}

updateBrew() {
  writeBanner "Brew"
  export HOMEBREW_NO_ENV_HINTS=1
  brew update
  brew outdated
  brew outdated --cask --greedy
  brew upgrade
  brew upgrade --cask --greedy
  brew autoremove
  brew cleanup --prune=0 --scrub
}

updateOhMyZsh() {
  writeBanner "Oh My Zsh"
  ~/.oh-my-zsh/tools/upgrade.sh -v minimal
  find ~/.oh-my-zsh/custom/plugins -maxdepth 2 -type d -name ".git" -exec sh -c \
    'echo && cd $1/.. && pwd && git pull 2> /dev/null' shell {} \;
}

updateVSCodium() {
  writeBanner "VSCodium"
  codium --update-extensions
}

updateHelm() {
  writeBanner "Helm"
  helm repo update
  helm plugin list | awk 'NR > 1 {print $1}' | xargs -r helm plugin update
}

updateKrew() {
  writeBanner "Krew"
  kubectl krew upgrade
}

updateGo() {
  writeBanner "Go"
  go version -m ~/go/bin | awk '$1 ~ /path/ {print $2}' | xargs -r -I {} go install {}@latest
}

updateAppStore() {
  writeBanner "App Store"
  mas outdated && mas upgrade
}

updateMacOS() {
  writeBanner "MacOS"
  softwareupdate -l
}

dumpConfigs() {
  writeBanner "Dump configs"

  # Banner message
  msg="# This file was generated using ~/.config/scripts/update.sh"

  # Define file paths and corresponding commands in an associative array
  declare -A dumps=(
    ["$HOME/.config/brew/Brewfile"]="brew bundle dump --force --file=-"
    ["$HOME/.config/dumps/VSCodiumExtensions.txt"]="codium --list-extensions"
    ["$HOME/.config/dumps/HelmRepos.txt"]="helm repo list | awk 'NR > 1 {print \$1}'"
    ["$HOME/.config/dumps/HelmPlugins.txt"]="helm plugin list | awk 'NR > 1 {print \$1}'"
    ["$HOME/.config/dumps/KrewPlugins.txt"]="kubectl krew list"
    ["$HOME/.config/dumps/GoTools.txt"]="go version -m ~/go/bin | awk '\$1 ~ /mod/ {print \$2 \" \" \$3}' | column -t"
  )

  # Execute each command and output to respective file with banner
  for file in "${!dumps[@]}"; do
    command="${dumps[$file]}"
    echo "$msg" >"$file"
    eval "$command" >>"$file"
  done
}

help() {
  echo "Usage: update.sh [OPTIONS]"
  echo
  echo "Options:"
  echo "  --brew           Update Brew."
  echo "  --ohmyzsh        Update OhMyZsh."
  echo "  --vscodium       Update VSCodium extensions."
  echo "  --helm           Update Helm repositorys and plugins."
  echo "  --krew           Update Krew index and plugins."
  echo "  --go             Update Go binaries in ~/go/bin."
  echo "  --appstore       Update apps from AppStore."
  echo "  --macos          Download MacOS updates."
  echo "  --dump           Dump all configs."
  echo "  --help           Display this help message and exit."
  echo
  echo "If no options are specified, every option is run."
}

ALL=true

# Parse command-line arguments
while [[ $# -gt 0 ]]; do
  ALL=false
  case "$1" in
  --brew) updateBrew ;;
  --ohmyzsh) updateOhMyZsh ;;
  --vscodium) updateVSCodium ;;
  --helm) updateHelm ;;
  --krew) updateKrew ;;
  --go) updateGo ;;
  --appstore) updateAppStore ;;
  --macos) updateMacOS ;;
  --dump) dumpConfigs ;;
  --help)
    help
    exit 0
    ;;
  *) echo "Unparsed arguments: $1" ;;
  esac
  shift
done

# Run all updates if no specific options are provided
if [[ $ALL == true ]]; then
  updateBrew
  updateOhMyZsh
  updateVSCodium
  updateHelm
  updateKrew
  updateGo
  updateAppStore
  updateMacOS
  dumpConfigs
fi
