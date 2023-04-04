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

https://explorer.nibiru.fi/nibiru-itn-1

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
## Seed ve Peers ayarı
```
SEEDS="3f472746f46493309650e5a033076689996c8881@nibiru-testnet.rpc.kjnodes.com:39659,a431d3d1b451629a21799963d9eb10d83e261d2c@seed-1.itn-1.nibiru.fi:26656,6a78a2a5f19c93661a493ecbe69afc72b5c54117@seed-2.itn-1.nibiru.fi:26656"
PEERS="d5519e378247dfb61dfe90652d1fe3e2b3005a5b@65.109.68.190:39656,1587dd54b6e1f373ccf61401980816fbd7f7e43a@35.232.147.245:26656,30abc253688f7e70a6dcae9f0850e41a0245db3a@129.226.148.203:26656,104a00413d0fc7ec208c810c50d49932da355bd5@129.226.159.141:26656,6fefa7ece2ff81d1c228c31eda72692d9299d8bc@38.242.248.145:26656,f28e811d5c509cad0d14a6757a1eea1441be3e13@65.108.9.164:22456,aac16ac16e941f944c3c911db963e23159c6d637@38.242.246.213:26656,4715d949ee0ed2be527a21a6a8d0985430103017@109.205.182.232:26656,d5cc6d9f81b5cf808981233a6f8029e0d775504a@165.232.148.181:32656,883e3477ad5360a63c9f9d66a7b731e99dfe2dfd@138.68.101.57:38656,971fa24215b57d81be85a68a0a85b0b64d122dfc@5.166.240.95:26656,4ff2d57f41c0162dcfed7ac55077ed36e8721c18@31.220.86.18:26656,785ffb99f8724319d44254cbb47b3428aaaa25a5@38.242.236.134:26656,07323474e3685dd9ab23c5d515f62ff929c8dab2@45.147.248.163:26656,25dc5ada7df01293cc7af2b44b24356e054228a2@217.79.255.69:26656,a3de1f505133b416a47f546b4d4ccbdc442a891b@84.46.251.68:26656,fc015be87e5c15953a6508403c99a6c8d9493622@194.34.232.35:39656,01277e798525ff4df01ce6301a769b6898f408ea@95.217.156.93:26656,efaee8ff19257f93a8bb632aeeec29068e9f39c1@95.214.53.37:26656,30a63eaa77f7f95d741d16c2564441c4422fdb25@185.219.142.120:26656,766f17b24c11b5eac20cf938f619bc2e43331988@38.242.229.238:26656,6173aa0fb340ab41724d72339d164a86e7a6d0ac@185.229.119.95:26656,63c350ff4e6cc8cd4eb93332b2014473c9db9d8f@83.229.83.167:26656,2d635a85087168f8ff3d17d1fa9c609195642775@206.189.134.31:26656,a10fd4adadd7ca8f430ad88ffdc93366e9471b00@149.102.135.51:26656,64fc94a56f69bae2ba8c23bfdf0f0c0ece535e68@184.174.34.119:26656"
sed -i 's|^seeds *=.*|seeds = "'$SEEDS'"|; s|^persistent_peers *=.*|persistent_peers = "'$PEERS'"|' $HOME/.nibid/config/config.toml
```
# Minimum gas price ayarı ve prometheus ayarı
```
sed -i 's|^minimum-gas-prices *=.*|minimum-gas-prices = "0.0001unibi"|g' $HOME/.nibid/config/app.toml
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
nibid tendermint unsafe-reset-all --home $HOME/.nibid --keep-addr-book
```
```
sudo systemctl daemon-reload
sudo systemctl enable nibid
sudo systemctl start nibid
```

# Dileyen Snapshot ya da State Sync kullanabilir. İkisinden birini tercih edebilirsiniz ancak benim önerim Snapshot kullanmanız olacaktır.

## Ağ ile daha hızlı senkron olmak için Snapshot
```
sudo systemctl stop nibid
cp $HOME/.nibid/data/priv_validator_state.json $HOME/.nibid/priv_validator_state.json.backup 
nibid tendermint unsafe-reset-all --home $HOME/.nibid --keep-addr-book
```
```
curl https://snapshots2-testnet.nodejumper.io/nibiru-testnet/nibiru-itn-1_2023-04-02.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.nibid
mv $HOME/.nibid/priv_validator_state.json.backup $HOME/.nibid/data/priv_validator_state.json 
```
```
sudo systemctl start nibid
sudo journalctl -u nibid -f --no-hostname -o cat
```

## Ağ ile daha hızlı senkron olmak için State Sync
```
sudo systemctl stop nibid
cp $HOME/.nibid/data/priv_validator_state.json $HOME/.nibid/priv_validator_state.json.backup
nibid tendermint unsafe-reset-all --home $HOME/.nibid
```
```
STATE_SYNC_RPC=https://nibiru-testnet.rpc.kjnodes.com:443
STATE_SYNC_PEER=d5519e378247dfb61dfe90652d1fe3e2b3005a5b@nibiru-testnet.rpc.kjnodes.com:39656
LATEST_HEIGHT=$(curl -s $STATE_SYNC_RPC/block | jq -r .result.block.header.height)
SYNC_BLOCK_HEIGHT=$(($LATEST_HEIGHT - 2000))
SYNC_BLOCK_HASH=$(curl -s "$STATE_SYNC_RPC/block?height=$SYNC_BLOCK_HEIGHT" | jq -r .result.block_id.hash)

sed -i \
  -e "s|^enable *=.*|enable = true|" \
  -e "s|^rpc_servers *=.*|rpc_servers = \"$STATE_SYNC_RPC,$STATE_SYNC_RPC\"|" \
  -e "s|^trust_height *=.*|trust_height = $SYNC_BLOCK_HEIGHT|" \
  -e "s|^trust_hash *=.*|trust_hash = \"$SYNC_BLOCK_HASH\"|" \
  -e "s|^persistent_peers *=.*|persistent_peers = \"$STATE_SYNC_PEER\"|" \
  $HOME/.nibid/config/config.toml

mv $HOME/.nibid/priv_validator_state.json.backup $HOME/.nibid/data/priv_validator_state.json
```
```
sudo systemctl start nibid && sudo journalctl -u nibid -f --no-hostname -o cat
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

<img width="1210" alt="image" src="https://user-images.githubusercontent.com/107190154/229848167-7c64a81f-16a5-4558-98a2-b0aeec697adf.png">

# Faydalı Komutlar

## Kendinize ya da başka validatore delege etme
```
nibid tx staking delegate VALOPERADRESİNİZİYAZIN 1000000unibi --from CÜZDANADINIZIYAZIN --chain-id nibiru-itn-1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025unibi -y
```
## Redelege
```
nibid tx staking redelegate gönderenvaloper alıcıvaloperadres 10000000unibi --from CÜZDANADINIZIYAZIN --chain-id nibiru-itn-1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025unibi -y
```
## Cüzdandan cüzdana transfer
```
nibid tx bank send GÖNDERENADRES ALICIADRES 10000000unibi --from CÜZDANADINIZIYAZIN --chain-id nibiru-itn-1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025unibi -y
```
## Biriken Ödülleri toplama
```
nibid tx distribution withdraw-all-rewards --from CÜZDANADINIZIYAZIN --chain-id nibiru-itn-1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025unibi -y
```
## Unbound 
```
nibid tx staking unbond VALOPERADRESİNİZ 1000000unibi --from CÜZDANADINIZ --chain-id nibiru-itn-1 --gas-prices 0.1unibi --gas-adjustment 1.5 --gas auto -y 
```
## Oy kullanma 
```
nibid tx gov vote 1 yes --from CÜZDANADINIZIYAZIN --chain-id nibiru-itn-1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025unibi -y
```
## Unjail 
```
nibid tx slashing unjail --from CÜZDANADINIZIYAZIN --chain-id nibiru-itn-1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025unibi -y
```
## Validator Düzenleme
```
nibid tx staking edit-validator \
--new-moniker YENİADINIZIYAZIN \
--identity KEYBASE.IO ID'NİZ \
--details "AÇIKLAMA" \
--website "WEBSİTEADRESNİZ" \
--chain-id nibiru-itn-1 \
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

Herkese Kolay Gelsin.
