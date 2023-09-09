# Nibiru (nibiru-itn-2) Node Kurulum

![6565yy](https://github.com/brsbrc/Testnetler-ve-Rehberler/assets/107190154/f05367a7-b1db-4ba7-96a2-7f75ef02ba15)

### Sistem Gereksinimleri
> Burada yazan gereksinimler önerilen gereksinimlerdir. İlla 1000GB alana sahip bir sunucu kullanmanız gerekmiyor. Rehberde kurulum yaparken indexer kapatma ve Pruning ayarlarını da yapmış olacaksınız. Bu sayede yüksek disk kapasitesi olmayan bir sunucuya da kurabilirsiniz. Örn: 400GB-600GB gibi.

|CPU | RAM  | Disk  | 
|----|------|----------|
|   4| 16GB  | 1TB    |

## [Resmi Doküman](https://nibiru.fi/docs/run-nodes/testnet/)
## [Nibiru Discord](https://discord.gg/nibirufi)
## [Nibiru Twitter](https://twitter.com/NibiruChain)
## [BlackOwl Twitter](https://twitter.com/brsbtc)

## Tarayıcı: 

https://explorer.nibiru.fi/

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------

## Güncelleme ve kütüphane kurulumunu yapıyoruz.
```
sudo apt update && sudo apt upgrade -y && sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential bsdmainutils git make ncdu gcc git jq chrony liblz4-tool -y
```
## Go kurulumu
```
ver="1.19.2"
cd $HOME
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile
source ~/.bash_profile
go version
```
## Nibid kurulumu
```
curl -s https://get.nibiru.fi/@v0.21.9! | bash
```
## Versiyon kontrol edelim
> Versiyon 0.21.9 olmalı
```
nibid version
```
## Initialize işlemi
> NODEADINIZ yazan yere isminizi yazın.
```
nibid init NODEADINIZ --chain-id=nibiru-itn-2 --home $HOME/.nibid
```
## Genesis dosyası
```
NETWORK=nibiru-itn-2
curl -s https://networks.itn2.nibiru.fi/$NETWORK/genesis > $HOME/.nibid/config/genesis.json
curl -s https://rpc.itn-2.nibiru.fi/genesis | jq -r .result.genesis > $HOME/.nibid/config/genesis.json
```
## Seed ve Peers ayarı
```
NETWORK=nibiru-itn-2
sed -i 's|seeds =.*|seeds = "'$(curl -s https://networks.itn2.nibiru.fi/$NETWORK/seeds)'"|g' $HOME/.nibid/config/config.toml
```

# Minimum gas price ayarı ve prometheus ayarı
```
sed -i 's/minimum-gas-prices =.*/minimum-gas-prices = "0.025unibi"/g' $HOME/.nibid/config/app.toml
sed -i 's|^prometheus *=.*|prometheus = true|' $HOME/.nibid/config/config.toml
```
## İndexer Kapatma (şart değil, kullanım amacımız disk kullanımını azaltmak için.)
```
indexer="null"
sed -i -e "s/^indexer *=.*/indexer = \"$indexer\"/" $HOME/.nibid/config/config.toml
```
## Pruning ayarları(şart değil, kullanım amacımız disk kullanımını azaltmak için.)
```
sed -i 's|^pruning *=.*|pruning = "custom"|g' $HOME/.nibid/config/app.toml
sed -i 's|^pruning-keep-recent  *=.*|pruning-keep-recent = "100"|g' $HOME/.nibid/config/app.toml
sed -i 's|^pruning-interval *=.*|pruning-interval = "10"|g' $HOME/.nibid/config/app.toml
sed -i 's|^snapshot-interval *=.*|snapshot-interval = 0|g' $HOME/.nibid/config/app.toml
```
## unsafe-reset
``` 
nibid tendermint unsafe-reset-all --home $HOME/.nibid --keep-addr-book
```

## Servis dosyamızı oluşturup başlatalım.
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
```

```
sudo systemctl daemon-reload
sudo systemctl enable nibid
sudo systemctl start nibid
```

## Log Kontrol
```
sudo journalctl -u nibid -f -o cat
```
## Sync Durumu
```
nibid status 2>&1 | jq .SyncInfo
```
## Cüzdan Oluşturma

### KEPLR'a yeni test ağını eklemek için önce eski nibiru-itn-1 ağını kaldırın ve https://app.nibiru.fi/ buraya bağlanarak yeni test ağını ekleyin. Siteye bağlandığınızda oto olarak ekleniyor.

## Cüzdanınızı import edin
```
nibid keys add CUZDAN --recover
```

## Faucet ---> https://discord.gg/nibirufi , https://app.nibiru.fi/faucet

## Validator Oluşturma
```
nibid tx staking create-validator \
--amount 10000000unibi \
--commission-max-change-rate "0.1" \
--commission-max-rate "0.20" \
--commission-rate "0.1" \
--min-self-delegation "1" \
--pubkey=$(nibid tendermint show-validator) \
--moniker NODEADINIZ \
--chain-id nibiru-itn-2 \
--gas-prices 0.025unibi \
--from CÜZDANADINIZ
```

## Bu https://app.nibiru.fi/ siteden kendinize ya da diğer validatorlere stake edebilir, diğer işlemleri gerçekleştirebilirsiniz.

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------

# Faydalı Komutlar

## Kendinize ya da başka validatore delege etme
```
nibid tx staking delegate VALOPERADRESİNİZİYAZIN 1000000unibi --from CÜZDANADINIZIYAZIN --chain-id nibiru-itn-2 --gas-adjustment 1.4 --gas auto --gas-prices 0.025unibi -y
```
## Redelege
```
nibid tx staking redelegate gönderenvaloper alıcıvaloperadres 10000000unibi --from CÜZDANADINIZIYAZIN --chain-id nibiru-itn-2 --gas-adjustment 1.4 --gas auto --gas-prices 0.025unibi -y
```
## Cüzdandan cüzdana transfer
```
nibid tx bank send GÖNDERENADRES ALICIADRES 10000000unibi --from CÜZDANADINIZIYAZIN --chain-id nibiru-itn-2 --gas-adjustment 1.4 --gas auto --gas-prices 0.025unibi -y
```
## Biriken Ödülleri toplama
```
nibid tx distribution withdraw-all-rewards --from CÜZDANADINIZIYAZIN --chain-id nibiru-itn-2 --gas-adjustment 1.4 --gas auto --gas-prices 0.025unibi -y
```
## Unbound 
```
nibid tx staking unbond VALOPERADRESİNİZ 1000000unibi --from CÜZDANADINIZ --chain-id nibiru-itn-2 --gas-prices 0.1unibi --gas-adjustment 1.5 --gas auto -y 
```
## Oy kullanma 
```
nibid tx gov vote 1 yes --from CÜZDANADINIZIYAZIN --chain-id nibiru-itn-2 --gas-adjustment 1.4 --gas auto --gas-prices 0.025unibi -y
```
## Unjail 
```
nibid tx slashing unjail --from CÜZDANADINIZIYAZIN --chain-id nibiru-itn-2 --gas-adjustment 1.4 --gas auto --gas-prices 0.025unibi -y
```
## Validator Düzenleme
```
nibid tx staking edit-validator \
--new-moniker YENİADINIZIYAZIN \
--identity KEYBASE.IO ID'NİZ \
--details "AÇIKLAMA" \
--website "WEBSİTEADRESNİZ" \
--chain-id nibiru-itn-2 \
--gas-prices 0.025unibi \
--from CÜZDANADINIZ
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

### Herkese Kolay Gelsin.

