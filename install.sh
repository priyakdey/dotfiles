#!/usr/bin/env bash
# install.sh — symlink dotfiles into place. Detects OS; safe to re-run.
#
#   git clone <repo> && cd dotfiles && ./install.sh
#
# No hardcoded paths: the repo root is wherever this script lives.
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export DOTFILES
source "$DOTFILES/lib/link.sh"

os="$(uname -s)"
echo "dotfiles : $DOTFILES"
echo "os       : $os"
echo

echo "Shared:"
link nvim                "$HOME/.config/nvim"
link wezterm             "$HOME/.config/wezterm"
link tmux/.tmux.conf     "$HOME/.tmux.conf"
link git/.gitconfig      "$HOME/.gitconfig"
link ssh/config          "$HOME/.ssh/config"
link shell/.bash_aliases "$HOME/.bash_aliases"
link shell/common.sh     "$HOME/.bash_common"

case "$os" in
  Darwin)
    echo
    echo "macOS:"
    link shell/bash_profile.macos "$HOME/.bash_profile"
    echo
    echo "  iTerm2: import iterm2/profile.json manually the first time"
    echo "  (Settings ▸ Profiles ▸ Other Actions ▸ Import JSON Profiles),"
    echo "  or point iTerm2 at this folder via 'Load preferences from a"
    echo "  custom folder' in Settings ▸ General ▸ Preferences."
    ;;
  Linux)
    echo
    echo "Linux:"
    link shell/bashrc.linux "$HOME/.bashrc"
    link colors/.dircolors  "$HOME/.dircolors"
    link i3                 "$HOME/.config/i3"
    link picom              "$HOME/.config/picom"
    link polybar            "$HOME/.config/polybar"
    ;;
  *)
    echo
    echo "Unknown OS '$os' — only shared configs linked."
    ;;
esac

echo
echo "Done. Start a new shell (or: exec bash -l)."
