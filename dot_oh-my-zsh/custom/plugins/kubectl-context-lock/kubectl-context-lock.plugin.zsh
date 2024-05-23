if (( ! $+commands[kubectl] )); then
  return
fi

kxlock() {
  KUBECONFIG=$(mktemp -t 'kxlockconfig')
  kubectl config view --raw > $KUBECONFIG
  export KUBECONFIG=$KUBECONFIG
}

kxunlock() {
  unset KUBECONFIG
}
