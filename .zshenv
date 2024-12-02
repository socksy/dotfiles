#!/bin/sh
# `npm install -g` path is set with npm config get/set prefix
export PATH=$HOME/bin:$HOME/.npm-packages/bin:$HOME/.cargo/bin:$PATH:/sbin:$HOME/go/bin:$HOME/.emacs.d/bin:/usr/local/bin:/opt/homebrew/bin:$HOME/.babashka/bbin/bin
export GOPATH=$HOME/go
if [ -e /Users/ben/.nix-profile/etc/profile.d/nix.sh ]; then . /Users/ben/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
export ASPELL_CONF="dict-dir $HOME/.nix-profile/lib/aspell"
# this gets clobbered by some display manager nix setting?
export XDG_DATA_DIRS=$HOME/.local/share/applications:$XDG_DATA_DIRS
export EDITOR="nvim"
export OLLAMA_API_BASE="http://127.0.0.1:11434"
