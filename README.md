# dotfiles

This repo contains the configuration to setup my machines. This is using [Chezmoi](https://chezmoi.io), the dotfile manager to setup the install.

## How to run

```shell
export GITHUB_USERNAME=larsgerber
chezmoi init --apply git@github.com:$GITHUB_USERNAME/dotfiles.git
```

