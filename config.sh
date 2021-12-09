#!/bin/bash
sudo yum install -y neovim git ranger npm fish &&
npm config set registry https://registry.npm.taobao.org &&
wget https://github.com/KittyKatt/screenFetch/archive/master.zip &&
unzip master.zip &&
mv screenFetch-master/screenfetch-dev /usr/bin/screenfetch &&
rm -rf screenFetch-master &&
mkdir -p ~/.config && cd ~/.config &&
git clone https://github.com/Forgus/nvim.git &&
cd nvim && git checkout core-qwerty &&
fish





