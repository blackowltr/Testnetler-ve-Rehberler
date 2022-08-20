# Merhabalar, bugün sizlerle rebus testnetine katılacağız.

![Rebus](https://user-images.githubusercontent.com/107190154/185757773-97ffec45-7317-43b5-9a43-9695e6e47ff7.png)

## Kuruluma Geçelim.

```
wget -O rebus.sh https://raw.githubusercontent.com/brsbrc/Testnetler-ve-Rehberler/main/Rebus/rebus.sh && chmod +x rebus.sh && ./rebus.sh
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

