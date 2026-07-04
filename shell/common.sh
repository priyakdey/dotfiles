# shell/common.sh — shared bash config.
# Sourced by BOTH macOS (~/.bash_profile) and Linux (~/.bashrc) as ~/.bash_common.
# Keep this POSIX/portable: no OS-specific paths here (those live in the OS files).

# ---- History -------------------------------------------------------------
HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000
shopt -s histappend
shopt -s checkwinsize

# ---- Aliases -------------------------------------------------------------
[ -f ~/.bash_aliases ] && . ~/.bash_aliases

# ---- Git-aware prompt ----------------------------------------------------
parse_git_branch() {
    git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
export PS1="\[\e[36m\]\u\[\e[0m\]@\[\e[32m\]\h:\[\e[33;1m\]\w\[\e[0m\]\[\e[32m\]\$(parse_git_branch)\[\e[0m\] \$ "

# ---- Node / nvm ----------------------------------------------------------
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# ---- SDKMAN (keep near the end) ------------------------------------------
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"
