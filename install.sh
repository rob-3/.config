#!/bin/bash

# Install neovim
original_dir=$(pwd)
cd /tmp
curl -L https://github.com/neovim/neovim/releases/latest/download/nvim.appimage > nvim.appimage
chmod u+x ./nvim.appimage
./nvim.appimage --appimage-extract
alias nvim="/tmp/squashfs-root/AppRun"
cd $original_dir

mkdir ~/.config
cp -r * ~/.config/
