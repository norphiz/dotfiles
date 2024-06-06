bindkey -e
autoload -U compinit
zstyle ':completion:*' menu select=1
zmodload zsh/complist
compinit
_comp_options+=(globdots)
PS1='%B%F{blue}%1~%b%f $ '
bindkey '^[[F' end-of-line
bindkey '^[[3~' delete-char
bindkey '^[[H' beginning-of-line
source "$HOME/.config/shell/env.sh"
source "$HOME/.config/shell/alias.sh"
