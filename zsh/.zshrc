autoload -U compinit
zstyle ':completion:*' menu select=1
zmodload zsh/complist
compinit
_comp_options+=(globdots)
stty stop undef
bindkey -e
unsetopt PROMPT_SP
PS1='%B%F{blue}%~%b%f $ '
ZLE_REMOVE_SUFFIX_CHARS=''
bindkey '^[[F' end-of-line
bindkey '^[[3~' delete-char
bindkey '^[[H' beginning-of-line
source "$HOME/.config/shell/env.sh"
source "$HOME/.config/shell/alias.sh"
