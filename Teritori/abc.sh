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
if [ ! $SEED ]; then
	read -p "Discord ID ya da İsminizi Yazın: " SEED
	echo 'export SEED='$SEED >> $HOME/.bash_profile
fi

sleep 2

# Bootstrapt
BOOTS='--bootstrap 152.228.155.120:8765 --bootstrap 95.182.120.179:8765 --bootstrap 195.2.80.120:8765 --bootstrap 195.54.41.148:8765 --bootstrap 65.108.244.233:8765 --bootstrap 195.54.41.130:8765 --bootstrap 185.213.25.229:8765 --bootstrap 195.54.41.115:8765 --bootstrap 62.171.188.69:8765 --bootstrap 49.12.229.140:8765 --bootstrap 213.202.238.77:8765 --bootstrap 5.161.152.123:8765 --bootstrap 65.108.146.132:8765 --bootstrap 65.108.250.158:8765 --bootstrap 195.2.73.130:8765 --bootstrap 188.34.167.3:8765 --bootstrap 188.34.166.77:8765 --bootstrap 45.88.106.199:8765 --bootstrap 79.143.188.183:8765 --bootstrap 62.171.171.11:8765 --bootstrap 65.108.201.41:8765 --bootstrap 159.203.176.252:8765 --bootstrap 194.163.191.80:8765 --bootstrap 146.19.207.4:8765 --bootstrap 135.181.43.174:8765 --bootstrap 95.111.234.205:8765 --bootstrap 192.241.131.113:8765 --bootstrap 45.67.217.16:8765 --bootstrap 65.108.157.67:8765 --bootstrap 65.108.251.175:8765 --bootstrap 95.216.204.235:8765 --bootstrap 45.82.178.159:8765 --bootstrap 161.97.111.145:8765 --bootstrap 149.102.133.130:8765 --bootstrap 65.108.61.32:8765 --bootstrap 95.216.204.32:8765 --bootstrap 188.34.160.74:8765 --bootstrap 185.245.183.246:8765 --bootstrap 213.246.39.14:8765'

sleep 2

echo -e "\e[1m\e[32m1. Gerekli Paketler Yükleniyor... \e[0m" && sleep 2
# Yükleme ve Yükseltme
sudo apt update && sudo apt upgrade -y
sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential bsdmainutils git
make ncdu gcc git jq chrony liblz4-tool -y
sudo apt install cmake -y

sleep 2

echo -e "\e[1m\e[32m2. Rust Yükleniyor... \e[0m" && sleep 2
# Rust Kurulumu
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source "$HOME/.cargo/env"

sleep 2

echo -e "\e[1m\e[32m2. Zeeka Reposu Klonlanıyor... \e[0m" && sleep 2
# Klonlama ve Binary Kurulum
git clone https://github.com/zeeka-network/bazuka

echo -e "\e[1m\e[32m2. Path Oluşturuluyor... \e[0m" && sleep 2
cd bazuka
cargo install --path .

sleep 2

# İnitialize İşlemi
bazuka init --seed $SEED --network debug --node 127.0.0.1:8765

sleep 2

echo -e "\e[1m\e[32m4. Servis Başlatılıyor... \e[0m" && sleep 2
# Servis Oluşturma
IPADDR=$(curl icanhazip.com)
sudo tee <<EOF >/dev/null /etc/systemd/system/zeeka.service
[Unit]
Description=Zeeka node
After=network.target

[Service]
User=$USER
ExecStart=/root/.cargo/bin/bazuka node --listen 0.0.0.0:8765 --external $IPADDR:8765 --network debug --db ~/.bazuka-debug ${BOOTS} --discord-handle $SEED
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF

# Servisi Başlatma
sudo systemctl daemon-reload
sudo systemctl enable zeeka
sudo systemctl restart zeeka
systemctl restart systemd-journald

echo '=============== Kurulum, Başarıyla Tamamlandı. Kolay Gelsin... ==================='
echo -e 'Log Kontrol: \e[1m\e[32m journalctl -u zeeka -f -o cat \e[0m'
