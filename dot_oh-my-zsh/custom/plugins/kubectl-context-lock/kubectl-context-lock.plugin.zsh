if (( ! $+commands[kubectl] )); then
  return
fi

kxlock() {
  if [ ! -z "$KUBECONFIG" ]; then return; fi
  KUBECONFIG_TMP=$(mktemp -t 'kxlockconfig')
  kubectl config view --raw > $KUBECONFIG_TMP
  export KUBECONFIG=$KUBECONFIG_TMP
  export KXLOCK=true
}

kxunlock() {
  unset KUBECONFIG
  unset KXLOCK
}
