# Nibiru (nibiru-itn-1) Node Kurulum

![ghgf](https://user-images.githubusercontent.com/107190154/221386540-dab23489-6e59-4df3-b818-75e1c16130d1.png)

### Sistem Gereksinimleri
> Burada yazan gereksinimler önerilen gereksinimlerdir. İlla 1000GB alana sahip bir sunucu kullanmanız gerekmiyor. Rehberde kurulum yaparken indexer kapatma ve Pruning ayarlarını da yapmış olacaksınız. Bu sayede yüksek disk kapasitesi olmayan bir sunucuya da kurabilirsiniz. Örn: 400GB-600GB gibi.

|CPU | RAM  | Disk  | 
|----|------|----------|
|   4| 16GB  | 1000GB    |

## [Resmi Doküman](https://nibiru.fi/docs/run-nodes/testnet/)
## [Nibiru Discord](https://discord.gg/nibiru)
## [Nibiru Twitter](https://twitter.com/NibiruChain)
## [BlackOwl Twitter](https://twitter.com/brsbtc)

## Tarayıcı: 

https://nibiru.explorers.guru/

https://explorer.ppnv.space/nibiru

## Rehberde hata ya da eksik varsa PR atın.

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------

# Kurulum

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
curl -s https://get.nibiru.fi/@v0.19.2! | bash
```
## Versiyon kontrol edelim
> Versiyon 0.19.2 olmalı
```
nibid version
```
## Initialize işlemi
> NODEADINIZ yazan yere isminizi yazın.
```
nibid init NODEADINIZ --chain-id=nibiru-itn-1 --home $HOME/.nibid
```
## Genesis dosyası
```
NETWORK=nibiru-itn-1
curl -s https://networks.itn.nibiru.fi/$NETWORK/genesis > $HOME/.nibid/config/genesis.json
curl -s https://rpc.itn-1.nibiru.fi/genesis | jq -r .result.genesis > $HOME/.nibid/config/genesis.json
```
## Seed ayarı
```
NETWORK=nibiru-itn-1
sed -i 's|seeds =.*|seeds = "'$(curl -s https://networks.itn.nibiru.fi/$NETWORK/seeds)'"|g' $HOME/.nibid/config/config.toml
```
# Minimum gas price ayarı
```
sed -i 's/minimum-gas-prices =.*/minimum-gas-prices = "0.025unibi"/g' $HOME/.nibid/config/app.toml
```
## İndexer Kapatma (şart değil)
```
indexer="null"
sed -i -e "s/^indexer *=.*/indexer = \"$indexer\"/" $HOME/.nibid/config/config.toml
```
## Pruning ayarları(şart değil)
```
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.nibid/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.nibid/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.nibid/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.nibid/config/app.toml

sed -i 's/minimum-gas-prices =.*/minimum-gas-prices = "0.025unibi"/g' $HOME/.nibid/config/app.toml
```

## Ağ ile daha hızlı senkron olmak için State Sync parametrelerini ayarlayın (isteğe bağlıdır ancak önerilir)
```
NETWORK=nibiru-itn-1
sed -i 's|enable =.*|enable = true|g' $HOME/.nibid/config/config.toml
sed -i 's|rpc_servers =.*|rpc_servers = "'$(curl -s https://networks.itn.nibiru.fi/$NETWORK/rpc_servers)'"|g' $HOME/.nibid/config/config.toml
sed -i 's|trust_height =.*|trust_height = "'$(curl -s https://networks.itn.nibiru.fi/$NETWORK/trust_height)'"|g' $HOME/.nibid/config/config.toml
sed -i 's|trust_hash =.*|trust_hash = "'$(curl -s https://networks.itn.nibiru.fi/$NETWORK/trust_hash)'"|g' $HOME/.nibid/config/config.toml
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

sudo systemctl daemon-reload
sudo systemctl enable nibid
sudo systemctl restart nibid && journalctl -fu nibid -o cat
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

### KEPLR'a yeni test ağını eklemek için önce eski nibiru-testnet-2 ağını kaldırın ve https://app.nibiru.fi/ buraya bağlanarak yeni test ağını ekleyin. Siteye bağlandığınızda oto olarak ekleniyor.

### Zaten daha önce kaydolduysanız burada kayıt olurken kullandığınız cüzdanı import edin kelimelerle.
```
nibid keys add CUZDAN --recover
```
### Daha kayıt olmadıysanız kurulumu yaptıktan sonra oluşturduğunuz cüzdan adresi ile kaydolun.
> Kayıt :https://gleam.io/yW6Ho/nibiru-incentivized-testnet-registration
```
nibid keys add CUZDAN
```

## Faucet ---> https://discord.gg/nibiru , https://app.nibiru.fi/faucet

<img width="840" alt="image" src="https://user-images.githubusercontent.com/107190154/221564563-8ed5bc8f-2dcc-467c-946f-495ef31c4d36.png">

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
--chain-id nibiru-itn-1 \
--gas-prices 0.025unibi \
--from CÜZDANADINIZ
```

## Bu https://app.nibiru.fi/ siteden kendinize ya da diğer validatorlere stake edebilir, diğer işlemleri gerçekleştirebilirsiniz.

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------

# **Pricefeeder Kurulumu** 

### Aktif sette değilseniz şu an için bir önemi yok bu kısmın. İlla kuracağım derseniz hem tecrübe edinmek hem de denemek için kurabilirsiniz.

## Pricefeeder ayarlaması
```
curl -s https://get.nibiru.fi/pricefeeder! | bash
```
## Değişkenleri ayarlayalım
> export FEEDER_MNEMONIC, export VALIDATOR_ADDRESS kısımlarını düzeltin. Diğer kısımları olduğu gibi bırakalım.
```
export CHAIN_ID="nibiru-itn-1"
export GRPC_ENDPOINT="localhost:9090"
export WEBSOCKET_ENDPOINT="ws://localhost:26657/websocket"
export EXCHANGE_SYMBOLS_MAP='{ "bitfinex": { "ubtc:uusd": "tBTCUSD", "ueth:uusd": "tETHUSD", "uusdt:uusd": "tUSTUSD" }, "binance": { "ubtc:uusd": "BTCUSD", "ueth:uusd": "ETHUSD", "uusdt:uusd": "USDTUSD", "uusdc:uusd": "USDCUSD", "uatom:uusd": "ATOMUSD", "ubnb:uusd": "BNBUSD", "uavax:uusd": "AVAXUSD", "usol:uusd": "SOLUSD", "uada:uusd": "ADAUSD", "ubtc:unusd": "BTCUSD", "ueth:unusd": "ETHUSD", "uusdt:unusd": "USDTUSD", "uusdc:unusd": "USDCUSD", "uatom:unusd": "ATOMUSD", "ubnb:unusd": "BNBUSD", "uavax:unusd": "AVAXUSD", "usol:unusd": "SOLUSD", "uada:unusd": "ADAUSD" } }'
export FEEDER_MNEMONIC="CÜZDANKELİMELERİNİZİYAZIN"
export VALIDATOR_ADDRESS="VALOPERADRESİNİZİYAZIN"
```
## Servis dosyamızı oluşturalım.
> Tek seferde girin komutu
```
sudo tee /etc/systemd/system/pricefeeder.service<<EOF
[Unit]
Description=Nibiru Pricefeeder
Requires=network-online.target
After=network-online.target

[Service]
Type=exec
User=$USER
ExecStart=/usr/local/bin/pricefeeder
Restart=on-failure
ExecReload=/bin/kill -HUP $MAINPID
KillSignal=SIGTERM
PermissionsStartOnly=true
LimitNOFILE=65535
Environment=CHAIN_ID='$CHAIN_ID'
Environment=GRPC_ENDPOINT='$GRPC_ENDPOINT'
Environment=WEBSOCKET_ENDPOINT='$WEBSOCKET_ENDPOINT'
Environment=EXCHANGE_SYMBOLS_MAP='$EXCHANGE_SYMBOLS_MAP'
Environment=FEEDER_MNEMONIC='$FEEDER_MNEMONIC'

[Install]
WantedBy=multi-user.target
EOF
```
## Başlatalım
```
sudo systemctl daemon-reload && \
sudo systemctl enable pricefeeder && \
sudo systemctl start pricefeeder
```
## Kontrol edelim
```
journalctl -fu pricefeeder
```
# Faydalı Komutlar

## Başka validator delege etme
```
nibid tx staking delegate VALOPERADRES 10000000unibi --from=CÜZDANADI --chain-id nibiru-itn-1 --gas=auto
```
## Redelege
```
nibid tx staking redelegate gönderenvaloper alıcıvaloperadres 10000000unibi --chain-id nibiru-itn-1 --from=CÜZDANADI --gas=auto
```
## Cüzdandan cüzdana transfer
```
nibid tx bank send GÖNDERENADRES ALICIADRES 10000000unibi --from=CÜZDANADI --chain-id nibiru-itn-1 --gas=auto
```
## Oy kullanma 
```
nibid tx gov vote 1 yes --from CÜZDANADI --chain-id nibiru-itn-1
```
## Validator Düzenleme
```
nibid tx staking edit-validator \
--moniker=NODEADINIZ \
--identity=<KEYBASE ID> \
--website="<WEBSİTENİZ>" \
--details="<AÇIKLAMA>" \
--chain-id nibiru-itn-1 \
--from=CÜZDANADINIZ
```

## Unjail 
```
nibid tx slashing unjail --from CÜZDANADI --chain-id nibiru-itn-1 --gas-prices 0.1unibi --gas-adjustment 1.5 --gas auto -y 
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

Herkese Kolay Gelsin.
