# Rebus

![Rebus](https://user-images.githubusercontent.com/107190154/185757773-97ffec45-7317-43b5-9a43-9695e6e47ff7.png)

## Kuruluma Geçelim.

```
wget -O rebus.sh https://raw.githubusercontent.com/brsbrc/Testnetler-ve-Rehberler/main/Rebus/rebus.sh && chmod +x rebus.sh && ./rebus.sh
```

## Snapshot (Blok Yüksekliği ---> 240483) 
```
sudo systemctl stop rebusd
rebusd tendermint unsafe-reset-all --home $HOME/.rebusd --keep-addr-book
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.rebusd/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.rebusd/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.rebusd/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.rebusd/config/app.toml
cd
rm -rf ~/.rebusd/data; \
wget -O - http://snap.stake-take.com:8000/rebus.tar.gz | tar xf -
mv $HOME/root/.rebusd/data $HOME/.rebusd
rm -rf $HOME/root
sudo systemctl restart rebusd && journalctl -u rebusd -f -o cat
```

## State Sync
```
sudo systemctl stop rebusd
rebusd tendermint unsafe-reset-all --home ~/.rebusd
SEEDS="a6d710cd9baac9e95a55525d548850c91f140cd9@3.211.101.169:26656,c296ee829f137cfe020ff293b6fc7d7c3f5eeead@54.157.52.47:26656"; \
PEERS=""; \
sed -i.bak -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.rebusd/config/config.toml
wget -O $HOME/.rebusd/config/addrbook.json "https://raw.githubusercontent.com/StakeTake/guidecosmos/main/rebus/reb_3333-1/addrbook.json"
SNAP_RPC="https://rpc-t.rebus.nodestake.top:443"
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)
echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"| ; \
s|^(seeds[[:space:]]+=[[:space:]]+).*$|\1\"\"|" $HOME/.rebusd/config/config.toml
sudo systemctl restart rebusd && journalctl -u rebusd -f -o cat
```

## Cüzdan Oluşturma

```
rebusd keys add cüzdanismi
```

## Cüzdan Recover

```
rebusd keys add cüzdanismi --recover
```

## Discorda girip faucetten token alalım

> https://discord.gg/yrQ2eZBs

```
$request cüzdanadresi
```

## Validator Olalım

> Sync durumunuz false olmalı, cüzdanınızda token olmalı.

```
rebusd tx staking create-validator \
	--amount 10000000arebus \
	--from cüzdanismi \
	--commission-max-change-rate "0.01" \
	--commission-max-rate "0.2" \
	--commission-rate "0.07" \
	--min-self-delegation "1" \
	--pubkey  $(rebusd tendermint show-validator) \
	--moniker nodeismi \
	--chain-id reb_3333-1
```

## Log Kontrol


```
journalctl -fu rebusd -o cat
```

## Sync Durum Kontrol

```
rebusd status 2>&1 | jq .SyncInfo
```

## Unjail komutları

```
rebusd tx slashing unjail \
  --broadcast-mode=block \
  --from=cüzdanismi \
  --chain-id=reb_3333-1 \
  --gas=auto
```

## Node Silme Komutları

```
sudo systemctl stop rebusd
sudo systemctl disable rebusd
sudo rm /etc/systemd/system/rebus* -rf
sudo rm $(which rebusd) -rf
sudo rm $HOME/.rebusd* -rf
sudo rm $HOME/rebus -rf
sed -i '/REBUS_/d' ~/.bash_profile
```

### Hepinize Kolay Gelsin.

