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

echo -e "\e[1m\e[32m1. Gerekli Kütüphaneler Yükleniyor... \e[0m" && sleep 2
# Yükleme ve Yükseltme
sudo apt-get update && apt-get upgrade -y
sudo apt-get -y install libssl-dev && apt-get -y install cmake build-essential git wget jq make gcc

echo -e "\e[1m\e[32m2. Worker Hesabı Oluşturuluyor... \e[0m" && sleep 2
# Hesap Oluşturma
wget https://gethstore.blob.core.windows.net/builds/geth-linux-amd64-1.10.24-972007a5.tar.gz
tar -xvzf geth-linux-amd64-1.10.24-972007a5.tar.gz
cd geth-linux-amd64-1.10.24-972007a5/
./geth account new --keystore ./keystore

sleep 15

# Değişkenin Atanması
if [ ! $KEY ]; then
	read -p "Path of secret key file yazın: " KEY
	echo 'export KEY='$KEY >> $HOME/.bash_profile
fi

sleep 2

if [ ! $PKEY ]; then
	read -p "Public adresinizi yazın: " PKEY
	echo 'export PKEY='$PKEY >> $HOME/.bash_profile
fi

sleep 2

if [ ! $UTC ]; then
	read -p "Path secret key file dosyanızı UTC kısmından başlayacak şekilde yazın: " UTC
	echo 'export UTC='$UTC >> $HOME/.bash_profile
fi

sleep 2

if [ ! $SFR ]; then
	read -p "Bir şifre oluşturun: " SFR
	echo 'export SFR='$SFR >> $HOME/.bash_profile
fi

sleep 3

echo -e "\e[1m\e[32m3. Docker Kuruluyor... \e[0m" && sleep 2
# Docker Kurulum
cd /root
sudo apt install docker.io -y
sudo systemctl enable --now docker

sleep 2

echo -e "\e[1m\e[32m4. NuLink İmage Dosyası Çekiliyor... \e[0m" && sleep 2
docker pull nulink/nulink:latest

sleep 2

# Dosya Oluşturma
cd /root
mkdir nulink

sleep 2

# Secret key ekleme
 cp $KEY /root/nulink
chmod -R 777 /root/nulink

sleep 2

# Şifre Oluşturma
export NULINK_KEYSTORE_PASSWORD=SFR

export NULINK_OPERATOR_ETH_PASSWORD=SFR

sleep 3

# Servisi Başlatma
docker run -it --rm \
-p 9151:9151 \
-v /root/nulink:/code \
-v /root/nulink:/home/circleci/.local/share/nulink \
-e NULINK_KEYSTORE_PASSWORD \
nulink/nulink nulink ursula init \
--signer keystore:///code/$UTC \
--eth-provider https://data-seed-prebsc-2-s2.binance.org:8545  \
--network horus \
--payment-provider https://data-seed-prebsc-2-s2.binance.org:8545 \
--payment-network bsc_testnet \
--operator-address PKEY \
--max-gas-price 100

sleep 15

# Node Başlatma
docker run --restart on-failure -d \
--name ursula \
-p 9152:9152 \
-v /root/nulink:/code \
-v /root/nulink:/home/circleci/.local/share/nulink \
-e NULINK_KEYSTORE_PASSWORD \
-e NULINK_OPERATOR_ETH_PASSWORD \
nulink/nulink nulink ursula run --no-block-until-ready

sleep 5

echo '------------------- Kurulum, Başarıyla Tamamlandı. Kolay Gelsin... -------------------' && sleep 2

sleep 2

# Log Kaydı Görüntüleme
apt install screen && screen -S log
docker logs -f ursula

