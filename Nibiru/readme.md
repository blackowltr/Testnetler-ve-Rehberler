# Nibiru Node Kurulum

![ghgf](https://user-images.githubusercontent.com/107190154/221386540-dab23489-6e59-4df3-b818-75e1c16130d1.png)

## Güncelleme ve kütüphane kurulumunu yapıyoruz.
```
sudo apt update && sudo apt upgrade -y && sudo apt install curl build-essential git wget jq make gcc tmux chrony -y
```

## Go Kurulumu
```
ver="1.18.2"
cd $HOME
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile
source ~/.bash_profile
```
## Binary Dosyamızı İndirelim
```
cd $HOME && rm -rf nibiru
git clone https://github.com/NibiruChain/nibiru.git
cd nibiru
git checkout v0.15.0
make install
```

## Initialize işlemi
```
nibid init NODEADINIZ --chain-id nibiru-testnet-1
```

## Genesis ve addrbook dosyasını indiriyoruz
```
curl -s https://rpc.testnet-1.nibiru.fi/genesis | jq -r .result.genesis > $HOME/.nibid/config/genesis.json
```

## SEED ve PEERS ayarlarını yapıyoruz.
```
SEEDS=""
PEERS="37713248f21c37a2f022fbbb7228f02862224190@35.243.130.198:26656,ff59bff2d8b8fb6114191af7063e92a9dd637bd9@35.185.114.96:26656,cb431d789fe4c3f94873b0769cb4fce5143daf97@35.227.113.63:26656"
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.nibid/config/config.toml
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
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0unibi\"/" $HOME/.nibid/config/app.toml
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
Description=nibi
After=network-online.target
[Service]
User=$USER
ExecStart=$(which nibid) start --home $HOME/.nibid
Restart=on-failure
RestartSec=3
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable nibid
sudo systemctl restart nibid
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
SNAP_RPC="http://rpc.nibiru.ppnv.space:10657"
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height)
BLOCK_HEIGHT=$((LATEST_HEIGHT - 1000))
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)
echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH
#if there are no errors, then continue
sudo systemctl stop nibid
nibid tendermint unsafe-reset-all --home $HOME/.nibid --keep-addr-book
peers="ff597c3eea5fe832825586cce4ed00cb7798d4b5@rpc.nibiru.ppnv.space:10656"
sed -i 's|^persistent_peers *=.*|persistent_peers = "'$peers'"|' $HOME/.nibid/config/config.toml
sed -i -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" $HOME/.nibid/config/config.toml
sudo systemctl restart nibid
sudo journalctl -u nibid -f --no-hostname -o cat
```
```
CONFIG_TOML="$HOME/.nibid/config/config.toml"
sed -i 's/timeout_propose =.*/timeout_propose = "100ms"/g' $CONFIG_TOML
sed -i 's/timeout_propose_delta =.*/timeout_propose_delta = "500ms"/g' $CONFIG_TOML
sed -i 's/timeout_prevote =.*/timeout_prevote = "100ms"/g' $CONFIG_TOML
sed -i 's/timeout_prevote_delta =.*/timeout_prevote_delta = "500ms"/g' $CONFIG_TOML
sed -i 's/timeout_precommit =.*/timeout_precommit = "100ms"/g' $CONFIG_TOML
sed -i 's/timeout_precommit_delta =.*/timeout_precommit_delta = "500ms"/g' $CONFIG_TOML
sed -i 's/timeout_commit =.*/timeout_commit = "1s"/g' $CONFIG_TOML
sed -i 's/skip_timeout_commit =.*/skip_timeout_commit = false/g' $CONFIG_TOML
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
--amount 2000000unibi \
--from CÜZDANADINIZ \
--commission-max-change-rate "0.01" \
--commission-max-rate "0.2" \
--commission-rate "0.07" \
--min-self-delegation "1" \
--pubkey  $(nibid tendermint show-validator) \
--moniker NODEADINIZ \
--chain-id nibiru-testnet-1
```

## Validator Düzenleme
```
nibid tx staking edit-validator \
--moniker=NODEADINIZ \
--identity=<KEYBASE ID> \
--website="<WEBSİTENİZ>" \
--details="<AÇIKLAMA>" \
--chain-id=nibiru-testnet-1 \
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
