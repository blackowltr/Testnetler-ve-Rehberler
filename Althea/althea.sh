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
ALTHEA_CHAIN_ID=althea_7357-1
source $HOME/.bash_profile

echo '================================================='
echo -e "Node isminiz: \e[1m\e[32m$NODENAME\e[0m"
echo -e "Chain id: \e[1m\e[32m$ALTHEA_CHAIN_ID\e[0m"
echo '================================================='
sleep 2
# binary yükleme
cd || return
rm -rf althea-chain
git clone https://github.com/althea-net/althea-chain
cd althea-chain || return
git checkout v0.3.2
make install
althea version # v0.3.2

althea config keyring-backend test
althea config chain-id althea_7357-1
althea init "$NODENAME" --chain-id althea_7357-1
# addrbook ve genesis.json 
curl -s https://raw.githubusercontent.com/althea-net/althea-chain-docs/main/testnet-3-genesis.json > $HOME/.althea/config/genesis.json
curl -s https://snapshots2-testnet.nodejumper.io/althea-testnet/addrbook.json > $HOME/.althea/config/addrbook.json
# peer ve seed ayarlama
SEEDS=""
PEERS=""
sed -i 's|^seeds *=.*|seeds = "'$SEEDS'"|; s|^persistent_peers *=.*|persistent_peers = "'$PEERS'"|' $HOME/.althea/config/config.toml
# pruning ve indexer
sed -i 's|^pruning *=.*|pruning = "custom"|g' $HOME/.althea/config/app.toml
sed -i 's|^pruning-keep-recent  *=.*|pruning-keep-recent = "100"|g' $HOME/.althea/config/app.toml
sed -i 's|^pruning-interval *=.*|pruning-interval = "10"|g' $HOME/.althea/config/app.toml
sed -i 's|^snapshot-interval *=.*|snapshot-interval = 0|g' $HOME/.althea/config/app.toml

sed -i 's|^minimum-gas-prices *=.*|minimum-gas-prices = "0.0001ualthea"|g' $HOME/.althea/config/app.toml
sed -i 's|^prometheus *=.*|prometheus = true|' $HOME/.althea/config/config.toml

sed -i -e 's|^indexer *=.*|indexer = "null"|' $HOME/.althea/config/config.toml
# servis baslatma
sudo tee /etc/systemd/system/althead.service > /dev/null << EOF
[Unit]
Description=Althea Node
After=network-online.target
[Service]
User=$USER
ExecStart=$(which althea) start
Restart=on-failure
RestartSec=10
LimitNOFILE=10000
[Install]
WantedBy=multi-user.target
EOF

althea tendermint unsafe-reset-all --home $HOME/.althea --keep-addr-book
# snapshot
SNAP_NAME=$(curl -s https://snapshots2-testnet.nodejumper.io/althea-testnet/info.json | jq -r .fileName)
curl "https://snapshots2-testnet.nodejumper.io/althea-testnet/${SNAP_NAME}" | lz4 -dc - | tar -xf - -C $HOME/.althea
# baslatma
sudo systemctl daemon-reload
sudo systemctl enable althead
sudo systemctl start althead

sudo journalctl -u althead -f --no-hostname -o cat
