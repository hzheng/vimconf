#!/bin/bash

SH_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
CONF_DIR=$(dirname $SH_DIR)

echo "******creating links..."

if [ -d $HOME/.vim ]; then
    echo $HOME/.vim is a directory, please move it first
    exit 1
fi

read -p "Any existing .vim, .vimrc and .gvim under home directory will be overwritten, are you sure?(y/n) " -n 1
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo links are NOT created 
    exit 2
fi

ln -fs $CONF_DIR $HOME/.vim
ln -fs $CONF_DIR/vimrc $HOME/.vimrc
ln -fs $CONF_DIR/gvimrc $HOME/.gvimrc

