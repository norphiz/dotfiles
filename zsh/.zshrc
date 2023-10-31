bindkey -e
stty stop undef
unsetopt PROMPT_SP
bindkey '^[[F' end-of-line
bindkey '^[[3~' delete-char
bindkey '^[[H' beginning-of-line
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)
export PS1='%B%F{red}%~%b%f $ '
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
