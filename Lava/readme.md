# Lava Node Kurulumu

![dcad](https://user-images.githubusercontent.com/107190154/221439481-2fa90550-145b-4257-89df-eddece2a05a4.png)

### Sistem Gereksinimleri 

|CPU | RAM  | Disk  | 
|----|------|----------|
|   4| 8GB  | 160GB    |

## Script "NODEJUMPER" tarafından hazırlanmıştır. Kendisine emeklerinden ötürü teşekkür ederim.

## Birinci komutla oto kurulumu başlatın ardından ikinci komutu yazın.
```
source <(curl -s https://raw.githubusercontent.com/brsbrc/Testnetler-ve-Rehberler/main/Lava/lava.sh)
```
```
snap=$(curl -s http://94.250.203.6:90 | egrep -o ">lavad-snap*.*tar" | tr -d ">")
mv $HOME/.lava/data/priv_validator_state.json $HOME
rm -rf  $HOME/.lava/data
wget -P $HOME http://94.250.203.6:90/${snap}
tar xf $HOME/${snap} -C $HOME/.lava
rm $HOME/${snap}
mv $HOME/priv_validator_state.json $HOME/.lava/data
wget -qO $HOME/.lava/config/addrbook.json http://94.250.203.6:90/lava-addrbook.json
sudo systemctl restart lavad
sudo journalctl -u lavad -f -o cat
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
