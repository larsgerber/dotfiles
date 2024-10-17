function completion() {
  if (( ! $+commands[${1}] )); then
    return
  fi

  # If the completion file doesn't exist yet, we need to autoload it and
  # bind it to the command. Otherwise, compinit will have already done that.
  if [[ ! -f "$ZSH_CACHE_DIR/completions/_${1}" ]]; then
    typeset -g -A _comps
    autoload -Uz _${1}
    _comps[${1}]=_${1}
  fi

  # Generate and load completion
  ${@} 2> /dev/null >| "$ZSH_CACHE_DIR/completions/_${1}" &|
}

completion tfctl completion zsh
completion tsh --completion-script-zsh
completion subst completion zsh
