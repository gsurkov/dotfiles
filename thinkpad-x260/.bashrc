#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Add $HOME/.local/bin to $PATH
export PATH="$PATH:$(du -L "$HOME/.local/bin/" | cut -f2 | paste -sd ":")"

# Default programs
export EDITOR="nvim"
export TERMINAL="alacritty"
export BROWSER="firefox"

# $HOME cleanup
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

export HISTFILE="$XDG_CONFIG_HOME/bash_history"
export HISTSIZE=100

export LESSHISTFILE="-"
export GNUPGHOME="$XDG_DATA_HOME/gnupg"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export GOPATH="$XDG_DATA_HOME/go"

export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc-2.0"
export PASSWORD_STORE_DIR="$XDG_DATA_HOME/password-store"

export XCURSOR_PATH="$XCURSOR_PATH:$XDG_DATA_HOME/icons"
export XCURSOR_SIZE=36

# Color output
alias ls="ls --color=auto"
alias diff="diff --color=auto"
alias grep="grep --color=auto"
alias ip="ip --color=auto"

# Shorter names
alias vim="nvim"
