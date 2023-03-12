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
## Seed ve Peers ayarı
```
SEEDS="3f472746f46493309650e5a033076689996c8881@nibiru-testnet.rpc.kjnodes.com:39659,a431d3d1b451629a21799963d9eb10d83e261d2c@seed-1.itn-1.nibiru.fi:26656,6a78a2a5f19c93661a493ecbe69afc72b5c54117@seed-2.itn-1.nibiru.fi:26656"
PEERS="a1b96d1437fb82d3d77823ecbd565c6268f06e34@nibiru-testnet.nodejumper.io:27656,19f8333cbcaf4f946d20a91d9e19d5fc91899023@167.235.74.22:26656,9e9a8ffb07318c9d5237274bb32711b008b46348@91.107.233.192:26656,6f29a743ad237d435aac29b62528cea01ceb3ca9@46.4.91.90:26656,ca5805d8553b99d6e226deecd9c28a9bcb380651@161.97.163.208:26656,1c6f50dfeb2187f38e8dea2e1bae00e8b5bf6b16@161.97.102.159:26656,f9e2c35f5da87933bcc092ab9f14d45b08d3e89d@65.108.145.226:26656,1d2d3e8353043b25675040258912fb04cfc3eff9@162.55.242.81:26656,aafe706e7bb9aac7e8ec2878d775252652594b3e@78.46.97.242:26656,8e01bceecf0965c6e9f1cbce95063ae9de931ada@144.91.65.161:26656,e08089921baf39382920a4028db9e5eebd82f3d7@142.132.199.236:21656,dfdfca675e009578b775d7febace9d15d97c3755@207.180.224.21:26656,a9fd9fa7733333fa0b1f9d0868e394dd73c103da@89.116.28.98:26656,333b77ac522d86819d341cd675f962dd0ee3ae79@85.190.246.188:26656,4f1af4f62f76c095d844384a3dfa1ad76ad5c078@65.108.206.118:60656,5a58fa951f65cd2381d0f9a584fbb76fdafc476c@45.10.154.139:18656,5dd26cc6a2778cea7c0daed0a53a39c6165a790f@168.119.101.224:26656,f2e99f5a68adfb08c139944a193e2e3a4864b038@167.235.132.74:26656,bc2f0d7d7284ae91db72665d9fe154be4c2adae9@91.230.110.106:26656,a2d2ba190f32700f44e9dbe990c814f46abfc96f@81.0.221.31:26656,fc622de0732fb4ed75319c31dc83e22517a48c1c@144.91.75.58:26656,d3624259ec8322cd4b6bce5b39aaf6074f90a2ab@173.212.248.126:26656,aa166a62f6983edccd5a2619b036fe83cb4eb57e@168.119.248.238:26656,e052d62551e51b986572ea0c2e7c49ebb080b108@89.163.132.44:26656,22f1bf214da6c0c1e6c6b78bc6005ac4fc4456da@46.228.205.211:26656,cd44f2d2fc1ded3a63c64f46ed67f783c2d93d57@144.76.223.24:36656,5f794b4b6f1232e5814c66f4bd7307adcdd206cb@104.248.61.162:26656,e74f1204d65d0264547e2c2d917c23c39fcff774@95.217.107.96:36656,d12c686810ecfa63d55ac47715a542d0d73648ac@144.91.107.153:26656,79e2bfc202e39ba2a168becc4c75cb6a56803e38@135.181.57.104:11656,595a8f93897710cacc3173c9ae4d0bafda5b3879@141.94.73.93:36656,8ebed484e09f93b12be00b9f6faa55ea9b13b372@45.84.138.66:39656,81351ddd64122e553cf2c10efbd979c8c6e97529@161.97.166.105:26656,3060a899170ccb3d787d6fd840c5e8b6805f4b4d@155.133.22.140:26656,8bd4bbda5a778f362e8d848eedc0e7aa0a85f776@38.242.253.73:26656,5f3394bae3791bcb71364df80f99f22bd33cc2c0@95.216.7.169:60556,a141b286f68f88fa41b1e12cbf5ab079610fabd4@149.102.155.48:26656,226cc92db67523820735c939c1dde96892ad1c6d@194.163.147.65:26656,4ae091976ef83403cbbb55345a1af0a06f3ef524@144.76.101.41:26656,5b2d7ccdf924ff16c3d0e3b55c4547a71c99dc42@161.97.122.167:39656,d6121e2eb0842e03529b3a093204bebe637fa5aa@149.102.140.245:26656,455631724cc9596a3f1ca99fe6874125d050a983@38.242.225.208:26656,7b71facfb46ccd860d4d71696b3a077676a6f2b5@65.109.166.8:26656,be58621ecdf7dae1ff6fa5123793ddbc794427b1@65.21.248.137:26656,adcb0c33d521b5a26e83834454ed126988493573@95.216.74.4:26656,9f993f07f3fe0c788f7d55f88b7a031028a378f5@217.76.60.46:26656,cbab105572dda2e1fd343c95e29aa4c7a7336196@194.163.166.62:26656,abd7cc73f45fd10c87f90ce2e7c2b63d8d7dd28e@91.189.129.99:26656@c171e9617904d5ab2ee7f7b5b58caab78154b703@89.117.18.185:26656,63256b5937ac438e3b21b570a07ace6ddc3bd0c6@194.163.182.122:39656,8265b2067122eff44ca4fa11a46c3381c9034bc1@65.109.163.87:26656,e634fbf8800f76cb911d03e665f2e573188147c0@154.53.32.30:26657,a5091d1afa277bab864a495d43226ee44f85604e@212.23.222.91:39656,2393cd0e22a8c70f34526fcddc99e08478c3cb7a@89.117.53.2:26656,b4583d9dd4dd03cda5f83b95edfd209f902de063@138.201.53.44:26757,10a2db5117fe9fdfefcfc9ca633e5633b0c38d4e@34.125.211.20:26656,4fb43c4d6bd6cf0f20781b67e437263a24e4153d@95.217.75.105:31656,224c85918ea98d62daab63ba9eceab195b676760@144.91.71.1:26656,d622efcde775f33bd8c14fa5757ee9fa95d4149e@135.181.203.53:26656,cc5eac998dbd8d1c21ac293f1c946f1bb1583826@185.237.253.248:26656,aaff99ce425ac9d062d1bca6f75987656e137307@138.201.34.19:26656,f41685745f7cd74caa542829d291367ae1377ce0@34.74.30.133:26656,022c0e642eefa50a78e9e03bb1fa80237da232ac@178.208.252.54:28656,9a46a84b86410636540e7405e8d76ed4740b6bb7@46.151.26.153:26656,452e0e07750f380d87e1bd654a198df0c1225130@80.82.215.59:39656,7b3ebcf55ea111436056214743aad227672b3e6d@5.181.190.161:26757,b6db16ab4d2dfd61d0be94df4738ce5f1913de11@212.41.9.98:26656,879d464755722009c853f748f04f729e4cd8b368@116.202.227.117:39656,57cd99659f4895cada5ba5a9f594ce9a5fdb0fa8@46.4.23.42:46656,4e3f67a4c88b40045e0de521bab5a3cee9aeb4aa@139.217.229.125:26656,bce7435b6231fd97885ffccc57b1d7d98f20b37f@173.212.235.229:26656,ed02182dfbfdd209003fae545f1065330f69ef27@138.201.22.238:26646,d3bacf8624684354d0676320bc5556e1e893bdfa@65.21.91.50:26656,5c2a752c9b1952dbed075c56c600c3a79b58c395@195.3.220.140:27046,07d59fc815394526696a364ef4c6910683c332e7@139.144.97.186:26656,e387712543bc99c6719f7975ee75e48afb99b088@66.45.251.38:60656,6c679a2b8397b1d04a33de37828e3b67e9e6b9c0@65.109.6.21:27656,1edd1232fe59fd00a13bfdd9ac273e48b20f11c3@65.108.231.124:12656,e9597b5074802ca53eb630a07603093e7ee98e6f@212.90.121.51:26656,35d8f676cf4db0f4ed7f3a8750daf8010797bdc4@135.181.116.109:26656,d5519e378247dfb61dfe90652d1fe3e2b3005a5b@65.109.68.190:39656,3a5ba67e5329791db55763354ff98d3c253e4a0c@103.136.249.27:26656,9d5557755cf50a274ab5bada66cf26db64da296b@135.181.119.59:26656"
sed -i 's|^seeds *=.*|seeds = "'$SEEDS'"|; s|^persistent_peers *=.*|persistent_peers = "'$PEERS'"|' $HOME/.nibid/config/config.toml
curl -s https://snapshots2-testnet.nodejumper.io/nibiru-testnet/addrbook.json > $HOME/.nibid/config/addrbook.json
```
# Minimum gas price ayarı ve prometheus ayarı
```
sed -i 's/minimum-gas-prices =.*/minimum-gas-prices = "0.025unibi"/g' $HOME/.nibid/config/app.toml
sed -i 's|^prometheus *=.*|prometheus = true|' $HOME/.nibid/config/config.toml
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

# Dileyen Snapshot ya da State Sync kullanabilir. İkisinden birini tercih edebilirsiniz ancak benim önerim Snapshot kullanmanız olacaktır.

## Ağ ile daha hızlı senkron olmak için Snapshot
```
sudo systemctl stop nibid
cp $HOME/.nibid/data/priv_validator_state.json $HOME/.nibid/priv_validator_state.json.backup
rm -rf $HOME/.nibid/data
```
```
curl -L https://snapshots.kjnodes.com/nibiru-testnet/snapshot_latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.nibid
mv $HOME/.nibid/priv_validator_state.json.backup $HOME/.nibid/data/priv_validator_state.json
```
```
sudo systemctl start nibid && sudo journalctl -u nibid -f --no-hostname -o cat
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
## Oy kullanma 
```
nibid tx gov vote 1 yes --from CÜZDANADINIZIYAZIN --chain-id nibiru-itn-1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025unibi -y
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

## Unjail 
```
nibid tx slashing unjail --from CÜZDANADINIZIYAZIN --chain-id nibiru-itn-1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025unibi -y
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
