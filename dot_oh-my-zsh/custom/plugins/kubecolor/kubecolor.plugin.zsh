if (( ! $+commands[kubecolor] )); then
  return
fi

# make completion work with kubecolor
compdef kubecolor=kubectl
alias kubectl=kubecolor
