#!/bin/bash

install_screenfetch() {
	wget https://github.com/KittyKatt/screenFetch/archive/master.zip &&
	unzip master.zip &&
	sudo mv screenFetch-master/screenfetch-dev /usr/bin/screenfetch &&
	sudo rm -rf screenFetch-master
}

# Identify the different distributions and call the corresponding function
multi_distro_installation() {
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
#	install_screenfetch
}
install_dependencies_with_yum() {
    sudo yum install yum-utils
	sudo yum install -y neovim git ranger npm fish unzip
}
install_dependencies_with_apt() {
    sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak
    sudo cp /etc/apt/sources.list.d/raspi.list /etc/apt/sources.list.d/raspi.list.bak
    sudo cat >/etc/apt/sources.list<<EOF
deb https://mirrors.ustc.edu.cn/debian/ bullseye main contrib non-free
deb https://mirrors.ustc.edu.cn/debian/ bullseye-updates main contrib non-free
deb https://mirrors.ustc.edu.cn/debian-security bullseye-security main contrib non-free
EOF
    sudo cat>/etc/apt/sources.list.d/raspi.list<<EOF
deb http://mirrors.ustc.edu.cn/archive.raspberrypi.org/debian/ bullseye main
EOF
    sudo apt update
    sudo apt full-upgrade -y
    sudo apt install iptables fish git neovim nodejs npm python3-venv python3-pip iperf3 -y
    sudo iptables -F
    sudo update-alternatives --set iptables /usr/sbin/iptables-legacy
    sudo update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy
    curl -SfL https://get.docker.com | sh -
    sudo cat >/etc/docker/daemon.json<<EOF
{
  "registry-mirrors": ["https://xx0uqinw.mirror.aliyuncs.com"]
}
EOF
    sudo systemctl restart docker
    
}

common_config() {
    mkdir -p ~/.config && cd ~/.config
    echo 'starting config nvim...'
    git clone https://gitee.com/c-w-b/nvim.git
    cd ~
}

# Entry
main() {
    OS_NAME=$(uname -s | tr '[:upper:]' '[:lower:]')
    if [ "${OS_NAME}" = "linux" ]
    then
        multi_distro_installation
    else
        echo "Non-surported distribution"
    fi
    #common_config
}

main


