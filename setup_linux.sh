#/bin/bash

set -xe

echo "Setting up bash profile...."
ln -s ~/dev/github.com/priyakdey/dotfiles/bash_profile/.bashrc ~/.bashrc
ln -s ~/dev/github.com/priyakdey/dotfiles/bash_profile/.bash_aliases ~/.bash_aliases

echo "Setting up github profile"
ln -s ~/dev/github.com/priyakdey/dotfiles/git/.gitconfig ~/.gitconfig

