# setup aliases
if [ -f ~/.bash_aliases ]; then
    source ~/.bash_aliases
fi


export PATH="$HOME/bin:$PATH"

# Protobuf
export PATH="$HOME/go/pkg/mod/github.com/mitchellh/protoc-gen-go-json\@v1.1.0/build:$PATH"
export PATH="$HOME/bin:$PATH"

# Golang
export PATH="$(go env GOPATH)/bin:$PATH"

# LLVM
export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/llvm/lib"
export CPPFLAGS="-I/opt/homebrew/opt/llvm/include"

# cd path
export CDPATH="$HOME/dev:$CDPATH"


# Git branch prompt
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

export PS1="\[\033[36m\]\u\[\033[m\]@\[\033[32m\]\h:\[\033[33;1m\]\w\[\033[m\]\033[32m\]\$(parse_git_branch)\[\033[00m\] \$ "

export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

export BASH_SILENCE_DEPRECATION_WARNING=1

# source /Users/priydey/.docker/init-bash.sh || true # Added by Docker Desktop
eval "$(/opt/homebrew/bin/brew shellenv)"

# load sonar secrets
source ~/.sonar.env

# pnpm
export PNPM_HOME="/Users/priydey/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
