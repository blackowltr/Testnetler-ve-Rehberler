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

# Moniker yazın
read -p "Lütfen bir moniker girin: " moniker

# Sistem güncelleme 
sudo apt update && sudo apt upgrade -y
sleep 2

# Gerekli kütüphaneler
sudo apt install make clang pkg-config libssl-dev build-essential git screen protobuf-compiler -y
sleep 2

# rust
yes 1 | curl https://sh.rustup.rs -sSf | sh
sleep 2

# rust ortam değişkeni ekleme
source $HOME/.cargo/env
sleep 2

# rust güncelleme
rustup update nightly
sleep 2

# rust
rustup target add wasm32-unknown-unknown --toolchain nightly
sleep 2

# Avail repo klonlama
git clone https://github.com/availproject/avail.git
sleep 2

# avail klasörüne girme
cd avail
sleep 2

# derleme
cargo build --release -p data-avail
sleep 2

# yeni dizin
mkdir -p output
sleep 2

# git checkout
git checkout v1.7.2
sleep 2

# cargo aracı ile rust uygulamasını çalıştırmak
cargo run --locked --release -- --chain kate -d ./output
sleep 2

# servis oluşturma
sudo tee /etc/systemd/system/availd.service > /dev/null <<EOF
[Unit]
Description=Avail Validator
After=network.target
StartLimitIntervalSec=0
[Service]
User=root
ExecStart= /root/avail/target/release/data-avail --base-path `pwd`/data --chain kate --name $moniker
Restart=always
RestartSec=120
[Install]
WantedBy=multi-user.target
EOF
sleep 2

# Onbeşinci komut
sudo systemctl enable availd.service
sudo systemctl start availd.service


