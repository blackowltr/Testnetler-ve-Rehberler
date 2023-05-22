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
NIBIRU_CHAIN_ID=nibiru-itn-1
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
curl -s https://get.nibiru.fi/@v0.19.2! | bash

# config
nibid config chain-id $NIBIRU_CHAIN_ID
nibid config keyring-backend test
nibid config node tcp://localhost:${NIBIRU_PORT}657

# init
nibid init $NODENAME --chain-id=nibiru-itn-1 --home $HOME/.nibid

# genesis ve addrbook
NETWORK=nibiru-itn-1
curl -s https://networks.itn.nibiru.fi/$NETWORK/genesis > $HOME/.nibid/config/genesis.json
curl -s https://rpc.itn-1.nibiru.fi/genesis | jq -r .result.genesis > $HOME/.nibid/config/genesis.json

# peers ve seeds
SEEDS="3f472746f46493309650e5a033076689996c8881@nibiru-testnet.rpc.kjnodes.com:39659,a431d3d1b451629a21799963d9eb10d83e261d2c@seed-1.itn-1.nibiru.fi:26656,6a78a2a5f19c93661a493ecbe69afc72b5c54117@seed-2.itn-1.nibiru.fi:26656"
PEERS="a3cdb006b290cd2e694b451e8e141ee397a24eac@85.190.246.96:26656,bf6a9b21fcf5e1aa02a07348959633d58cf1b307@109.123.246.116:26656,b9f203a7d45a2a2766ff144ea9cc680987886772@85.239.242.186:26656,8cca1055bd1eb274af9e122119b52be34774f169@95.217.208.233:26656,8371f0340545c708d68572caf6adc4084fe6ba0c@89.117.63.116:26656,c36bcb5907e0ac74018bf42982b249be090e92c1@192.248.150.77:26656,bae5efe7460f77784c0691290616659001c0c012@38.242.205.48:26656,46c0cb4d56ebfd4c69911c59b3f17cb17bcc3ed7@64.226.94.147:26656,ed66095b43d923ecdc73eb77d6193084036888bc@65.108.2.35:26656,75533faca91c0f8b249d268fa888f498feee0ba3@103.253.147.190:26656,e104fb31e9aa612dd36554616eeb2a08e2439e24@80.85.142.176:26656,6caeb82a187923cba406d09d7b8aa08b5552aac1@184.174.36.166:26656,8279e11d79bb4d5ee3595893a546123423e48b6a@109.123.246.138:26656,41a86600b386e2caff1d6912c91be72ec4f1126e@185.202.223.161:26656,c8bb9b0d660d006f097bf5af4b21b2046dbe1ba3@93.183.208.65:26656,141dccaf3cbe958b9409bee5805f2be35da377e5@183.2.149.136:26656,104a00413d0fc7ec208c810c50d49932da355bd5@129.226.159.141:26656,c794911b61dd57c1f3f0517122560c6be90e1da7@89.116.24.183:39656,be2ebed3286033450a2d7a8a15b5f5d4774663d9@89.116.29.69:26656,7d3867934f0664832f782e3579e30686b069c473@109.123.250.109:26656,2ba6745852fcceb6914111a254ad5380ba721848@5.199.133.114:39656,c03ac8a54e2fe73ac59d621eb0262456eca4d3d8@83.169.217.43:39656,7e5a42fb0ff06ff712c7eafb2dccc04caede5f01@38.242.231.237:26656,03b4f35d5956ae641da3fd21d2b84c7fe146c3ed@95.31.241.194:26656,d478d4a34de532833ec1c4df65f3b79f77265f17@35.229.110.80:26656,90e1f35289a3e527e04b59a53c1baeb4d02bdb63@65.108.94.198:26656,d5519e378247dfb61dfe90652d1fe3e2b3005a5b@65.109.68.190:39656,766f17b24c11b5eac20cf938f619bc2e43331988@38.242.229.238:26656"
sed -i 's|^seeds *=.*|seeds = "'$SEEDS'"|; s|^persistent_peers *=.*|persistent_peers = "'$PEERS'"|' $HOME/.nibid/config/config.toml

# port
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:27658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:27657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:6160\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:27656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":27660\"%" $HOME/.nibid/config/config.toml && sed -i.bak -e "s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:9190\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:9191\"%; s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:1417\"%" $HOME/.nibid/config/app.toml && sed -i.bak -e "s%^node = \"tcp://localhost:26657\"%node = \"tcp://localhost:27657\"%" $HOME/.nibid/config/client.toml 

# prnuning
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

# minimum gas price ve timeout commit
sed -i 's|^minimum-gas-prices *=.*|minimum-gas-prices = "0.0001unibi"|g' $HOME/.nibid/config/app.toml
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

# servis
sudo systemctl daemon-reload
sudo systemctl enable nibid
sudo systemctl start nibid

#Snapshot
sudo systemctl stop nibid

cp $HOME/.nibid/data/priv_validator_state.json $HOME/.nibid/priv_validator_state.json.backup 

nibid tendermint unsafe-reset-all --home $HOME/.nibid --keep-addr-book 
curl https://snapshots2-testnet.nodejumper.io/nibiru-testnet/nibiru-itn-1_2023-05-21.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.nibid

mv $HOME/.nibid/priv_validator_state.json.backup $HOME/.nibid/data/priv_validator_state.json 

sudo systemctl restart nibid

# rpc 
RPC="https://nibiru-testnet.nodejumper.io:443"
sed -i -e "s|^node *=.*|node = \"$RPC\"|" $HOME/.nibid/config/client.toml

sudo systemctl restart nibid

sudo journalctl -u nibid -f --no-hostname -o cat
