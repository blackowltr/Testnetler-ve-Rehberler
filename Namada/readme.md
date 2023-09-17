# Namada Node Kurulumu ve Validator Oluşturma Rehberi

## Gereksinimler

Bu kılavuzu tamamlamak için aşağıdaki gereksinimlere ihtiyacınız olacak:

- Ubuntu 20.04 veya daha yeni bir işletim sistemi.
- 4 veya 8 CPU
- 8 veya 16 RAM
- 500 GB veya 1TB Disk

## Adım 1: Gerekli Paketleri Yükleme

İlk adım olarak, gerekli paketleri yükleyeceğiz:

```bash
cd $HOME
sudo apt update && sudo apt upgrade -y
sudo apt install curl tar wget clang pkg-config git make libssl-dev libclang-dev libclang-12-dev -y
sudo apt install jq build-essential bsdmainutils ncdu gcc git-core chrony liblz4-tool -y
sudo apt install uidmap dbus-user-session protobuf-compiler unzip -y
```

## Adım 2: Rust ve Go Yüklemek

Namada, Rust ve Go dillerini kullanır. Bu nedenle, Rust ve Go'yu yüklemeniz gerekecek. Aşağıdaki komutları kullanarak bunları yükleyebilirsiniz:

```bash
cd $HOME
sudo apt update
sudo curl https://sh.rustup.rs -sSf | sh -s -- -y
. $HOME/.cargo/env
curl https://deb.nodesource.com/setup_18.x | sudo bash
sudo apt install cargo nodejs -y < "/dev/null"
```

## Adım 3: Protobuf ve Değişkenleri Ayarlama
>$VALIDATOR_ALIAS kısmını değiştirmeyi unutmayın.

```bash
cd $HOME && rustup update
PROTOC_ZIP=protoc-23.3-linux-x86_64.zip
curl -OL https://github.com/protocolbuffers/protobuf/releases/download/v23.3/$PROTOC_ZIP
sudo unzip -o $PROTOC_ZIP -d /usr/local bin/protoc
sudo unzip -o $PROTOC_ZIP -d /usr/local 'include/*'
rm -f $PROTOC_ZIP

sed -i '/public-testnet/d' "$HOME/.bash_profile"
sed -i '/NAMADA_TAG/d' "$HOME/.bash_profile"
sed -i '/WALLET_ADDRESS/d' "$HOME/.bash_profile"
sed -i '/CBFT/d' "$HOME/.bash_profile"

echo "export NAMADA_TAG=v0.22.0" >> ~/.bash_profile
echo "export CBFT=v0.37.2" >> ~/.bash_profile
echo "export CHAIN_ID=public-testnet-13.facd514666d5" >> ~/.bash_profile
echo "export WALLET=wallet" >> ~/.bash_profile
echo "export BASE_DIR=$HOME/.local/share/namada" >> ~/.bash_profile
echo "export VALIDATOR_ALIAS=$VALIDATOR_ALIAS" >> ~/.bash_profile
```

```
source ~/.bash_profile
```

## Adım 4: Namada ve Tendermint'i Yükleme

Namada ve Tendermint'i yükleyelim:

```bash
cd $HOME && git clone https://github.com/anoma/namada && cd namada && git checkout $NAMADA_TAG
cd
cd namada
make build-release
```
```
cd $HOME && git clone https://github.com/cometbft/cometbft.git && cd cometbft && git checkout $CBFT
make build

cd $HOME && cp $HOME/cometbft/build/cometbft /usr/local/bin/cometbft && \
cp "$HOME/namada/target/release/namada" /usr/local/bin/namada && \
cp "$HOME/namada/target/release/namadac" /usr/local/bin/namadac && \
cp "$HOME/namada/target/release/namadan" /usr/local/bin/namadan && \
cp "$HOME/namada/target/release/namadaw" /usr/local/bin/namadaw
```

## Adım 5: Systemd Konfigürasyonu Oluşturma

Systemd konfigürasyonu oluşturalım:

```bash
sudo tee /etc/systemd/system/namadad.service > /dev/null <<EOF
[Unit]
Description=namada
After=network-online.target
[Service]
User=$USER
WorkingDirectory=$HOME/.local/share/namada
Environment=TM_LOG_LEVEL=p2p:none,pex:error
Environment=NAMADA_CMT_STDOUT=true
ExecStart=/usr/local/bin/namada node ledger run
StandardOutput=syslog
StandardError=syslog
Restart=always
RestartSec=10
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable namadad
```

## Adım 6: Ağa Katılma ve Senkronizasyon

Ağa katılalım ve Namada'yı başlatalım:

```bash
cd $HOME && namada client utils join-network --chain-id $CHAIN_ID
sudo systemctl start namadad && sudo journalctl -u namadad -f -o cat
```

Bu adımları tamamladığınızda, Namada'yı başlatmış olacak ve senkronizasyonun tamamlanmasını bekleyeceksiniz. 

Daha sonra cüzdan oluşturabilir ve Validator oluşturabilirsiniz.
