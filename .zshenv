#!/bin/sh
# `npm install -g` path is set with npm config get/set prefix
export PATH=$HOME/bin:$HOME/.npm-packages/bin:$HOME/.cargo/bin:$PATH:/sbin:$HOME/go/bin:$HOME/.emacs.d/bin:/usr/local/bin
export GOPATH=$HOME/go
if [ -e /Users/ben/.nix-profile/etc/profile.d/nix.sh ]; then . /Users/ben/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
export ASPELL_CONF="dict-dir $HOME/.nix-profile/lib/aspell"
