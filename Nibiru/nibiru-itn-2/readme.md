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
ver="1.20.3"
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> $HOME/.bash_profile
source $HOME/.bash_profile
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
```

## Seed ve Peers ayarı
```
NETWORK=nibiru-itn-2
sed -i 's|seeds =.*|seeds = "'$(curl -s https://networks.itn2.nibiru.fi/$NETWORK/seeds)'"|g' $HOME/.nibid/config/config.toml
peers="8e0e6c1583153282d07511d3ea13e53f6ce77b51@162.55.234.70:55356,111dd6b7ac9d0f80d7a04ce212267ce95cb913e9@195.201.76.69:26656,4a81486786a7c744691dc500360efcdaf22f0840@141.94.174.11:26656,d5519e378247dfb61dfe90652d1fe3e2b3005a5b@65.109.68.190:13956,1e92b8c92b1a49c0d85f3c0f5ca958242e9a3c4b@75.119.146.247:26656,081ff903784a3f1b69522d6167c998c88c91ce61@65.108.13.154:27656,7a0d35b3cb1eda647d57c699c3e847d4e41d890d@65.108.8.28:36656,41bb02a3e2b60761f07ddcc7138bcf17b6a1eda9@65.109.90.171:27656,e36ada54e3d1e7c05c1c3b585b4235134aa185ef@65.108.206.118:60656,9a3d3357c38dc553e0fd2e89f9d2213016751fb5@176.9.110.12:36656,413a45800222a978bd01077e780a5861970c8306@185.75.181.19:26656,2cbae8362c1953cbe7badac73dd547ae0854cb63@104.199.24.9:26656,e8e173564d8b7383d6306e1f1d0ed01e2fc4d507@34.77.52.8:26656,d092162ed9c61c9921842ff1fb221168c68d4872@65.109.65.248:27656,c060180df8c01546c66d21ee307b09f700780f65@34.34.137.125:26656,02ddb201a1ceca73e43647d53a82a0342a6532ab@148.251.90.138:11656,96e26da24f2b70b1314301263477e1a3c8a159be@65.109.26.21:11656,8d2735274fddfd6f38585f94b748a91280086def@62.171.167.76:26656,c068c45ef902b35dd9ea4f6b82405e6ab2dfc730@65.109.92.241:11036,0269836fc9a3db6b34828c57d9130b62cbbf59f2@134.249.103.215:26656,faf332f0f0e56398314935a1b72de2e0a70ddd82@91.107.214.162:26656,7d443bfaec2780c72319ea7de03c09e0a9c9fbfc@78.46.103.246:26656"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$peers\"|" $HOME/.nibid/config/config.toml
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

## Pruning ayarları (şart değil, kullanım amacımız disk kullanımını azaltmak için.)
```
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.nibid/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.nibid/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.nibid/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.nibid/config/app.toml
sed -i "s/snapshot-interval *=.*/snapshot-interval = 0/g" $HOME/.nibid/config/app.toml
```

## unsafe-reset
``` 
nibid tendermint unsafe-reset-all --home $HOME/.nibid --keep-addr-book
```

## Servis dosyamızı oluşturup başlatalım.
```
tee /etc/systemd/system/nibid.service > /dev/null <<EOF
[Unit]
Description=nibid
After=network-online.target

[Service]
User=$USER
ExecStart=$(which nibid) start
Restart=on-failure
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

