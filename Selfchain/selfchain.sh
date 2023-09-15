#!/bin/bash

echo -e '\e[40m\e[92m'
echo ' ██████╗ ██╗      █████╗  ██████╗██╗  ██╗ ██████╗ ██╗    ██╗██╗'
echo ' ██╔══██╗██║     ██╔══██╗██╔════╝██║ ██╔╝██╔═══██╗██║    ██║██║'
echo ' ██████╔╝██║     ███████║██║     █████╔╝ ██║   ██║██║ █╗ ██║██║'
echo ' ██╔══██╗██║     ██╔══██║██║     ██╔═██╗ ██║   ██║██║███╗██║██║'
echo ' ██████╔╝███████╗██║  ██║╚██████╗██║  ██╗╚██████╔╝╚███╔███╔╝███████╗'
echo ' ╚═════╝ ╚══════╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝ ╚═════╝  ╚══╝╚══╝ ╚══════╝'
echo -e '\e[0m'

# Değişkenler
if [ ! $NODENAME ]; then
	read -p $'\e[1m\e[93mLütfen node ismini giriniz: \e[0m' NODENAME
	echo 'export NODENAME='$NODENAME >> $HOME/.bash_profile
fi

if [ ! $WALLET ]; then
	echo "export WALLET=wallet" >> $HOME/.bash_profile
fi

SELF_CHAIN_ID=self-dev-1
source $HOME/.bash_profile

echo -e '\e[1m\e[32m================================================='
echo -e "Node İsmi: $NODENAME"
echo -e "Cüzdan İsmi: $WALLET"
echo -e "Chain ID: $SELF_CHAIN_ID"
echo -e '=================================================\e[0m'
sleep 2

# Adım 1: Sistemi Güncelleme
echo -e '\e[1m\e[34mAdım 1: Sistemi Güncelleme...\e[0m'
sudo apt update
sudo apt-get install git curl build-essential make jq gcc snapd chrony lz4 tmux unzip bc -y

# Adım 2: Go Kurma
echo -e '\e[1m\e[34mAdım 2: Go Kurma...\e[0m'
rm -rf $HOME/go
sudo rm -rf /usr/local/go
cd $HOME
curl https://dl.google.com/go/go1.20.5.linux-amd64.tar.gz | sudo tar -C/usr/local -zxvf -
cat <<'EOF' >>$HOME/.profile
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export GO111MODULE=on
export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin
EOF
source $HOME/.profile
go version

# Adım 3: Node Kurma
echo -e '\e[1m\e[34mAdım 3: Node Kurma...\e[0m'
cd $HOME
mkdir -p /root/go/bin/
wget https://ss-t.self.nodestake.top/selfchaind
chmod +x selfchaind
mv selfchaind /root/go/bin/

# Adım 4: Node Başlatma
echo -e '\e[1m\e[34mAdım 4: Node Başlatma...\e[0m'
selfchaind init $NODENAME --chain-id=self-dev-1

# Genesis'i İndirme
echo -e '\e[1m\e[34mGenesis'i İndirme...\e[0m'
wget -O .selfchain/config/genesis.json  https://raw.githubusercontent.com/hotcrosscom/selfchain-genesis/main/networks/devnet/genesis.json

# Addrbook'u İndirme
echo -e '\e[1m\e[34mAddrbook'u İndirme...\e[0m'
curl -Ls https://github.com/Adamtruong6868/Selfchain.xyz/blob/main/addrbook.json > $HOME/.selfchain/config/addrbook.json

# Servis Oluşturma
echo -e '\e[1m\e[34mServis Oluşturma...\e[0m'
sudo tee /etc/systemd/system/selfchaind.service > /dev/null <<EOF
[Unit]
Description=selfchaind Daemon
After=network-online.target

[Service]
User=$USER
ExecStart=$(which selfchaind) start
Restart=always
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl enable selfchaind
sudo systemctl start selfchaind
```

echo -e '\e[1m\e[32mSelfchain Node Kurulumu Tamamlandı.'
echo -e 'Beni takip etmeyi unutmayın: \e[4m\e[96mhttps://twitter.com/brsbtc\e[0m'
