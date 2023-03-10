#!/bin/bash

# Install neovim
original_dir=$(pwd)
cd ~
curl -L https://github.com/neovim/neovim/releases/latest/download/nvim.appimage > nvim.appimage
chmod u+x ./nvim.appimage
./nvim.appimage --appimage-extract
cd $original_dir

echo 'alias nvim="~/squashfs-root/AppRun \"$@\""' >> ~/.bashrc

mkdir ~/.config
cp -r * ~/.config/
