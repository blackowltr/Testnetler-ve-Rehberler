#!/bin/bash

# Başlık
echo -e '\e[40m\e[92m'
echo ' ██████╗ ██╗      █████╗  ██████╗██╗  ██╗ ██████╗ ██╗    ██╗██╗'     
echo ' ██╔══██╗██║     ██╔══██╗██╔════╝██║ ██╔╝██╔═══██╗██║    ██║██║'
echo ' ██╔══██╗██║     ███████║██║     █████╔╝ ██║   ██║██║ █╗ ██║██║'    
echo ' ██╔══██╗██║     ██╔══██║██║     ██╔═██╗ ██║   ██║██║███╗██║██║'
echo ' ██████╔╝███████╗██║  ██║╚██████╗██║  ██╗╚██████╔╝╚███╔███╔╝███████╗'
echo ' ╚═════╝ ╚══════╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝ ╚═════╝  ╚══╝╚══╝ ╚══════╝'
echo -e '\e[0m'
echo ''

# Kullanıcıdan değişkeni al
read -p "Lütfen node adınızı girin: " VALIDATOR_ALIAS

# Gerekli paketleri yükle
echo "Sistem güncellemesi yapılıyor ve gerekli paketler yükleniyor..."
cd $HOME
sudo apt update && sudo apt upgrade -y
sudo apt install curl tar wget clang pkg-config git make libssl-dev libclang-dev libclang-12-dev -y
sudo apt install jq build-essential bsdmainutils ncdu gcc git-core chrony liblz4-tool -y
sudo apt install uidmap dbus-user-session protobuf-compiler unzip -y

# Rust'u yükle
echo "Rust yükleniyor..."
cd $HOME
sudo apt update
sudo curl https://sh.rustup.rs -sSf | sh -s -- -y
. $HOME/.cargo/env
curl https://deb.nodesource.com/setup_18.x | sudo bash
sudo apt install cargo nodejs -y < "/dev/null"

# Go'yu yükle
echo "Go yükleniyor..."
if ! [ -x "$(command -v go)" ]; then
  ver="1.19.4"
  cd $HOME
  wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
  sudo rm -rf /usr/local/go
  sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
  rm "go$ver.linux-amd64.tar.gz"
  echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile
  source ~/.bash_profile
fi

# Rustup & protoc'u yükle
echo "Rustup ve protoc yükleniyor..."
cd $HOME && rustup update
PROTOC_ZIP=protoc-23.3-linux-x86_64.zip
curl -OL https://github.com/protocolbuffers/protobuf/releases/download/v23.3/$PROTOC_ZIP
sudo unzip -o $PROTOC_ZIP -d /usr/local bin/protoc
sudo unzip -o $PROTOC_ZIP -d /usr/local 'include/*'
rm -f $PROTOC_ZIP

# Diğer ayarları yap
echo "Değişkenler ayarlanıyor ..."
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

source ~/.bash_profile

# Namada ve Tendermint'i yükle
echo "Namada ve Tendermint yükleniyor..."
cd $HOME && git clone https://github.com/anoma/namada && cd namada && git checkout $NAMADA_TAG
cd
cd namada
make build-release
sleep 3
cd $HOME && git clone https://github.com/cometbft/cometbft.git && cd cometbft && git checkout $CBFT
make build

cd $HOME && cp $HOME/cometbft/build/cometbft /usr/local/bin/cometbft && \
cp "$HOME/namada/target/release/namada" /usr/local/bin/namada && \
cp "$HOME/namada/target/release/namadac" /usr/local/bin/namadac && \
cp "$HOME/namada/target/release/namadan" /usr/local/bin/namadan && \
cp "$HOME/namada/target/release/namadaw" /usr/local/bin/namadaw

cometbft version
namada --version

# Systemd'yi oluştur
echo "Systemd konfigürasyonu oluşturuluyor..."
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

# Ağa katıl ve namadayı başlat
echo "Ağa katılınıyor ve namada başlatılıyor..."
cd $HOME && namada client utils join-network --chain-id $CHAIN_ID
sudo systemctl start namadad && sudo journalctl -u namadad -f -o cat

# Senkronize olmayı bekleyin
# "catching_up" kısmını bekleyin, false olmuşsa senkronize olmuşsunuz demektir. Eğer, true yazıyorsa hala olmamışsınızdır.
echo "Senkronizasyon tamamlanana kadar bekleniyor..."
# Senkronizasyonu kontrol et ve durumunu ekrana yazdır
echo "Senkronizasyon kontrol ediliyor..."
while true; do
  catching_up=$(curl -s localhost:26657/status | jq -r '.result.sync_info.catching_up')
  if [ "$catching_up" == "false" ]; then
    echo "Senkronizasyon tamamlandı!"
    break
  elif [ "$catching_up" == "true" ]; then
    echo "Hala senkronizasyon devam ediyor..."
  else
    echo "Bilinmeyen bir senkronizasyon durumu: $catching_up"
    break
  fi
  sleep 5
done
