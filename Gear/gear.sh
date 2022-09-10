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

# Değişkenin Atanması
if [ ! $NAME ]; then
	read -p "İsminizi Yazın: " NAME
	echo 'export NAME='$NAME >> $HOME/.bash_profile
fi

sleep 2

echo -e "\e[1m\e[32m1. Sistem Güncellemesi Yapılıyor... \e[0m" && sleep 2
# Yükleme ve Yükseltme
sudo apt-get update && apt-get upgrade -y

echo -e "\e[1m\e[32m2. Gerekli Kütüphaneler Yükleniyor... \e[0m" && sleep 2
# Kütüphane
sudo apt install make clang curl pkg-config libssl-dev build-essential git jq ncdu bsdmainutils -y < "/dev/null"

sleep 2

echo -e "\e[1m\e[32m3. Binary Dosyası Yükleniyor... \e[0m" && sleep 2
# Binary Kurulum
cd
wget https://builds.gear.rs/gear-nightly-linux-x86_64.tar.xz && \
tar xvf gear-nightly-linux-x86_64.tar.xz && \
rm gear-nightly-linux-x86_64.tar.xz && \
chmod +x gear-node
cp ~/gear-node /usr/bin

sleep 2

echo -e "\e[1m\e[32m4. Servis Başlatılıyor... \e[0m" && sleep 2
# Servis Oluşturma
sudo tee /etc/systemd/system/gear.service > /dev/null <<EOF
[Unit]
Description=Gear Node
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/root/
ExecStart=/usr/bin/gear-node --name $NAME --telemetry-url 'ws://telemetry-backend-shard.gear-tech.io:32001/submit 0'
Restart=always
RestartSec=3
LimitNOFILE=10000

[Install]
WantedBy=multi-user.target
EOF

# Servisi Başlatma
sudo systemctl daemon-reload
sudo systemctl enable gear
sudo systemctl restart gear
systemctl restart systemd-journald

echo '=============== Kurulum, Başarıyla Tamamlandı. Kolay Gelsin... ==================='
echo -e 'Log Kontrol: \e[1m\e[32m journalctl -u gear -f -o cat \e[0m'
