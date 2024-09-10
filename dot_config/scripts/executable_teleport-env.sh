#!/usr/bin/env bash

[[ -n $DEBUG ]] && set -x

set -eou pipefail

IFS=$'\n\t'

exit_err() {
  echo -e "${1}" >&2
  exit 1
}

# get all proxies from Teleport config
proxyName=$(find ~/.tsh -maxdepth 1 -type f -name "*.yaml" -exec basename {} .yaml \; | sort | fzf --select-1 --query="${1:-}" || true)

# check if user selected proxy from list
if [[ -z "${proxyName}" ]]; then
  exit_err "error: you did not choose any of the options"
fi

# get needed values for proxy login
proxyAddr=$(yq .web_proxy_addr ~/.tsh/"$proxyName".yaml)
proxyCluster=$(yq .cluster ~/.tsh/"$proxyName".yaml)

tsh login --proxy="$proxyAddr" "$proxyCluster"
