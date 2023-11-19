autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)
stty stop undef
bindkey -e
unsetopt PROMPT_SP
bindkey '^[[F' end-of-line
bindkey '^[[3~' delete-char
bindkey '^[[H' beginning-of-line
export PS1='%B%F{red}%~%b%f $ '
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
