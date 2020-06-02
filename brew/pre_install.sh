#! /bin/bash

git clone https://mirrors.ustc.edu.cn/brew.git /usr/local/Homebrew
git clone https://mirrors.ustc.edu.cn/homebrew-core.git /usr/local/Homebrew/Library/Taps/homebrew/homebrew-core
git clone https://mirrors.ustc.edu.cn/homebrew-cask.git /usr/local/Homebrew/Library/Taps/homebrew/homebrew-cask

userBash=$(env|grep -i shell=|awk -F"\/" '{print $NF}')

if [ "x$userBash" = "xbash" ]; then
	echo 'export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.ustc.edu.cn/homebrew-bottles' >> ~/.bash_profile
else
	echo 'export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.ustc.edu.cn/homebrew-bottles' >> ~/.zsh_profile
fi
