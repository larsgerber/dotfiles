#!/usr/bin/env bash

[[ -n $DEBUG ]] && set -x

set -eou pipefail

IFS=$'\n\t'

exit_err() {
  echo -e "${1}" >&2
  exit 1
}

# disallow wildcard search
if ! [[ "${1:-.}" == "." ]]; then
  # get relative path of file
  file="$(git ls-files --full-name "${1}")"
fi

# get remote of git project
url="$(git config --get remote.origin.url | sed 's/\.git//' || true)"

# replace SSH with HTTPS format
if [[ $url =~ "@" ]]; then
  url=$(echo "$url" | sed 's/:/\//' | sed 's/git@/https:\/\//')
fi

# use the last commit hash for the permalink
if [[ "${2:-}" == '-p' || "${2:-}" == '--permalink' ]]; then
  # get hash from last commit
  id="$(git rev-parse --short HEAD)"
else
  # get branch name
  id="$(git branch --show-current)"
fi

# print url to the terminal
echo "$url/-/blob/$id/${file:-}"
