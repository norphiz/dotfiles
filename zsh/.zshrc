autoload -U compinit
zstyle ":completion:*" menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)
stty stop undef
bindkey -e
unsetopt PROMPT_SP
PS1="%B%F{red}%~%b%f $ "
bindkey "^[[F" end-of-line
bindkey "^[[3~" delete-char
bindkey "^[[H" beginning-of-line
export ZLE_REMOVE_SUFFIX_CHARS=""
source "$XDG_CONFIG_HOME/shell/aliasrc"
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
