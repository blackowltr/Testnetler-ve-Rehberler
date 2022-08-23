# Source 

![1661002815482](https://user-images.githubusercontent.com/107190154/185748794-2c2616c5-ae6d-4123-b03b-5b6caba73e44.png)

## Gereksinimler

|      CPU        |   RAM    |  Disk    | 
|-----------------|----------|----------|
|1.4 GHz amd64 CPU|   4GB    | 250GB    |


### Kuruluma Geçelim.

## Sistemi Kuruyoruz.
```
sudo apt update && sudo apt upgrade -y
```
## Kütüphane kurulumunu yapıyoruz.
```
sudo apt install make clang pkg-config libssl-dev build-essential git jq ncdu bsdmainutils -y < "/dev/null"
```
## Go Kurulumu
```
cd $HOME
wget -O go1.18.2.linux-amd64.tar.gz https://go.dev/dl/go1.18.2.linux-amd64.tar.gz
rm -rf /usr/local/go && tar -C /usr/local -xzf go1.18.2.linux-amd64.tar.gz && rm go1.18.2.linux-amd64.tar.gz
echo 'export GOROOT=/usr/local/go' >> $HOME/.bashrc
echo 'export GOPATH=$HOME/go' >> $HOME/.bashrc
echo 'export GO111MODULE=on' >> $HOME/.bashrc
echo 'export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin' >> $HOME/.bashrc && . $HOME/.bashrc
go version
```
## Klonlama Yapıyoruz.
```
git clone -b testnet https://github.com/Source-Protocol-Cosmos/source.git
```
## Yüklemeyi Başlatıyoruz.
```
cd ~/source
make install
```
## Nodeismi kısmına isminizi yazın.
```
sourced init nodeisminiz --chain-id SOURCECHAIN-TESTNET
```
## Genesis Dosyasını İndiriyoruz.
```
curl -s  https://raw.githubusercontent.com/Source-Protocol-Cosmos/testnets/master/sourcechain-testnet/genesis.json > ~/.source/config/genesis.json
```
## Addrbook İndiriyoruz.
```
wget -O $HOME/.source/config/addrbook.json "https://raw.githubusercontent.com/mmc6185/node-testnets/main/source-protocol/addrbook.json"
```
## Seed Ekliyoruz.
```
SEEDS="6ca675f9d949d5c9afc8849adf7b39bc7fccf74f@164.92.98.17:26656"
PEERS=""
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.source/config/config.toml
```
## Peer Ekliyoruz.
```
sed -i.bak 's/persistent_peers =.*/persistent_peers = "6ca675f9d949d5c9afc8849adf7b39bc7fccf74f@164.92.98.17:26656"/' $HOME/.source/config/config.toml
```
## Gas Ayarımızı Yapıyoruz.
```
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.00125usource\"/" $HOME/.source/config/app.toml
```
## Pruning ((Disk kullanımını düşürür - cpu ve ram kullanımını arttırır.)
> Kullanmak Şart Değil.
```
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="50"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.source/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.source/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.source/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.source/config/app.toml
```
## İndexer Kapatma (Disk kullanımını düşürür.)
> Şart Değil.
```
indexer="null"
sed -i -e "s/^indexer *=.*/indexer = \"$indexer\"/" $HOME/.source/config/config.toml
```
## Servis Dosyasını Oluşturuyoruz.
```
echo "[Unit]
Description=Source-protocol Node
After=network.target

[Service]
User=$USER
Type=simple
ExecStart=$(which sourced) start
Restart=on-failure
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target" > $HOME/sourced.service
sudo mv $HOME/sourced.service /etc/systemd/system
sudo tee <<EOF >/dev/null /etc/systemd/journald.conf
Storage=persistent
EOF
```

## Tekrar Başlatıyoruz, Sistemizi.
```
systemctl restart systemd-journald
systemctl daemon-reload
systemctl enable sourced
systemctl restart sourced
```

## Log Kontrol
```
journalctl -fu sourced -o cat
```

## Sync Durumu
```
sourced status 2>&1 | jq .SyncInfo
```

## Snapshot (Blok;  1847709 )
> Şart Değil.
```
sudo systemctl stop sourced
sourced unsafe-reset-all
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.source/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.source/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.source/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.source/config/app.toml
wget -O $HOME/.source/config/addrbook.json "https://raw.githubusercontent.com/StakeTake/guidecosmos/main/source/sourcechain-testnet/addrbook.json"
cd
rm -rf ~/.source/data; \
wget -O - http://snap.stake-take.com:8000/source.tar.gz | tar xf -
mv $HOME/root/.source/data $HOME/.source
rm -rf $HOME/root
sudo systemctl restart sourced && journalctl -u sourced -f -o cat
```

## State Sync
> Şart Değil.
```
sudo systemctl stop sourced
sourced unsafe-reset-all --home $HOME/.source
SEEDS=""; \
PEERS="9d16b552697cdce3c8b4f23de53708533d99bc59@165.232.144.133:26656,d565dd0cb92fa4b830662eb8babe1dcdc340c321@44.234.26.62:26656,2dbc3e6d52e5eb9357aec5cf493718f6078ffaad@144.76.224.246:36656"; \
sed -i.bak -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.source/config/config.toml
wget -O $HOME/.source/config/addrbook.json "https://raw.githubusercontent.com/StakeTake/guidecosmos/main/source/sourcechain-testnet/addrbook.json"
SNAP_RPC="https://testnet.sourceprotocol.io:26657"
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)
echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"| ; \
s|^(seeds[[:space:]]+=[[:space:]]+).*$|\1\"\"|" $HOME/.source/config/config.toml
sudo systemctl restart sourced && journalctl -u sourced -f -o cat
```

## Discorddan Token Alalım.

> https://discord.gg/r8aPh4hR

## Cüzdan Oluşturma
```
sourced keys add cüzdanismi
```

## Cüzdan Recover
```
sourced keys add cüzdanismi --recover
```

## Validator Oluşturma
```
sourced tx staking create-validator \
--amount=950000usource \
--pubkey=$(sourced tendermint show-validator) \
--moniker=nodeismi \
--chain-id=sourcechain-testnet \
--commission-rate="0.10" \
--commission-max-rate="0.20" \
--commission-max-change-rate="0.1" \
--min-self-delegation="1" \
--from=cüzdanismi \
--fees=5000usource \
-y
```

## Node Silme
```
sudo systemctl stop sourced
sudo systemctl disable sourced
sudo rm /etc/systemd/system/source* -rf
sudo rm $(which sourced) -rf
sudo rm $HOME/.source* -rf
sudo rm $HOME/source -rf
sed -i '/SOURCE_/d' ~/.bash_profile
```

### Explorer

> https://explorer.testnet.sourceprotocol.io/source

### Kolay Gelsin.
