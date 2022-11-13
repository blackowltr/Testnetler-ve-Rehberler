# Gitopia Testnet Kurulum Rehberi

![Gitopia Testnet Rehberi](https://user-images.githubusercontent.com/107190154/201514536-57b2c413-5e04-40f6-ba45-0c7d5a91abff.png)

# Sistem Gereksinimleri

|CPU | RAM  | Disk  | 
|----|------|----------|
|   4| 16GB  | 1000GB  |

### [Website](https://gitopia.com/home)

### [Explorer](https://explorer.gitopia.com/)

### [Eng-Doküman](https://gitopia.com/CryptoSailors/gitopia-node-installation/tree/master)

## Sistem Güncelleme ve Kütüphane Kurulumu
```
sudo apt update && sudo apt upgrade -y & sudo apt install make clang pkg-config libssl-dev libclang-dev build-essential git curl ntp jq llvm tmux htop screen unzip cmake -y
```

## Go Kurulumu
```
wget https://golang.org/dl/go1.19.3.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.19.3.linux-amd64.tar.gz
cat <<EOF >> ~/.profile
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export GO111MODULE=on
export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin
EOF
source ~/.profile
go version
rm -rf go1.19.3.linux-amd64.tar.gz
```

## Node Kurulum
```
curl https://get.gitopia.com | bash
```
## Gitopia reposunu klonluyoruz.
```
git clone -b v1.2.0 gitopia://gitopia/gitopia
```

## Binary Kurulumu
```
cd $HOME && rm -rf gitopia
git clone -b v1.2.0 gitopia://gitopia/gitopia && cd gitopia
make install
```

## Versiyon Numarası Kontrolü
```
gitopiad version
```

## İnitialize İşlemi Yapıyoruz, yani başlatma işlemi
> `nodeİSİM` yazan yere kendi node isminizi yazın.
```
gitopiad init --chain-id gitopia-janus-testnet-2 nodeİSİM
```

## Minimum gas price
```
sed -i.bak -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.001utlore\"/" ~/.gitopia/config/app.toml
```

## İndexer Kapatma
```
sed -i.bak -e "s/^indexer *=.*/indexer = \"null\"/" ~/.gitopia/config/config.toml
```

## Seed
```
SEEDS="399d4e19186577b04c23296c4f7ecc53e61080cb@seed.gitopia.com:26656"
PEERS=""
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.gitopia/config/config.toml
```

## Pruning Açma
```
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="50"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.gitopia/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.gitopia/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.gitopia/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.gitopia/config/app.toml
```

## Genesis File İndiriyoruz.
```
wget -O $HOME/.gitopia/config/addrbook.json "http://65.108.6.45:8000/gitopia/addrbook.json"
wget https://server.gitopia.com/raw/gitopia/testnets/master/gitopia-janus-testnet-2/genesis.json.gz
gunzip genesis.json.gz
mv genesis.json $HOME/.gitopia/config/genesis.json
```

## Binary dosyasını /usr/bin altına taşıyoruz.
```
mv $HOME/go/bin/gitopiad /usr/bin/
```

## Servis Dosyası
```
tee /etc/systemd/system/gitopiad.service > /dev/null <<EOF
[Unit]
Description=Gitopia
After=network-online.target
[Service]
User=root
ExecStart=$(which gitopiad) start
Restart=always
RestartSec=3
LimitNOFILE=10000
[Install]
WantedBy=multi-user.target
EOF
```

## Node'u Başlatalım
```
sudo systemctl daemon-reload
sudo systemctl start gitopiad
sudo systemctl enable gitopiad
systemctl restart systemd-journald
sudo journalctl -u gitopiad -f -o cat
```

## Log Kontrolü
```
journalctl -fu gitopiad -o cat
```

## Sync Durumu Kontrolü İçin
```
gitopiad status 2>&1 | jq .SyncInfo
```

# Cüzdan Oluşturma
> `cüzdanİSİM` yazan yere kendi cüzdan adınızı yazın.
```
gitopiad keys add cüzdanİSİM
```

### Cüzdanı oluşturduktan sonra [buradan](https://gitopia.com/home) token alacağız.

![image](https://user-images.githubusercontent.com/107190154/201514071-1b8f50f6-d48a-49ea-8846-2e6ead2fc846.png)

## Get TLORE yazan yerden talep edeceğiz.

## Validator Oluşturma
> NodeİSİM yazan yere node isminizi, cüzdanİSİM yazan yere cüzdan isminizi yazın.
``` 
gitopiad tx staking create-validator \
--amount="5000000utlore" \
--pubkey=$(gitopiad tendermint show-validator) \
--moniker="NodeName" \
--chain-id=gitopia-janus-testnet-2 \
--from="WalletName" \
--commission-rate="0.1" \
--commission-max-rate=0.15 \
--commission-max-change-rate=0.1 \
--min-self-delegation=1 \
--gas-prices="0.001utlore" \
-y
```

### Node Silmek İsterseniz
```
sudo systemctl stop gitopiad
sudo systemctl disable gitopiad
sudo rm /etc/systemd/system/gitopia* -rf
sudo rm $(which gitopiad) -rf
sudo rm $HOME/.gitopia* -rf
sudo rm $HOME/gitopia -rf
sed -i '/GITOPIA_/d' ~/.bash_profile
```

### Hepinize Kolay Gelsin..
