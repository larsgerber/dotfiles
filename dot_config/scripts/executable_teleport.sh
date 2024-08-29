#!/usr/bin/env bash

[[ -n $DEBUG ]] && set -x

set -eou pipefail

IFS=$'\n\t'

# get all apps from Teleport
apps=$(tsh apps ls --format yaml)

# select a cluster from list, skip promt when only one match
cluster=$(echo "$apps" | yq '.[].metadata.labels.cluster' | sort | uniq | fzf --select-1 --query="${1:-}" || true)

# select an app from the selected cluster, skip promt when only one match
service=$(echo "$apps" | cluster=$cluster yq '(.[] | select(.metadata.labels.cluster == strenv(cluster)).metadata.labels.application)' | fzf --select-1 --query="${2:-}" || true)

# get the service URL from the cluster / app combination
url=$(echo "$apps" | cluster=$cluster service=$service yq '(.[] | select(.metadata.labels.cluster == strenv(cluster)) | select(.metadata.labels.application == strenv(service)).spec.public_addr)')

# set default URL when user skips the promts
if [ -z "${url}" ]; then
  eval "$(tsh env)"
  fallbackUrl="$TELEPORT_PROXY/web/cluster/co/resources"
fi

# open URL in default browser
open "https://${url:-$fallbackUrl}"
