# K8S
# export K8S_VERSION='1.3.0-alpha.1'

# Go Workspace
export GOPATH=/Users/priyakdey/Projects/Learning-Go
export GOBIN=/Users/priyakdey/go/bin
export PATH=$PATH:$(go env GOPATH)/bin


# JAVA - 11: Managed with sdkman
# export JAVA_HOME=$(/usr/libexec/java_home)
# export JRE_HOME=$(/usr/libexec/java_home)
# export PATH=$PATH:/usr/local/mysql/bin

# Java 8: Managed with sdkman
# export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_172.jdk/Contents/Home
# export JRE_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_172.jdk/Contents/Home
# export PATH=$PATH:/usr/local/mysql/bin

# Maven: managed with sdkman
# M2_HOME=/Users/priyakdey/Personal/apache-maven-3.5.4_binary
# export M2_HOME
# PATH="${PATH}:/Users/priyakdey/Personal/apache-maven-3.5.4_binary/bin"
# export PATH

# AWS CLI
export PATH="/Users/priyakdey/Library/Python/3.6/bin/:$PATH"
export PATH="~/.local/bin:$PATH"

# Git branch prompt
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

# NPM
export PATH=~/.npm-global/bin:$PATH

# Python 3.8
# The original version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.8/bin:${PATH}"
export PATH

bind 'set show-all-if-ambiguous on'
bind 'set completion-ignore-case on'

# RabbitMQ
PATH="/usr/local/Cellar/rabbitmq/3.8.2/sbin:${PATH}"
export PATH

# intellij
PATH="/Applications/IntelliJ IDEA CE.app/Contents/MacOS/idea:${PATH}"
export PATH

# flutter
PATH="/Users/priyakdey/flutter/bin:${PATH}"
export PATH

# Aliases
alias py=python3
alias jvisualvm=/Library/Java/JavaVirtualMachines/jdk1.8.0_172.jdk/Contents/Home/bin/jvisualvm
alias jmap=/Library/Java/JavaVirtualMachines/jdk1.8.0_172.jdk/Contents/Home/bin/jmap
alias jstack=/Library/Java/JavaVirtualMachines/jdk1.8.0_172.jdk/Contents/Home/bin/jstack
alias keytool=/Library/Java/JavaVirtualMachines/jdk1.8.0_172.jdk/Contents/Home/bin/keytool
alias jhat=/Library/Java/JavaVirtualMachines/jdk1.8.0_172.jdk/Contents/Home/bin/jhat
# alias idea=$(/usr/local/bin/idea)
# alias sts=/Applications/SpringToolSuite4.app/Contents/MacOS/SpringToolSuite4
alias ll='ls -lrt'
alias pip=pip3

alias vi=nvim
alias vim=nvim


#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/Users/priyakdey/.sdkman"
[[ -s "/Users/priyakdey/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/priyakdey/.sdkman/bin/sdkman-init.sh"

export PS1="\[\033[36m\]\u\[\033[m\]@\[\033[32m\]\h:\[\033[33;1m\]\w\[\033[m\]\033[32m\]\$(parse_git_branch)\[\033[00m\] \$ "
#export PS1="\u@\h \W\[\033[32m\]\$(parse_git_branch)\[\033[00m\] $ "

#export PS1="\[\033[36m\]\u\[\033[m\]@\[\033[32m\]\h:\[\033[33;1m\]\w\[\033[m\] \$(parse_git_branch)\[\033[00m\] $ "

export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

# Setting PATH for Python 3.8
# The original version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.8/bin:${PATH}"
export PATH
