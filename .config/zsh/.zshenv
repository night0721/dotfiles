# defualt apps
export EDITOR="nvim"
export SUDO_EDITOR="nvim"
export TERMINAL="foot"
export TERM="foot"
export BROWSER="firefox"

# Adds ~/.local/bin and subfolders to $PATH
export PATH="$PATH:/home/night/.local/npm/bin:${$(find ~/.local/bin -maxdepth 1 -type d -printf %p:)%%:}"

# cleaning up home folder
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"

#export LESSHISTFILE="-"
export GOPATH="${XDG_DATA_HOME:-$HOME/.local/share}/go"
export CARGO_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/cargo"
export ZDOTDIR="$HOME/.config/zsh"
export GIT_CONFIG="$HOME/.config/git/config"
export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8" # https://github.com/catppuccin/fzf
export BAT_THEME="Catppuccin-mocha" # https://github.com/catppuccin/bat
export LC_ALL=en_US.UTF-8
