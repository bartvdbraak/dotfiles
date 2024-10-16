#!/usr/bin/env bash

if cp --version &>/dev/null; then
    dotfiles_home="${1:-$(dirname "$(realpath "$0")")}"
    cp -rsf "$dotfiles_home"/. $HOME
    echo "dotfiles symlinks recursively copied from $dotfiles_home to $HOME."
else
    echo "GNU cp required."
fi
