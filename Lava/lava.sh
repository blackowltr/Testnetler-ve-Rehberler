#!/bin/bash

read -r -p "Node Adınızı Yazın: " NODE_MONIKER

echo -e "\e[1m\e[32m1. Sistem Güncellemesi ve Kütüphane Kurulumu Yapılıyor... \e[0m" && sleep 1
sudo apt update && sudo apt upgrade -y 
sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential git make ncdu -y
sudo apt install -y unzip logrotate git jq sed wget curl coreutils systemd
sudo apt autoremove -y
sudo apt install make clang pkg-config libssl-dev build-essential git jq llvm libudev-dev -y

echo -e "\e[1m\e[32m1. Go Yükleniyor... \e[0m" && sleep 1
wget https://go.dev/dl/go1.19.linux-amd64.tar.gz \
&& sudo tar -xvf go1.19.linux-amd64.tar.gz && sudo mv go /usr/local \
&& echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile \
&& source ~/.bash_profile; go version

rm -rf go1.19.linux-amd64.tar.gz

echo -e "\e[1m\e[32m1. Binary... \e[0m" && sleep 1
cd $HOME
rm -rf lava
git clone https://github.com/lavanet/lava
cd lava
git checkout v0.6.0-RC3
make install
lavad version

lavad config keyring-backend test
lavad config chain-id $CHAIN_ID
lavad init "$NODE_MONIKER" --chain-id $CHAIN_ID

curl https://raw.githubusercontent.com/K433QLtr6RA9ExEq/GHFkqmTzpdNLDd6T/main/testnet-1/genesis_json/genesis.json > ~/.lava/config/genesis.json
curl https://files.itrocket.net/testnet/lava/addrbook.json > ~/.lava/config/addrbook.json

SEEDS="3a445bfdbe2d0c8ee82461633aa3af31bc2b4dc0@prod-pnet-seed-node.lavanet.xyz:26656,e593c7a9ca61f5616119d6beb5bd8ef5dd28d62d@prod-pnet-seed-node2.lavanet.xyz:26656"
PEERS=""
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.lava/config/config.toml

sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${LAVA_PORT}317\"%;
s%^address = \":8080\"%address = \":${LAVA_PORT}080\"%;
s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${LAVA_PORT}090\"%; 
s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${LAVA_PORT}091\"%; 
s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${LAVA_PORT}545\"%; 
s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${LAVA_PORT}546\"%" $HOME/.lava/config/app.toml

sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${LAVA_PORT}658\"%; 
s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://0.0.0.0:${LAVA_PORT}657\"%; 
s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${LAVA_PORT}060\"%;
s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${LAVA_PORT}656\"%;
s%^external_address = \"\"%external_address = \"$(wget -qO- eth0.me):${LAVA_PORT}656\"%;
s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${LAVA_PORT}660\"%" $HOME/.lava/config/config.toml

sed -i -e "s/^pruning *=.*/pruning = \"nothing\"/" $HOME/.lava/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"100\"/" $HOME/.lava/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"50\"/" $HOME/.lava/config/app.toml

sed -i 's/minimum-gas-prices =.*/minimum-gas-prices = "0.0ulava"/g' $HOME/.lava/config/app.toml
sed -i -e "s/prometheus = false/prometheus = true/" $HOME/.lava/config/config.toml
sed -i -e "s/^indexer *=.*/indexer = \"null\"/" $HOME/.lava/config/config.toml

sed -i 's/create_empty_blocks = .*/create_empty_blocks = true/g' ~/.lava/config/config.toml
sed -i 's/create_empty_blocks_interval = ".*s"/create_empty_blocks_interval = "60s"/g' ~/.lava/config/config.toml
sed -i 's/timeout_propose = ".*s"/timeout_propose = "60s"/g' ~/.lava/config/config.toml
sed -i 's/timeout_commit = ".*s"/timeout_commit = "60s"/g' ~/.lava/config/config.toml
sed -i 's/timeout_broadcast_tx_commit = ".*s"/timeout_broadcast_tx_commit = "601s"/g' ~/.lava/config/config.toml

lavad tendermint unsafe-reset-all --home $HOME/.lava --keep-addr-book

echo -e "\e[1m\e[32m1. Servis Dosyası Oluşturuluyor ve Node Başlatılıyor... \e[0m" && sleep 1

sudo tee /etc/systemd/system/lavad.service > /dev/null <<EOF
[Unit]
Description=lava
After=network-online.target

[Service]
User=$USER
ExecStart=$(which lavad) start --home $HOME/.lava
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable lavad
sudo systemctl restart lavad
sudo journalctl -u lavad -f -o cat
