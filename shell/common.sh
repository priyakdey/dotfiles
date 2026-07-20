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

# ---- Support colors in ls ------------------------------------------------
export LESS_TERMCAP_mb=$(tput bold; tput setaf 1)
export LESS_TERMCAP_md=$(tput bold; tput setaf 1)
export LESS_TERMCAP_me=$(tput sgr0)
export LESS_TERMCAP_se=$(tput sgr0)
export LESS_TERMCAP_so=$(tput bold; tput setaf 3; tput setab 4)
export LESS_TERMCAP_ue=$(tput sgr0)
export LESS_TERMCAP_us=$(tput smul; tput bold; tput setaf 2)
export LESS_TERMCAP_mr=$(tput rev)
export LESS_TERMCAP_mh=$(tput dim)
export LESS_TERMCAP_ZN=$(tput ssubm)
export LESS_TERMCAP_ZV=$(tput rsubm)
export LESS_TERMCAP_ZO=$(tput ssupm)
export LESS_TERMCAP_ZW=$(tput rsupm)

# ---- Node / nvm ----------------------------------------------------------
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# ---- SDKMAN (keep near the end) ------------------------------------------
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"
