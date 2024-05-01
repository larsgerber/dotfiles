# https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/macos/macos.plugin.zsh#L229-L231

function quick-look() {
  (($# > 0)) && qlmanage -p $* &>/dev/null &
}
