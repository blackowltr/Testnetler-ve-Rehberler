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

if [ ! $NODENAME ]; then
	read -p "Node İsminizi Girin: " NODENAME
	echo 'export NODENAME='$NODENAME >> $HOME/.bash_profile
fi
LAVA_PORT=21
if [ ! $WALLET ]; then
	echo "export WALLET=wallet" >> $HOME/.bash_profile
fi
echo "export CHAIN_ID=lava-testnet-1" >> $HOME/.bash_profile
echo "export PORT=${PORT}" >> $HOME/.bash_profile
source $HOME/.bash_profile

echo '================================================='
echo -e "Node İsminiz: \e[1m\e[32m$NODENAME\e[0m"
echo -e "Cüzdan İsminiz: \e[1m\e[32m$WALLET\e[0m"
echo -e "Ağ Bilginiz: \e[1m\e[32m$CHAIN_ID\e[0m"
echo -e "Port Numaranız: \e[1m\e[32m$PORT\e[0m"
echo '================================================='

sleep 1

sudo apt update && sudo apt upgrade -y 
sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential git make ncdu -y
sudo apt install -y unzip logrotate git jq sed wget curl coreutils systemd

sleep 1

 ver="1.18.2"
  cd $HOME
  wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
  sudo rm -rf /usr/local/go
  sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
  rm "go$ver.linux-amd64.tar.gz"
  echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile
  source ~/.bash_profile

sleep 1

cd || return
rm -rf lava
git clone https://github.com/lavanet/lava
cd lava || return
git checkout v0.6.0-RC3
make install

sleep 1

wget -qO $HOME/.lava/config/genesis.json http://94.250.203.6:90/lava-genesis.json

sleep 1

lavad config keyring-backend test
lavad config chain-id $CHAIN_ID
lavad init "$NODENAME" --chain-id $CHAIN_ID

sleep 1

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

sudo systemctl enable lavad
sudo systemctl daemon-reload

sleep 1

lavad tendermint unsafe-reset-all --home $HOME/.lava --keep-addr-book

sleep 1

snap=$(curl -s http://94.250.203.6:90 | egrep -o ">lavad-snap*.*tar" | tr -d ">")
mv $HOME/.lava/data/priv_validator_state.json $HOME
rm -rf  $HOME/.lava/data
wget -P $HOME http://94.250.203.6:90/${snap}
tar xf $HOME/${snap} -C $HOME/.lava
rm $HOME/${snap}
mv $HOME/priv_validator_state.json $HOME/.lava/data
wget -qO $HOME/.lava/config/addrbook.json http://94.250.203.6:90/lava-addrbook.json
sudo systemctl restart lavad
sudo journalctl -u lavad -f -o cat
