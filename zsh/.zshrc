unsetopt PROMPT_SP
autoload -U compinit
zstyle ":completion:*" menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)
bindkey -e
PS1="%B%F{blue}%1~%b%f $ "
ZLE_REMOVE_SUFFIX_CHARS=""
bindkey "^[[F" end-of-line
bindkey "^[[3~" delete-char
bindkey "^[[H" beginning-of-line
source "$HOME/.config/shell/env.sh"
source "$HOME/.config/shell/alias.sh"
eval "$(dircolors "$XDG_DATA_HOME/dircolors/src/dir_colors")"
source "$ZDOTDIR/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"
