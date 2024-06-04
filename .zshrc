# Created by newuser for 5.1.1
# allows autocompletion from the middle of a filename
#if command -v dircolors > /dev/null; then
#  eval "$(dircolors)"
#  zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
#fi
zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' '+l:|=** r:|=**' #'r:|[._-]=** r:|=**' ''
zstyle :compinstall filename "$HOME/.zshrc"

autoload -U compinit promptinit
compinit
promptinit
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

if [[ "$(uname)" == "Darwin" && -z "$IN_NIX_SHELL" && ! "$(ls --version | grep GNU)" ]]; then
  alias ls="ls -G"
else
  alias ls="ls --color"
fi
alias ll="ls -ahlG"
alias sl=ls
alias lt="tree -L 3 -C"
alias gpr="git pull --rebase"
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
export TERM=xterm-color

export LEIN_FAST_TRAMPOLINE=y
# not working atm
#export function command_not_found_handler(){command-not-found $1; exit 1}

if [[ "$(uname)" != "Darwin" ]]; then
  if command -v keychain; then
    eval $(keychain --eval --agents ssh -Q --quiet id_rsa)
  fi
else
  #. /Users/ben/.nix-profile/etc/profile.d/nix.sh
  #Using nix darwin now
fi
export _JAVA_AWT_WM_NONREPARENTING=1

export QT_AUTO_SCREEN_SCALE_FACTOR=0

export PYTHONSTARTUP=$HOME/.pythonstartup

#export NVM_DIR="$HOME/.nvm"
#[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
#[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/
alias config="/usr/bin/env git --git-dir=$HOME/.cfg/ --work-tree=$HOME"
eval "$(direnv hook zsh)"

#pitch fmt fix last
alias fix-last="fmt fix && git commit --amend --no-edit"

# the ? in urls gets interpreted as a glob. I never want globs in these commands anyway
alias mpv="noglob mpv"
alias curl="noglob curl"
alias http="noglob http"
alias uuidgen='uuidgen | tr "[:upper:]" "[:lower:]"'
alias nix="noglob nix"
alias git="noglob git"
alias icat="kitty +kitten icat --align left"
alias ns="nix search nixpkgs/22.05"
alias sed="gsed"
alias be="cd $HOME/pitch-app/services/backend"
alias fe="cd $HOME/pitch-app/desktop-app"

export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"
alias prod-ssh="AWS_PROFILE=ben-pitch-prod aws s3 ls || aws sso login && AWS_PROFILE=ben-pitch-prod PITCH_DB_STAGE=prod PITCH_STAGE=prod scripts/ssh-db-tunnel.sh"
eval "$(starship init zsh)"

fpath=("/Users/ben/pitch-app/projects/pit_completions" $fpath) && autoload -U compinit && compinit

#compdef gt
###-begin-gt-completions-###
#
# yargs command completion script
#
# Installation: /usr/local/bin/gt completion >> ~/.zshrc
#    or /usr/local/bin/gt completion >> ~/.zsh_profile on OSX.
#
_gt_yargs_completions()
{
  local reply
  local si=$IFS
  IFS=$'
' reply=($(COMP_CWORD="$((CURRENT-1))" COMP_LINE="$BUFFER" COMP_POINT="$CURSOR" /usr/local/bin/gt --get-yargs-completions "${words[@]}"))
  IFS=$si
  _describe 'values' reply
}
compdef _gt_yargs_completions gt
###-end-gt-completions-###


function prod_tunnel {
  local PROOT=/Users/ben/pitch-app
  PITCH_STAGE=prod
  PITCH_DB_STAGE=prod
  AWS_PROFILE=ben-pitch-prod
  export PITCH_STAGE
  export PITCH_DB_STAGE
  export AWS_PROFILE
  $PROOT/scripts/pit aws-sync-creds
  $PROOT/services/pitch-db/scripts/ssh-db-tunnel.sh
  $PROOT/scripts/pit psql --tunnel
}

alias pprod='prod_tunnel'
alias gg='gcal --starting-day=Monday --iso-week-number=yes -K .'

