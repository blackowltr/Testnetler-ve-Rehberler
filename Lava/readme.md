# Lava Node Kurulumu

![dcad](https://user-images.githubusercontent.com/107190154/221439481-2fa90550-145b-4257-89df-eddece2a05a4.png)

### Sistem Gereksinimleri 

|CPU | RAM  | Disk  | 
|----|------|----------|
|   4| 8GB  | 160GB    |

## Aşağıdaki komutla oto kurulumu başlatın.
```
source <(curl -s https://raw.githubusercontent.com/brsbrc/Testnetler-ve-Rehberler/main/Lava/lava.sh)
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
rm /etc/systemd/system/lavad.service
sudo systemctl daemon-reload
rm -rf $HOME/go/bin/lavad
rm -rf lavad.sh
cd $HOME
rm -rf lava
rm -rf .lava
rm -rf $(which lavad)
rm -rf /usr/bin/lavad
rm -rf /usr/local/bin/lavad
rm -rf go
rm -rf .bash_profile
rm -rf .profile
```

## Herkese Kolay Gelsin.
