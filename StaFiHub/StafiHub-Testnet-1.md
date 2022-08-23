
# StaFiHub-Testnet-1

![logo_large f853ad2945c4125fc86316456d6a9969](https://user-images.githubusercontent.com/107190154/184559352-d5a95e26-e3fc-425a-bed0-c437aa6bdaa1.svg)

### Sistem Gereksinimleri

Minimum

|CPU | RAM  | Disk  | 
|----|------|----------|
|   2| 4GB  | 300GB    |

Önerilen

|CPU | RAM  | Disk  | 
|----|------|----------|
|   4| 8GB  | 600GB    |

## Scriptle Kurmak isterseniz bu komutla kurabilirsiniz. Dileyen Manuel de kurabilir.

```
wget -O kurulum.sh https://raw.githubusercontent.com/brsbrc/Testnetler-ve-Rehberler/main/StaFiHub/kurulum.sh && chmod +x kurulum.sh && ./kurulum.sh
```

## Hızlıca manuel kuruluma geçelim.

```
cd $HOME
sudo apt update
sudo apt install make clang pkg-config libssl-dev build-essential git jq ncdu bsdmainutils -y < "/dev/null"
```

## Go kurulumumuzu yapalım.

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

## Klonlama işlemini yapalım.

```
git clone --branch public-testnet https://github.com/stafihub/stafihub
```

## Yüklemeyi başlatalım

```
cd $HOME/stafihub && make install
```

## Genesis Dosyasını indirelim.
> `Nodeisminiz` yazan yere kendi node isminizi yazın.

```
stafihubd init nodeisminiz --chain-id stafihub-testnet-1
wget -O $HOME/.stafihub/config/genesis.json "https://raw.githubusercontent.com/stafihub/network/main/testnets/stafihub-testnet-1/genesis.json"
stafihubd tendermint unsafe-reset-all --home ~/.stafihub
```

## Ayarlarımızı yapalım.

```
sed -i.bak -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.01ufis\"/" $HOME/.stafihub/config/app.toml
sed -i '/\[grpc\]/{:a;n;/enabled/s/false/true/;Ta};/\[api\]/{:a;n;/enable/s/false/true/;Ta;}' $HOME/.stafihub/config/app.toml
peers="4e2441c0a4663141bb6b2d0ea4bc3284171994b6@46.38.241.169:26656,79ffbd983ab6d47c270444f517edd37049ae4937@23.88.114.52:26656"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.stafihub/config/config.toml
```

## Node'umuzu başlatalım.

```
stafihubd start
```

## Servis dosyamızı oluşturalım.

```
echo "[Unit]
Description=StaFiHub Node
After=network.target

[Service]
User=$USER
Type=simple
ExecStart=$(which stafihubd) start
Restart=on-failure
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target" > $HOME/stafihubd.service
sudo mv $HOME/stafihubd.service /etc/systemd/system
sudo tee <<EOF >/dev/null /etc/systemd/journald.conf
Storage=persistent
EOF
sudo systemctl restart systemd-journald
sudo systemctl daemon-reload
sudo systemctl enable stafihubd
sudo systemctl restart stafihubd
```

## Log kontrol

```
journalctl -u stafihubd -f
```

## Snapshot (Blok; 265013)
> Şart Değil.
```
sudo systemctl stop stafihubd
stafihubd tendermint unsafe-reset-all --home $HOME/.stafihub --keep-addr-book
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.stafihub/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.stafihub/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.stafihub/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.stafihub/config/app.toml
cd
rm -rf ~/.stafihub/data; \
wget -O - http://snap.stake-take.com:8000/stafi.tar.gz | tar xf -
mv $HOME/root/.stafihub/data $HOME/.stafihub
rm -rf $HOME/root
sudo systemctl restart stafihubd && journalctl -u stafihubd -f -o cat
```

## State Sync
> Şart Değil.
```
sudo systemctl stop stafihubd
stafihubd tendermint unsafe-reset-all --home $HOME/.stafihub
wget -O $HOME/.stafihub/config/addrbook.json "https://raw.githubusercontent.com/StakeTake/guidecosmos/main/stafihub/stafihub-testnet-1/addrbook.json"
SNAP_RPC="http://stafi.stake-take.com:16657"
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 1000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"| ; \
s|^(seeds[[:space:]]+=[[:space:]]+).*$|\1\"\"|" $HOME/.stafihub/config/config.toml
sudo systemctl restart stafihubd && journalctl -u stafihubd -f -o cat
```

## Yeni cüzdan için 

```
stafihubd keys add cüzdanismi
```

## Eski cüzdanınızı recover etmek için

```
stafihubd keys add cüzdanisminiz --recover
```

[Discorddan Test Tokeni Alalım.](https://discord.gg/khmGWESe)

## Validator olalım.
> Sync durumunuz `false` çıktısı verdiğinde, moniker ve from kısmını düzenleyip girin komutu.
```
stafihubd tx staking create-validator -y --amount=1000000ufis --pubkey=$(stafihubd tendermint show-validator) --moniker=nodeisminiz --commission-rate=0.10 --commission-max-rate=0.20 --commission-max-change-rate=0.01 --min-self-delegation=1 --from=cüzdanisminiz --chain-id=stafihub-testnet-1 --gas-prices=0.025ufis
```

## Unjail

```
stafihubd tx slashing unjail --from=YOUR_WALLET_NAME --chain-id=stafihub-testnet-1 --gas-prices=0.025ufis --keyring-backend file
```

[Explorer](https://testnet-explorer.stafihub.io/)

### Hepinize Kolay Gelsin.
