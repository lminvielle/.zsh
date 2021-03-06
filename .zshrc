# Useful commands
# find . -name "*" -exec grep -n hello /dev/null {} \; # {} is find file
# sed -r 's/.* token_start (.+) token_end .*/\1/'
# sed ':a;N;$!ba;s/\n/ /g' merge two lines to check pattern
# <(cmd) <(cmd) For asynchron piping

#export TERM='screen-256color'


# Let's reset caps lock (setxkbmap -option to re-enable)
# setxkbmap -option ctrl:nocaps

###########################################################        
#
# Allowing 256 color terminal
export TERM=xterm-256color

# Options for Zsh

export HISTFILE=~/.zsh_history
export HISTSIZE=50000
export SAVEHIST=50000
eval `dircolors -b`

set -o vi
bindkey -v
#kill the lag
export KEYTIMEOUT=1

autoload -Uz compinit 
setopt autopushd pushdminus pushdsilent pushdtohome
setopt autocd
setopt cdablevars
#setopt ignoreeof
setopt interactivecomments
#setopt nobanghist
setopt noclobber # Use >! to override file
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_SPACE
setopt SH_WORD_SPLIT
setopt nohup

# PS1 and PS2
export PS1="$(print '%{\e[1;31m%}[%{\e[0m%}%{\e[1;34m%}%n%{\e[0m%}%{\e[1;31m%}@%{\e[0m%}%{\e[1;32m%}%M%{\e[0m%}%{\e[1;31m%}]%{\e[0m%}%'):$(print '%{\e[0;33m%}%~%{\e[0m%}$') "
export PS2="$(print '%{\e[0;34m%}>%{\e[0m%}')"

# Date at Prompt
#RPROMPT='[%D{%L:%M:%S %p}]'
#TMOUT=0
#TRAPALRM() {
#   zle reset-prompt
#}
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git svn
precmd() {
  vcs_info
}
# Mode at Prompt
function zle-line-init zle-keymap-select {
    RPS1="%{%F{red}%} ${vcs_info_msg_0_} %{%F{blue}%} ${${KEYMAP/vicmd/ -- NORMAL --}/(main|viins)/-- INSERT --}%f"
    zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select

# Vars used later on by Zsh
export EDITOR="vim"
export IDE="gvim"
export BROWSER="w3m"

##################################################################
# Stuff to make my life easier

# allow approximate
#zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric
zstyle ':completion:*:*:cd:*' tag-order local-directories
zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"
autoload -U colors && colors
compinit

# This sets the case insensitivity
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}'

# tab completion for PID :D
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*' force-list always

# cd not select parent dir
zstyle ':completion:*:cd:*' ignore-parents parent pwd

zstyle ':completion:*' menu select
setopt menu_complete

##################################################################
# Key bindings
# http://mundy.yazzy.org/unix/zsh.php
# http://www.zsh.org/mla/users/2000/msg00727.html

typeset -g -A key
bindkey '^?' backward-delete-char
bindkey '^[[1~' beginning-of-line
bindkey '^[[5~' up-line-or-history
bindkey '^[[3~' delete-char
bindkey '^[[4~' end-of-line
bindkey '^[[5~' history-search-backward
bindkey '^[[6~' down-line-or-history
bindkey '^[[A' up-line-or-search
bindkey '^[[D' backward-char
bindkey '^[[B' down-line-or-search
bindkey '^[[C' forward-char 
# completion in the middle of a line
bindkey '^i' expand-or-complete-prefix
bindkey '^r' history-incremental-search-backward
bindkey '^w' backward-kill-word

source ~/.zsh/custalias.zsh

set inc

# Root allow X?
xhost + > /dev/null 2> /dev/null || true

export PATH=~/usr/bin:$PATH
export LD_LIBRARY_PATH=~/usr/lib:$LD_LIBRARY_PATH

# vim CTRL-Z helper
fancy-ctrl-z () {
  if [[ $#BUFFER -eq 0 ]]; then
    fg
    zle redisplay
  else
    zle push-input
    zle clear-screen
  fi
}
zle -N fancy-ctrl-z
bindkey '^Z' fancy-ctrl-z

#plugin part
setopt HIST_FIND_NO_DUPS
source ~/.zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

bindkey '^P' up-line-or-search
bindkey '^N' down-line-or-search

bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

typeset -AHg FX FG BG

FX=(
    reset     "%{[00m%}"
    bold      "%{[01m%}" no-bold      "%{[22m%}"
    italic    "%{[03m%}" no-italic    "%{[23m%}"
    underline "%{[04m%}" no-underline "%{[24m%}"
    blink     "%{[05m%}" no-blink     "%{[25m%}"
    reverse   "%{[07m%}" no-reverse   "%{[27m%}"
)

for color in {000..255}; do
    FG[$color]="%{[38;5;${color}m%}"
    BG[$color]="%{[48;5;${color}m%}"
done
ZSH_SPECTRUM_TEXT=${ZSH_SPECTRUM_TEXT:-Arma virumque cano Troiae qui primus ab oris}
# Show all 256 colors with color number
function spectrum_ls() {
  for code in {000..255}; do
    print -P -- "$code: %{$FG[$code]%}$ZSH_SPECTRUM_TEXT%{$reset_color%}"
  done
}

# Show all 256 colors where the background is set to specific color
function spectrum_bls() {
  for code in {000..255}; do
    print -P -- "$code: %{$BG[$code]%}$ZSH_SPECTRUM_TEXT%{$reset_color%}"
  done
}
