# MantraChain Kurulum Rehberi

![gfgdfgd](https://github.com/brsbrc/Testnetler-ve-Rehberler/assets/107190154/d6936f43-fc71-4214-a33b-cce333c873ed)

Bu rehberde, MantraChain node'unu kurma adımlarını bulacaksınız. Bu adımları takip ederek MantraChain node'unu başarıyla kurabilirsiniz. Kolay gelsin..

## Gereksinimler

**MantraChain node'unu çalıştırmak için aşağıdaki gereksinimlere sahip olmanız önerilir:**

- 4 veya daha fazla CPU 
- En az 200GB SSD disk depolama
- En az 8GB RAM
- En az 100mbps ağ bant genişliği

## Gerekli kütüphaneleri yükleme ve sistem güncellemesi

Aşağıdaki komutları kullanarak sistem güncellemesi yapın ve gerekli kütüphaneleri yükleyin:

```
sudo apt update && sudo apt upgrade -y
sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential bsdmainutils git make ncdu gcc git jq chrony liblz4-tool -y
```

## Go Kurulumu

MantraChain için Go'yu kurun:

```
ver="1.20.6"
cd $HOME
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile
source ~/.bash_profile
go version
```

## Binary Dosyayı İndirme ve Kurulum

MantraChain Binary dosyasını indirin ve kurun:

```
wget https://github.com/MANTRA-Finance/public/raw/main/mantrachain-testnet/mantrachaind-linux-amd64.zip
unzip mantrachaind-linux-amd64.zip
sudo wget -P /usr/lib https://github.com/CosmWasm/wasmvm/releases/download/v1.3.0/libwasmvm.x86_64.so
sudo mv ./mantrachaind /usr/local/bin
```

## Node'u Başlatma

Lütfen aşağıdaki komutları kullanarak node'u başlatın ve kendi NODEADINIZ'ı belirtin:

```
mantrachaind init "NODEADINIZ" --chain-id mantrachain-1
mantrachaind config keyring-backend test
```

## Genesis Dosyasını ve Addrbook'u İndirme

Genesis dosyasını ve addrbook dosyasını indirin:

```
wget -O $HOME/.mantrachain/config/genesis.json https://raw.githubusercontent.com/MANTRA-Finance/public/main/mantrachain-testnet/genesis.json
```

## Seeds ve Peers Ayarları

Aşağıdaki komutları kullanarak Seeds ve Peers ayarlarınızı yapın:

```
SEEDS=""
sed -i -e "s|^seeds *=.*|seeds = \"$SEEDS\"|" $HOME/.mantrachain/config/config.toml
peers="0e687ef17922361c1aa8927df542482c67fb7571@35.222.198.102:26656,114988f9a053f594ab9592beb79b924430d355ba@34.123.40.240:26656,c533d7ee2037ee6d382f773be04c5bbf27da7a29@34.70.189.2:26656,a435339f38ce3f973739a08afc3c3c7feb862dc5@35.192.223.187:26656"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.mantrachain/config/config.toml
sed -i -e "s|^minimum-gas-prices *=.*|minimum-gas-prices = \"0.00uaum\"|" $HOME/.mantrachain/config/app.toml
```

## Pruning ayarları

Aşağıdaki komutları kullanarak # Pruning ayarlarını yapın:

```
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.mantrachain/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.mantrachain/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.mantrachain/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.mantrachain/config/app.toml
```

## Servis Dosyası Oluşturma ve Node'u Başlatma

Aşağıdaki komutları kullanarak MantraChain node'u için bir servis dosyası oluşturun ve başlatın:

```
sudo tee /etc/systemd/system/mantrachaind.service > /dev/null <<EOF
[Unit]
Description=mantrachain
After=network-online.target

[Service]
User=$USER
ExecStart=$(which mantrachaind) start
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
```
```
sudo systemctl daemon-reload
sudo systemctl enable mantrachaind
sudo systemctl start mantrachaind
```

## Snapshot ile hızlı sync

Snapshot'ını indirin:

```
SNAP_NAME=$(curl -s https://ss-t.mantra.nodestake.top/ | egrep -o ">20.*\.tar.lz4" | tr -d ">")
curl -o - -L https://ss-t.mantra.nodestake.top/${SNAP_NAME}  | lz4 -c -d - | tar -x -C $HOME/.mantrachain
```

## Senkronizasyon Kontrolü

Node'unuzun senkronize olup olmadığını kontrol edin:
```
mantrachaind status 2>&1 | jq .SyncInfo
```
