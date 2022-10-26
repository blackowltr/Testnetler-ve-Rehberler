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
if [ ! $SFR ]; then
	read -p "Şifrenizi Girin: " SFR
	echo 'export SFR='$SFR >> $HOME/.bash_profile

fi
echo "export SFR=$SFR" >> $HOME/.bash_profile
source $HOME/.bash_profile

echo '================================================='
echo -e "Şifreniz: \e[1m\e[32m$SFR\e[0m"
echo '================================================='

sleep 2

echo -e "\e[1m\e[32m1. Node Durduruluyor... \e[0m" && sleep 1
# Durdurma İşlemi
docker kill ursula
docker rm ursula

sleep 2

# parola
export NULINK_KEYSTORE_PASSWORD=$SFR

export NULINK_OPERATOR_ETH_PASSWORD=$SFR

sleep 2

echo -e "\e[1m\e[32m3. NuLink Image Dosyası Çekiliyor... \e[0m" && sleep 1
docker pull nulink/nulink:latest

sleep 2

echo -e "\e[1m\e[32m4. Node Başlatılıyor... \e[0m" && sleep 1
docker run --restart on-failure -d \
--name ursula \
-p 9151:9151 \
-v /root/nulink:/code \
-v /root/nulink:/home/circleci/.local/share/nulink \
-e NULINK_KEYSTORE_PASSWORD \
-e NULINK_OPERATOR_ETH_PASSWORD \
nulink/nulink nulink ursula run --no-block-until-ready

echo '=============== Yükleme Tamamlandı. ==================='
echo -e 'Log Kontrol: \e[1m\e[32m docker logs -f ursula \e[0m'
echo '---- Herhangi bir sorunuz olursa benimle iletişime geçebilirsiniz. Discord ID: blackowl#7099... ----'
