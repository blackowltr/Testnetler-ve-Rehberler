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

