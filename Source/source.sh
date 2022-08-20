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
if [ ! $NODENAME ]; then
	read -p "Node İsminizi Girin: " NODENAME
	echo 'export NODENAME='$NODENAME >> $HOME/.bash_profile
fi
SOURCE_PORT=16
if [ ! $WALLET ]; then
	echo "export WALLET=wallet" >> $HOME/.bash_profile
fi
echo "export SOURCE_CHAIN_ID=SOURCE-TESTNET-4" >> $HOME/.bash_profile
echo "export SOURCE_PORT=${SOURCE_PORT}" >> $HOME/.bash_profile
source $HOME/.bash_profile

echo '================================================='
echo -e "Node İsminiz: \e[1m\e[32m$NODENAME\e[0m"
echo -e "Cüzdan İsminiz: \e[1m\e[32m$WALLET\e[0m"
echo -e "Ağ Bilginiz: \e[1m\e[32m$SOURCE_CHAIN_ID\e[0m"
echo -e "Port Numaranız: \e[1m\e[32m$SOURCE_PORT\e[0m"
echo '================================================='

sleep 2

echo -e "\e[1m\e[32m1. Paketler Yükleniyor... \e[0m" && sleep 1
# update
sudo apt update && sudo apt upgrade -y

echo -e "\e[1m\e[32m2. Yüklemeler Tamamlanıyor... \e[0m" && sleep 1
# packages
sudo apt install curl build-essential git wget jq make gcc tmux chrony -y

#Kütüphane kurulumu
echo -e "\e[1m\e[32m2. Kütüphane Kurulumu Tamamlanıyor... \e[0m" && sleep 1
sudo apt install make clang pkg-config libssl-dev build-essential git jq ncdu bsdmainutils -y < "/dev/null"

# Go Kurulumu
if ! [ -x "$(command -v go)" ]; then
  ver="1.18.2"
  cd $HOME
  wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
  sudo rm -rf /usr/local/go
  sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
  rm "go$ver.linux-amd64.tar.gz"
  echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile
  source ~/.bash_profile
fi

echo -e "\e[1m\e[32m3. Source protocol'un github dosyası sunucumuza klonlanıyor...\e[0m" && sleep 1
# Klonlama
git clone -b testnet https://github.com/Source-Protocol-Cosmos/source.git

# config
sourced config chain-id $SOURCE_CHAIN_ID
sourced config keyring-backend test
sourced config node tcp://localhost:${SOURCE_PORT}657

# init
sourced init $NODENAME --chain-id $SOURCE_CHAIN_ID

# download genesis and addrbook
wget -O $HOME/.source/config/addrbook.json "https://raw.githubusercontent.com/mmc6185/node-testnets/main/source-protocol/addrbook.json"
curl -s  https://raw.githubusercontent.com/Source-Protocol-Cosmos/testnets/master/sourcechain-testnet/genesis.json > ~/.source/config/genesis.json

# set peers and seeds
SEEDS="6ca675f9d949d5c9afc8849adf7b39bc7fccf74f@164.92.98.17:26656"
PEERS=""
sed -i.bak 's/persistent_peers =.*/persistent_peers = "6ca675f9d949d5c9afc8849adf7b39bc7fccf74f@164.92.98.17:26656"/' $HOME/.source/config/config.toml
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.source/config/config.toml

# set custom ports
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${SOURCE_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${SOURCE_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${SOURCE_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${SOURCE_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${SOURCE_PORT}660\"%" $HOME/.source/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${SOURCE_PORT}317\"%; s%^address = \":8080\"%address = \":${SOURCE_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${SOURCE_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${SOURCE_PORT}091\"%" $HOME/.source/config/app.toml

# config pruning
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="50"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.source/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.source/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.source/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.source/config/app.toml

# set minimum gas price and timeout commit
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.00125usource\"/" $HOME/.source/config/app.toml

# enable prometheus
sed -i -e "s/prometheus = false/prometheus = true/" $HOME/.source/config/config.toml

# reset
sourced tendermint unsafe-reset-all --home $HOME/.source

echo -e "\e[1m\e[32m4. Servis Başlatılıyor... \e[0m" && sleep 1
# create service
echo "[Unit]
Description=Source-protocol Node
After=network.target

[Service]
User=root
Type=simple
ExecStart=$(which sourced) start
Restart=on-failure
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target" > root/sourced.service
sudo mv root/sourced.service /etc/systemd/system
sudo tee <<EOF >/dev/null /etc/systemd/journald.conf
Storage=persistent
EOF

# start service
sudo systemctl daemon-reload
sudo systemctl enable sourced
sudo systemctl restart sourced

echo '=============== Yükleme Başarıyla Tamamlandı. ==================='
echo -e 'Not: \e[1m\e[32mSync durumunuz False olmadan Validator Oluşturmayı Denemeyin..\e[0m'
echo -e 'Log Kontrol: \e[1m\e[32mjournalctl -fu sourced -o cat\e[0m'
echo -e "Sync Durumu: \e[1m\e[32msourced status 2>&1 | jq .SyncInfo\e[0m"
echo -e "Cüzdan Bakiye Kontrol: \e[1m\e[32msourced query bank balances cüzdanisminiz\e[0m"
