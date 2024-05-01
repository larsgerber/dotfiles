if (( ! $+commands[subst] )); then
  return
fi

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `subst`. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_subst" ]]; then
  typeset -g -A _comps
  autoload -Uz _subst
  _comps[subst]=_subst
fi

# Generate and load subst completion
subst completion zsh 2> /dev/null >| "$ZSH_CACHE_DIR/completions/_subst" &|
