#!/bin/bash

echo -e ''
echo -e '\e[40m\e[92m'
echo ' ██████╗ ██╗      █████╗  ██████╗██╗  ██╗ ██████╗ ██╗    ██╗██╗'     
echo ' ██╔══██╗██║     ██╔══██╗██╔════╝██║ ██╔╝██╔═══██╗██║    ██║██║'
echo ' ██████╔╝██║     ███████║██║     █████╔╝ ██║   ██║██║ █╗ ██║██║'    
echo ' ██╔══██╗██║     ██╔══██║██║     ██╔═██╗ ██║   ██║██║███╗██║██║'
echo ' ██████╔╝███████╗██║  ██║╚██████╗██║  ██╗╚██████╔╝╚███╔███╔╝███████╗'
echo ' ╚═════╝ ╚══════╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝ ╚═════╝  ╚══╝╚══╝ ╚══════╝'
echo -e '\e[0m'
echo ''

sleep 2

# set vars
if [ ! $NAME ]; then
	read -p "Node İsminiz: " NAME
	echo 'export NAME='$NAME >> $HOME/.bash_profile
fi

source $HOME/.bash_profile

echo '================================================='
echo -e "Node İsminiz: \e[1m\e[32m$NAME\e[0m"
echo '================================================='

sleep 2

echo -e "\e[1m\e[32m1. Kütüphaneler Yükleniyor... \e[0m" && sleep 1
# update
sudo apt update && sudo apt upgrade -y
sudo apt-get -y install libssl-dev && apt-get -y install cmake build-essential git wget jq make gcc unzip ca-certificates curl gnupg lsb-release

echo -e "\e[1m\e[32m2. Docker Yükleniyor... \e[0m" && sleep 1
# download docker
cd /root
sudo apt install docker.io -y
sudo systemctl enable --now docker

sleep 2

#download image
docker pull nulink/nulink:latest

# Download file settings

#config
cd /root
mkdir nulink

echo '=============== Şimdi yedeklemiş olduğumuz dosyayı sunucumuza taşıyalım... ==================='

