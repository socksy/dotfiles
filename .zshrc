#zmodload zsh/zprof
# Created by newuser for 5.1.1
# allows autocompletion from the middle of a filename
#if command -v dircolors > /dev/null; then
#  eval "$(dircolors)"
#  zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
#fi
zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' '+l:|=** r:|=**' #'r:|[._-]=** r:|=**' ''
zstyle :compinstall filename "$HOME/.zshrc"

if [ -n "${commands[fzf-share]}" ]; then
  source "$(fzf-share)/key-bindings.zsh"
  source "$(fzf-share)/completion.zsh"
fi

#autoload -U compinit promptinit
autoload -Uz compinit
# only check if .zcompdump file is out of date once a day - when developing completions it makes sense to disable this
if [ "$(find ~/.zcompdump -mtime 1)" ] ; then
  echo "Regenerating .zcompdump as it's more than a day old"
	compinit;
else
	compinit -C;
fi;
#promptinit
setopt completealiases

HISTFILE=~/.histfile
HISTSIZE=5000
SAVEHIST=5000
setopt autocd extendedglob
bindkey -e

man() {
    env \
        LESS_TERMCAP_mb=$(printf "\e[1;31m") \
        LESS_TERMCAP_md=$(printf "\e[1;31m") \
        LESS_TERMCAP_me=$(printf "\e[0m") \
        LESS_TERMCAP_se=$(printf "\e[0m") \
        LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
        LESS_TERMCAP_ue=$(printf "\e[0m") \
        LESS_TERMCAP_us=$(printf "\e[1;32m") \
            man "$@"
}

#[[ -e ~/.profile ]] && emulate sh -c 'source ~/.profile'

alias ls="ls --color"
alias ll="eza -ahl"
alias sl=ls
alias lt="tree -L 3 -C"
alias gpr="gh pr view"
alias gca="git commit -a"
alias gti=git
if command -v emacsclient > /dev/null; then
  alias ec="emacsclient -c -n -a ''"
  alias ecc="TERM=xterm-256color emacsclient -nw -a ''"
else
  alias ec="emacs"
  alias ecc="TERM=xterm-256color emacs -nw"
fi
alias fucking=sudo
alias please=sudo
alias grep="grep --color=auto"

fpath=("$HOME/.zsh/functions" $fpath)
autoload -U compinit && compinit

export EDITOR=vim
export TERM=xterm-256color

export LEIN_FAST_TRAMPOLINE=y
# not working atm
#export function command_not_found_handler(){command-not-found $1; exit 1}

if [[ "$(uname)" != "Darwin" ]]; then
  if command -v keychain > /dev/null; then
    eval $(keychain --eval --agents ssh -Q --quiet id_rsa)
  fi
else
  #. /Users/ben/.nix-profile/etc/profile.d/nix.sh
  alias sed="gsed"
fi
export _JAVA_AWT_WM_NONREPARENTING=1


export PYTHONSTARTUP=$HOME/.pythonstartup

#export NVM_DIR="$HOME/.nvm"
#[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
#[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/
alias config="/usr/bin/env git --git-dir=$HOME/.cfg/ --work-tree=$HOME"
eval "$(direnv hook zsh)"

# the ? in urls gets interpreted as a glob. I never want globs in these commands anyway
alias mpv="noglob mpv"
alias curl="noglob curl"
alias http="noglob http"
alias uuidgen='uuidgen | tr "[:upper:]" "[:lower:]"'
alias nix="noglob nix"
alias nixos-rebuild="noglob nixos-rebuild"
alias git="noglob git"
alias icat="kitty +kitten icat --align left"
alias ns="nix search nixpkgs"
alias nsu="nix search nixpkgs/nixos-unstable"

export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"
eval "$(starship init zsh)"

## TODO why do i have this?
##compdef gt
###-begin-gt-completions-###
#
# yargs command completion script
#
# Installation: /usr/local/bin/gt completion >> ~/.zshrc
#    or /usr/local/bin/gt completion >> ~/.zsh_profile on OSX.
#
#_gt_yargs_completions()
#{
#  local reply
#  local si=$IFS
#  IFS=$'
#' reply=($(COMP_CWORD="$((CURRENT-1))" COMP_LINE="$BUFFER" COMP_POINT="$CURSOR" /usr/local/bin/gt --get-yargs-completions "${words[@]}"))
#  IFS=$si
#  _describe 'values' reply
#}
#compdef _gt_yargs_completions gt
###-end-gt-completions-###

alias gg='gcal --starting-day=Monday --iso-week-number=yes -K .'

alias mgh='gh pr list --search "involves:@me"'

#source "${XDG_CONFIG_HOME:-$HOME/.config}/asdf-direnv/zshrc"
#/usr/local/opt/asdf/libexec/asdf.sh
unsetopt sharehistory
#zprof
alias windows='quickemu --vm $HOME/VMs/windows-11.conf'
alias macos='quickemu --vm $HOME/VMs/macos-ventura.conf'

f () {
  ${1-vim} $(fd -H . | fzf)
}
vl () {
  if [[ $!! =~ "rg" ]]; then
    repeat_cmd="!! --heading"
  else
    repeat_cmd="!!"
  fi
  echo "repeating $repeat_cmd"
  ${1-vim} "$(repeat_cmd |& head -1)"
}
alias hyc="$EDITOR /home/ben/.config/hypr/hyprland.conf"
alias bngg="nvim /home/ben/code/nixconf/modules/gnome.nix"
alias bng="nvim /home/ben/code/nixconf/modules/graphics_stuff.nix"
alias v='TERM="xterm kitty" viu'
alias benbarlaunch="/home/ben/code/bens-ags/rebuild"
