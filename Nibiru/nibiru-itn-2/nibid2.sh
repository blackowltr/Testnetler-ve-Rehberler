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

# degiskenler
if [ ! $NODENAME ]; then
	read -p "Node isminiz giriniz: " NODENAME
	echo 'export NODENAME='$NODENAME >> $HOME/.bash_profile
fi
if [ ! $WALLET ]; then
	echo "export WALLET=wallet" >> $HOME/.bash_profile
fi
NIBIRU_CHAIN_ID=nibiru-itn-2
source $HOME/.bash_profile

echo '================================================='
echo -e "Node isminiz: \e[1m\e[32m$NODENAME\e[0m"
echo -e "Cüzdan isminiz: \e[1m\e[32m$WALLET\e[0m"
echo -e "Chain id: \e[1m\e[32m$NIBIRU_CHAIN_ID\e[0m"
echo '================================================='
sleep 2

echo -e "\e[1m\e[32m1. Sistem güncellemesi yapılıyor... \e[0m" && sleep 1
# update
sudo apt update && sudo apt upgrade -y

echo -e "\e[1m\e[32m2. Kütüphaneler kuruluyor... \e[0m" && sleep 1
# paketler
sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential bsdmainutils git make ncdu gcc git jq chrony liblz4-tool -y
sudo apt install -y curl git jq lz4 build-essential unzip

# go
if ! [ -x "$(command -v go)" ]; then
  ver="1.19.2"
  cd $HOME
  wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
  sudo rm -rf /usr/local/go
  sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
  rm "go$ver.linux-amd64.tar.gz"
  echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile
  source ~/.bash_profile
fi

echo -e "\e[1m\e[32m3. Nibiru kurulumu yapılıyor... \e[0m" && sleep 1
curl -s https://get.nibiru.fi/@v0.21.9! | bash

# config
nibid config chain-id $NIBIRU_CHAIN_ID
nibid config keyring-backend test
nibid config node tcp://localhost:${NIBIRU_PORT}657

# başlatma
nibid init $NODENAME --chain-id=nibiru-itn-2 --home $HOME/.nibid

# genesis ve addrbook
NETWORK=nibiru-itn-2
curl -s https://networks.itn2.nibiru.fi/$NETWORK/genesis > $HOME/.nibid/config/genesis.json
curl -s https://rpc.itn-2.nibiru.fi/genesis | jq -r .result.genesis > $HOME/.nibid/config/genesis.json

# peers ve seeds
NETWORK=nibiru-itn-2
sed -i 's|seeds =.*|seeds = "'$(curl -s https://networks.itn2.nibiru.fi/$NETWORK/seeds)'"|g' $HOME/.nibid/config/config.toml

# port
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:27658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:27657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:6160\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:27656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":27660\"%" $HOME/.nibid/config/config.toml && sed -i.bak -e "s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:9190\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:9191\"%; s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:1417\"%" $HOME/.nibid/config/app.toml && sed -i.bak -e "s%^node = \"tcp://localhost:26657\"%node = \"tcp://localhost:27657\"%" $HOME/.nibid/config/client.toml 

# pruning
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.nibid/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.nibid/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.nibid/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.nibid/config/app.toml
sed -i "s/snapshot-interval *=.*/snapshot-interval = 0/g" $HOME/.nibid/config/app.toml

# indexer
indexer="null"
sed -i -e "s/^indexer *=.*/indexer = \"$indexer\"/" $HOME/.nibid/config/config.toml

# gas price ve prometheus ayarı
sed -i 's/minimum-gas-prices =.*/minimum-gas-prices = "0.025unibi"/g' $HOME/.nibid/config/app.toml
sed -i 's|^prometheus *=.*|prometheus = true|' $HOME/.nibid/config/config.toml

# reset
nibid tendermint unsafe-reset-all --home $HOME/.nibid

echo -e "\e[1m\e[32m4. Servis Başlatılıyor... \e[0m" && sleep 1
# servis
sudo tee /etc/systemd/system/nibid.service > /dev/null <<EOF
[Unit]
Description=Nibiru
After=network-online.target

[Service]
User=$USER
ExecStart=$(which nibid) start
Restart=always
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF

# servis başlatma
sudo systemctl daemon-reload
sudo systemctl enable nibid
sudo systemctl start nibid
systemctl restart systemd-journald
sudo journalctl -u nibid -f --no-hostname -o cat
