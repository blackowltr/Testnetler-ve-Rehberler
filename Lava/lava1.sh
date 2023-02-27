#!/bin/bash

read -r -p "Node Adınızı Yazın: " NODE_MONIKER

echo -e "\e[1m\e[32m1. Sistem Güncellemesi ve Kütüphane Kurulumu Yapılıyor... \e[0m" && sleep 1
sudo apt update && sudo apt upgrade -y 
sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential git make ncdu -y
sudo apt install -y unzip logrotate git jq sed wget curl coreutils systemd
sudo apt autoremove -y
sudo apt install make clang pkg-config libssl-dev build-essential git jq llvm libudev-dev -y

echo -e "\e[1m\e[32m1. Binary... \e[0m" && sleep 1
cd || return
rm -rf lava
git clone https://github.com/lavanet/lava
cd lava || return
git checkout v0.6.0-RC3
make install
lavad version

lavad config keyring-backend test
lavad config chain-id $CHAIN_ID
lavad init "$NODE_MONIKER" --chain-id $CHAIN_ID

curl -s https://raw.githubusercontent.com/K433QLtr6RA9ExEq/GHFkqmTzpdNLDd6T/main/testnet-1/genesis_json/genesis.json > $HOME/.lava/config/genesis.json
curl -s https://snapshots1-testnet.nodejumper.io/lava-testnet/addrbook.json > $HOME/.lava/config/addrbook.json

SEEDS="3a445bfdbe2d0c8ee82461633aa3af31bc2b4dc0@prod-pnet-seed-node.lavanet.xyz:26656,e593c7a9ca61f5616119d6beb5bd8ef5dd28d62d@prod-pnet-seed-node2.lavanet.xyz:26656"
PEERS=""
sed -i 's|^seeds *=.*|seeds = "'$SEEDS'"|; s|^persistent_peers *=.*|persistent_peers = "'$PEERS'"|' $HOME/.lava/config/config.toml

sed -i 's|^pruning *=.*|pruning = "custom"|g' $HOME/.lava/config/app.toml
sed -i 's|^pruning-keep-recent  *=.*|pruning-keep-recent = "100"|g' $HOME/.lava/config/app.toml
sed -i 's|^pruning-interval *=.*|pruning-interval = "10"|g' $HOME/.lava/config/app.toml
sed -i 's|^snapshot-interval *=.*|snapshot-interval = 2000|g' $HOME/.lava/config/app.toml

sed -i 's|^minimum-gas-prices *=.*|minimum-gas-prices = "0.025ulava"|g' $HOME/.lava/config/app.toml
sed -i 's|^prometheus *=.*|prometheus = true|' $HOME/.lava/config/config.toml

echo -e "\e[1m\e[32m1. Servis Dosyası Oluşturuluyor ve Node Başlatılıyor... \e[0m" && sleep 1

sudo tee /etc/systemd/system/lavad.service > /dev/null << EOF
[Unit]
Description=Lava Network Node
After=network-online.target
[Service]
User=$USER
ExecStart=$(which lavad) start
Restart=on-failure
RestartSec=10
LimitNOFILE=10000
[Install]
WantedBy=multi-user.target
EOF

lavad tendermint unsafe-reset-all --home $HOME/.lava --keep-addr-book

sudo systemctl daemon-reload
sudo systemctl enable lavad
sudo systemctl start lavad
