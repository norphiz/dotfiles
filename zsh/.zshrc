autoload -U compinit
zstyle ":completion:*" menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)
bindkey -e
PS1="%B%F{blue}%1~%b%f $ "
bindkey "^[[F" end-of-line
bindkey "^[[3~" delete-char
bindkey "^[[H" beginning-of-line
source "$HOME/.config/shell/env.sh"
source "$HOME/.config/shell/alias.sh"
eval "$(dircolors "$HOME/.local/dircolors/src/dir_colors")"
source "$ZDOTDIR/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"
