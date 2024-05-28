if (( ! $+commands[kubectl] )); then
  return
fi

kxlock() {
  if [ ! -z "$KUBECONFIG" ]; then return; fi
  mkdir -p ~/.kube/kxlock
  KUBECONFIG_TMP=$(mktemp -t 'config' -p ~/.kube/kxlock)
  kubectl config view --raw > $KUBECONFIG_TMP
  export KUBECONFIG=$KUBECONFIG_TMP
  export KXLOCK=true
}

kxunlock() {
  unset KUBECONFIG
  unset KXLOCK
}

kxcleanup() {
  kxunlock
  rm -rf ~/.kube/kxlock
}

