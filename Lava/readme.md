# Lava Node Kurulumu

![dcad](https://user-images.githubusercontent.com/107190154/221439481-2fa90550-145b-4257-89df-eddece2a05a4.png)

### Sistem Gereksinimleri 

|CPU | RAM  | Disk  | 
|----|------|----------|
|   4| 8GB  | 200B    |

### Explorer: https://lava.explorers.guru/

## Aşağıdaki komutla oto kurulumu başlatın.
```
source <(curl -s https://raw.githubusercontent.com/brsbrc/Testnetler-ve-Rehberler/main/Lava/lava.sh)
```

## Snapshot
```
sudo systemctl stop lavad

cp $HOME/.lava/data/priv_validator_state.json $HOME/.lava/priv_validator_state.json.backup 

lavad tendermint unsafe-reset-all --home $HOME/.lava --keep-addr-book 
curl https://snapshots1-testnet.nodejumper.io/lava-testnet/lava-testnet-1_2023-04-04.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.lava

mv $HOME/.lava/priv_validator_state.json.backup $HOME/.lava/data/priv_validator_state.json 

sudo systemctl restart lavad
sudo journalctl -u lavad -f --no-hostname -o cat
```
## Log Kontrol
```
journalctl -fu lavad -o cat
```
## Sync Kontrol
```
lavad status 2>&1 | jq .SyncInfo
```
## Cüzdan Oluşturma
```
lavad keys add cüzdanadı
```
# Validator Oluşturma
```
lavad tx staking create-validator \
--amount=9000000ulava \
--pubkey=$(lavad tendermint show-validator) \
--moniker="NodeAdınız" \
--chain-id=lava-testnet-1 \
--commission-rate=0.1 \
--commission-max-rate=0.2 \
--commission-max-change-rate=0.05 \
--min-self-delegation=1 \
--fees=10000ulava \
--from=CüzdanAdınız \
-y
```

## Node Silme
```
sudo systemctl stop lavad
sudo systemctl disable lavad
sudo rm /etc/systemd/system/lavad.service
sudo systemctl daemon-reload
rm -rf $HOME/.lava
rm -rf $HOME/lava
sudo rm $(which lavad) 
```

## Herkese Kolay Gelsin.
