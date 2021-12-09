#!/bin/bash

function install_screenfetch() {
	wget https://github.com/KittyKatt/screenFetch/archive/master.zip &&
	unzip master.zip &&
	mv screenFetch-master/screenfetch-dev /usr/bin/screenfetch &&
	rm -rf screenFetch-master
}

# Identify the different distributions and call the corresponding function
function multi_distro_installation() {
    if grep -Eqi "CentOS" /etc/issue || grep -Eq "CentOS" /etc/*-release; then
        install_dependencies_with_yum 
    elif grep -Eqi "Fedora" /etc/issue || grep -Eq "Fedora" /etc/*-release; then
        install_dependencies_with_yum 
    elif grep -Eqi "Debian" /etc/issue || grep -Eq "Debian" /etc/*-release; then
        install_dependencies_with_apt 
    elif grep -Eqi "Ubuntu" /etc/issue || grep -Eq "Ubuntu" /etc/*-release; then
        install_dependencies_with_apt
    elif grep -Eqi "Arch" /etc/issue || grep -Eq "Arch" /etc/*-release; then
        install_dependencies_with_aur
    else
        echo "Non-supported operating system version"
    fi
	install_screenfetch
}
function install_dependencies_with_yum() {
    sudo yum install yum-utils
	sudo yum install -y neovim git ranger npm fish
}
function install_dependencies_with_apt() {
    sudo apt-get update
    sudo apt-get install -y neovim git ranger npm fish
}
function install_dependencies_with_aur() {
    sudo pacman -S neovim git ranger npm fish --noconfirm
}
function install_dependencies_on_mac_osx() {
    brew install neovim git ranger npm fish
}

# Entry
function main() {
    OS_NAME=$(uname -s | tr '[:upper:]' '[:lower:]')
    if [[ "${OS_NAME}" == "linux" ]]; then
        multi_distro_installation
    elif [[ "${OS_NAME}" == "darwin" ]]; then
        install_dependencies_on_mac_osx
    else
        echo "Non-surported distribution"
    fi
	npm config set registry https://registry.npm.taobao.org &&
	mkdir -p ~/.config && cd ~/.config &&
	git clone https://github.com/Forgus/nvim.git &&
	cd nvim && git checkout core-qwerty &&
	fish
}

main


