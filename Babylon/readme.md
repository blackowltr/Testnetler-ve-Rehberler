# Babylon Testner Kurulum Rehberi

### Sistem Gereksinimleri
| CPU     | RAM      | Disk     |
| ------------- | ------------- | -------- |
| 4          | 8GB         | 200GB  |

**Sistem Güncellemesi ve Kütüphane Kurulumu**
```
sudo apt update && sudo apt upgrade -y
```
```
sudo apt install -y curl build-essential git wget jq make gcc tmux chrony lz4 unzip
```
## Go Kurulumu
```
ver="1.19.3"
cd $HOME
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile
source ~/.bash_profile
go version
```
## Node Adını Belirleme
> İSİM yazan yer kendiniz bir isim yazın.
```
NODENAME="İSİM"
```
## Binary Kurulumu
```
cd $HOME && rm -rf babylon
git clone https://github.com/babylonchain/babylon.git
cd babylon
git checkout v0.5.0
make install
```

## Gerekli Dosyalarda Gerekli Ayarlar
```
BABYLON_PORT=30
echo "export BABYLON_CHAIN_ID=bbn-test1" >> $HOME/.bash_profile
echo "export BABYLON_PORT=${BABYLON_PORT}" >> $HOME/.bash_profile
source $HOME/.bash_profile

babylond config chain-id $BABYLON_CHAIN_ID
babylond config keyring-backend test
babylond config node tcp://localhost:${BABYLON_PORT}657
babylond init $NODENAME --chain-id $BABYLON_CHAIN_ID
```
## Genesis ve Addrbook Ayarı
```
wget -qO $HOME/.babylond/config/genesis.json wget "https://snapshot.yeksin.net/babylon/genesis.json"
wget -qO $HOME/.babylond/config/addrbook.json wget "https://snapshot.yeksin.net/babylon/addrbook.json"
```
## Seed ve Peer Ayarı

```
SEEDS="03ce5e1b5be3c9a81517d415f65378943996c864@18.207.168.204:26656,a5fabac19c732bf7d814cf22e7ffc23113dc9606@34.238.169.221:26656"
PEERS=""
sed -i 's|^seeds *=.*|seeds = "'$SEEDS'"|; s|^persistent_peers *=.*|persistent_peers = "'$PEERS'"|' $HOME/.babylond/config/config.toml
```
## Pruning Ayarı (Disk Kullanımının Azaltılması Amacıyla)
```
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.babylond/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.babylond/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.babylond/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.babylond/config/app.toml

sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0ubbn\"/" $HOME/.babylond/config/app.toml
sed -i -e "s/prometheus = false/prometheus = true/" $HOME/.babylond/config/config.toml
sed -i 's|^checkpoint-tag *=.*|checkpoint-tag = "bbn0"|g' $HOME/.babylond/config/app.toml
```
## Port
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${BABYLON_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${BABYLON_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${BABYLON_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${BABYLON_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${BABYLON_PORT}660\"%" $HOME/.babylond/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${BABYLON_PORT}317\"%; s%^address = \":8080\"%address = \":${BABYLON_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${BABYLON_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${BABYLON_PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${BABYLON_PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${BABYLON_PORT}546\"%" $HOME/.babylond/config/app.toml
```

## Servis Dosyası Oluşturma
```
sudo tee /etc/systemd/system/babylond.service > /dev/null << EOF
[Unit]
Description=Babylon Node
After=network-online.target
[Service]
User=$USER
ExecStart=$(which babylond) start
Restart=on-failure
RestartSec=10
LimitNOFILE=10000
[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable babylond
sudo systemctl start babylond
sudo journalctl -u babylond -f -o cat
```

## Snapshot (NodeJumper)

```
sudo apt update
sudo apt install lz4 -y
```

```
sudo systemctl stop babylond

cp $HOME/.babylond/data/priv_validator_state.json $HOME/.babylond/priv_validator_state.json.backup 

babylond tendermint unsafe-reset-all --home $HOME/.babylond --keep-addr-book 
curl https://snapshots1-testnet.nodejumper.io/babylon-testnet/bbn-test1_2023-03-01.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.babylond

mv $HOME/.babylond/priv_validator_state.json.backup $HOME/.babylond/data/priv_validator_state.json 

sudo systemctl start babylond
sudo journalctl -u babylond -f --no-hostname -o cat
```

## State Sync (NodeJumper)

```
sudo systemctl stop babylond

cp $HOME/.babylond/data/priv_validator_state.json $HOME/.babylond/priv_validator_state.json.backup
babylond tendermint unsafe-reset-all --home $HOME/.babylond --keep-addr-book

SNAP_RPC="https://babylon-testnet.nodejumper.io:443"

LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height)
BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000))
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)

echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH

PEERS="88bed747abef320552d84d02947d0dd2b6d9c71c@babylon-testnet.nodejumper.io:44656"
sed -i 's|^persistent_peers *=.*|persistent_peers = "'$PEERS'"|' $HOME/.babylond/config/config.toml

sed -i 's|^enable *=.*|enable = true|' $HOME/.babylond/config/config.toml
sed -i 's|^rpc_servers *=.*|rpc_servers = "'$SNAP_RPC,$SNAP_RPC'"|' $HOME/.babylond/config/config.toml
sed -i 's|^trust_height *=.*|trust_height = '$BLOCK_HEIGHT'|' $HOME/.babylond/config/config.toml
sed -i 's|^trust_hash *=.*|trust_hash = "'$TRUST_HASH'"|' $HOME/.babylond/config/config.toml

mv $HOME/.babylond/priv_validator_state.json.backup $HOME/.babylond/data/priv_validator_state.json

sudo systemctl restart babylond
sudo journalctl -u babylond -f --no-hostname -o cat
```

## Log Kontrol
```
sudo journalctl -u babylond -f -o cat
```
## Sync Durumu
```
babylond status 2>&1 | jq .SyncInfo
```
## Cüzdan Oluşturma
```
babylond keys add cüzdanadi
```
## BLS Key
> Cüzdan Adresi kısmını doldurmayı unutmayın.
```
babylond create-bls-key "CüzdanAdresi"
```
## Faucet: https://discord.gg/babylonchain

## Validator Oluşturma
```
babylond tx staking create-validator \
--amount=100ubbn \
--pubkey=$(babylond tendermint show-validator) \
--moniker=NODEADINIZ \
--chain-id=bbn-test1 \
--commission-rate=0.10 \
--commission-max-rate=0.20 \
--commission-max-change-rate=0.05 \
--min-self-delegation="1" \
--gas-prices=0.1ubbn \
--gas-adjustment=1.5 \
--gas=auto \
--from=CÜZDANADINIZ \
--yes
```

### Herkese Kolay Gelsin.
