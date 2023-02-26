#! /bin/bash

# Variables

EXECUTE=lavad
CHAIN_ID=lava-testnet1
PORT=26
SYSTEM_FOLDER=.lava
PROJECT_FOLDER=lava-config/testnet-1
VERSION=v0.4.3
REPO=https://github.com/lavanet/lava-config.git
GENESIS_FILE=https://raw.githubusercontent.com/lavanet/lava-config/main/testnet-1/genesis_json/genesis.json
ADDRBOOK=http://94.250.203.6:90/lava-addrbook.json
MIN_GAS=
DENOM=ulava
SEEDS=5c2a752c9b1952dbed075c56c600c3a79b58c395@lava.testnet.seed.autostake.net:27066
PEERS=5c2a752c9b1952dbed075c56c600c3a79b58c395@lava.testnet.peer.autostake.net:27066
SEED_MODE="true"
SNAP_NAME=$(curl -s http://94.250.203.6:90 | egrep -o ">lavad-snap*.*tar" | tr -d ">")
sleep 2

echo "export EXECUTE=${EXECUTE}" >> $HOME/.bash_profile
echo "export CHAIN_ID=${CHAIN_ID}" >> $HOME/.bash_profile
echo "export PORT=${PORT}" >> $HOME/.bash_profile
echo "export SYSTEM_FOLDER=${SYSTEM_FOLDER}" >> $HOME/.bash_profile
echo "export PROJECT_FOLDER=${PROJECT_FOLDER}" >> $HOME/.bash_profile
echo "export VERSION=${VERSION}" >> $HOME/.bash_profile
echo "export REPO=${REPO}" >> $HOME/.bash_profile
echo "export GENESIS_FILE=${GENESIS_FILE}" >> $HOME/.bash_profile
echo "export PEERS=${PEERS}" >> $HOME/.bash_profile
echo "export SEEDS=${SEEDS}" >> $HOME/.bash_profile
echo "export MIN_GAS=${MIN_GAS}" >> $HOME/.bash_profile
echo "export DENOM=${DENOM}" >> $HOME/.bash_profile
echo "export SEED_MODE=${SEED_MODE}" >> $HOME/.bash_profile
source $HOME/.bash_profile

sleep 1

if [ ! $MONIKER ]; then
	read -p "Node Adınızı Yazın: " MONIKER
	echo 'export MONIKER='$MONIKER >> $HOME/.bash_profile
fi

sleep 1

if [ ! $WALLET_NAME ]; then
	read -p "Cüzdan Adınızı Yazın : " WALLET_NAME
	echo 'export WALLET_NAME='$WALLET_NAME >> $HOME/.bash_profile
fi

# Updates

sudo apt update && sudo apt upgrade -y
sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential git make ncdu -y
sudo apt install -y unzip logrotate git jq sed wget curl coreutils systemd

ver="1.18"
cd $HOME
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"

echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> $HOME/.bash_profile
source $HOME/.bash_profile
go version

sleep 1


cd $HOME
git clone $REPO
cd $PROJECT_FOLDER
source setup_config/setup_config.sh
mkdir -p $HOME/$SYSTEM_FOLDER/config
cp default_lavad_config_files/* $HOME/$SYSTEM_FOLDER/config
cp genesis_json/genesis.json $HOME/$SYSTEM_FOLDER/config/genesis.json

sleep 1
cd $HOME
mkdir -p $HOME/go/bin
cd go
cd bin
wget https://lava-binary-upgrades.s3.amazonaws.com/testnet/$VERSION/lavad
chmod +x lavad
source $HOME/.bash_profile

cd $HOME

#Reset network
$EXECUTE tendermint unsafe-reset-all --home $HOME/$SYSTEM_FOLDER


$EXECUTE init $MONIKER --chain-id $CHAIN_ID

#GENESIS AND DATA FILES

if [ $GENESIS_FILE ]; then
	wget $GENESIS_FILE -O $HOME/$SYSTEM_FOLDER/config/genesis.json
fi

sleep 1

#if [ $ADDRBOOK ]; then
#    wget -qO $HOME/$SYSTEM_FOLDER/config/addrbook.json $ADDRBOOK
#fi

if [ $ADDRBOOK ]; then
	wget $ADDRBOOK -O $HOME/$SYSTEM_FOLDER/config/addrbook.json
fi



SEEDS="$SEEDS"
PEERS=""
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.lava/config/config.toml
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.lava/config/config.toml

sleep 1



#wget -O lava.sh https://node101.io/testnet/lava-testnet1/lava.sh && chmod +x lava.sh && ./lava.sh


#SNAPSHOT
SNAPSHOT_URL=http://94.250.203.6:90/${SNAP_NAME}
if [ $SNAPSHOT_URL ]; then
    mv $HOME/.lava/data/priv_validator_state.json $HOME
	rm -rf  $HOME/.lava/data
	wget -P $HOME $SNAPSHOT_URL
	tar xf $HOME/${SNAP_NAME} -C $HOME/.lava
	rm $HOME/${SNAP_NAME}
	mv $HOME/priv_validator_state.json $HOME/.lava/data
	wget -qO $HOME/.lava/config/addrbook.json http://94.250.203.6:90/lava-addrbook.json
	
	
	
	
	
	#cd $HOME
	#rm -rf ~/$SYSTEM_FOLDER/data
	#mkdir -p ~/$SYSTEM_FOLDER/data
	#wget -O - $SNAPSHOT_URL | tar xf - \
	#	-C ~/$SYSTEM_FOLDER/data/
    #echo "{}" >> $HOME/.lava/data/priv_validator_state.json
fi


cd $HOME

# Creating your systemd service

sudo tee /etc/systemd/system/$EXECUTE.service > /dev/null <<EOF
[Unit]
Description=Lava Node
After=network-online.target
[Service]
User=$USER
ExecStart=$(which $EXECUTE) start --home="$HOME/.lava"
Restart=always
RestartSec=180
LimitNOFILE=infinity
LimitNPROC=infinity
[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable $EXECUTE
sudo systemctl restart $EXECUTE


echo '=============== SETUP IS FINISHED ==================='
echo -e "Log Kontrol : \e[1m\e[32mjournalctl -fu ${EXECUTE} -o cat\e[0m"
echo -e "Sync Kontrol: \e[1m\e[32mcurl -s localhost:${PORT}657/status | jq .result.sync_info\e[0m"

source $HOME/.bash_profile
