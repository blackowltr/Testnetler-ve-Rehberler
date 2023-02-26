# Nibiru Node Kurulum

![ghgf](https://user-images.githubusercontent.com/107190154/221386540-dab23489-6e59-4df3-b818-75e1c16130d1.png)

## Güncelleme ve kütüphane kurulumunu yapıyoruz.
```
sudo apt update && sudo apt upgrade -y && sudo apt install curl build-essential git wget jq make gcc tmux chrony -y
```

## Go Kurulumu
```
cd $HOME
VER="1.19.3"
wget "https://golang.org/dl/go$VER.linux-amd64.tar.gz"
sudo tar -C /usr/local -xzf "go$VER.linux-amd64.tar.gz"
rm -rf  "go$VER.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> $HOME/.bash_profile
source $HOME/.bash_profile
go version
```
## Binary Dosyamızı İndirelim
```
cd $HOME && rm -rf nibiru
git clone https://github.com/NibiruChain/nibiru
cd nibiru
git checkout v0.16.3
make install
```

## Initialize işlemi
```
nibid init Node Adınız --chain-id nibiru-testnet-2
nibid config chain-id nibiru-testnet-2
```

## Genesis ve addrbook dosyasını indiriyoruz
```
curl -s https://rpc.testnet-1.nibiru.fi/genesis | jq -r .result.genesis > $HOME/.nibid/config/genesis.json
```

## SEED ve PEERS ayarlarını yapıyoruz.
```
SEEDS=""
PEERS="5d9432668a2acd0587ecb77b5728177d216c02bc@65.109.93.152:36316"
sed -i.bak -e "s/^seeds *=.*/seeds = \"$seeds\"/; s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" ~/.nibid/config/config.toml
```

## Pruning ayarlıyoruz. (Şart değil)
```
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="50"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.nibid/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.nibid/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.nibid/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.nibid/config/app.toml
```

# Minimum gas price ayarı
```
sed -i 's/minimum-gas-prices = ""/minimum-gas-prices = "0.25unibi"/g' ~/.nibid/config/app.toml
```

# Prometheus ayarı
```
sed -i -e "s/prometheus = false/prometheus = true/" $HOME/.nibid/config/config.toml
```

# reset
```
nibid tendermint unsafe-reset-all --home $HOME/.nibid
```

## Serviss dosyamızı oluşturup başlatalım.
```
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

sudo systemctl daemon-reload
sudo systemctl enable nibid
sudo systemctl restart nibid && journalctl -fu nibid -o cat
```
## Log Kontrol
```
sudo journalctl -u nibid -f -o cat
```
## Sync Durumu
```
nibid status 2>&1 | jq .SyncInfo
```
## State Sync
```
SNAP_RPC=65.108.199.120:46657 && \
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash) && \
echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH
sudo systemctl stop nibid && nibid tendermint unsafe-reset-all --home $HOME/.nibid --keep-addr-book
```
```
peers="ddb452dcad628cc17f519467810a2957518ac7d7@65.108.199.120:46656"
sed -i.bak -e  "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.nibid/config/config.toml
```
```
sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"| ; \
s|^(seeds[[:space:]]+=[[:space:]]+).*$|\1\"\"|" $HOME/.nibid/config/config.toml
```
```
curl -o - -L https://anode.team/Nibiru/test/anode.team_nibiru_wasm.tar.lz4 | lz4 -c -d - | tar -x -C $HOME/.nibid/data
```
```
sudo systemctl restart nibid && journalctl -fu nibid -o cat
```
## Cüzdan Oluşturma
```
nibid keys add CÜZDAN
```
## Cüzdan Kurtarma
```
nibid keys add CÜZDAN --recover
```
## Validator Oluşturma
```
nibid tx staking create-validator \
--amount=10000000unibi \
--pubkey=$(nibid tendermint show-validator) \
--moniker=NODEADINIZ \
--chain-id="nibiru-testnet-2" \
--commission-rate="0.10" \
--commission-max-rate="0.20" \
--commission-max-change-rate="0.01" \
--min-self-delegation="1" \
--fees 5000unibi \
--from=CÜZDANADINIZ
```

## Validator Düzenleme
```
nibid tx staking edit-validator \
--moniker=NODEADINIZ \
--identity=<KEYBASE ID> \
--website="<WEBSİTENİZ>" \
--details="<AÇIKLAMA>" \
--chain-id="nibiru-testnet-2" \
--from=CÜZDANADINIZ
```

## Node Silme Komutları
```
sudo systemctl stop nibid
sudo systemctl disable nibid
sudo rm /etc/systemd/system/nibi* -rf
sudo rm $(which nibid) -rf
sudo rm $HOME/.nibid* -rf
sudo rm $HOME/nibiru -rf
sed -i '/NIBIRU_/d' ~/.bash_profile
```
