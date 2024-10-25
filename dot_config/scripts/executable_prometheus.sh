#!/usr/bin/env bash

[[ -n $DEBUG ]] && set -x

set -eou pipefail

IFS=$'\n\t'

exit_err() {
  echo -e "${1}" >&2
  exit 1
}

# get current cluster name without Teleport prefix
context=$(tsh kube ls --format yaml | yq '(.[] | select(.selected == true).kube_cluster_name)')

# check if context is set
if [[ -z "${context}" ]]; then
  exit_err "error: no active context"
fi

# get Prometheus app name from current cluster
app=$(tsh apps ls --format yaml --query='labels["cluster"] == "'"$context"'" && labels["application"] == "prometheus"' | yq '.[].metadata.name')

# check if app is defined
if [[ -z "${app}" ]]; then
  exit_err "error: Prometheus app not found"
fi

# define port
port="9090"

# start proxy session
tsh proxy app --port "$port" "$app" >/dev/null 2>&1 &

# get pid of proxy process
pid=$!

# kill the proxy process on exit
trap '{
    kill $pid
}' EXIT

# wait for port to become available
while ! nc -zv localhost "$port" >/dev/null 2>&1; do
  sleep 0.1
done

# execute promtool command
promtool "$@"
