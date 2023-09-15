#!/bin/bash

# Renk kodları
GREEN='\e[1;32m'
YELLOW='\e[1;33m'
CYAN='\e[1;36m'
NC='\e[0m' # Renk sıfırlama

# Başlık fonksiyonu
print_title() {
    echo -e "${CYAN}## $1${NC}\n"
}

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
    read -p "Node ismini giriniz: " NODENAME
    echo "export NODENAME=$NODENAME" >> $HOME/.bash_profile
fi

if [ ! $WALLET ]; then
    echo "export WALLET=wallet" >> $HOME/.bash_profile
fi

SELF_CHAIN_ID=self-dev-1
source $HOME/.bash_profile

# Başlıklar
print_title "Step 1: Update the System"
echo -e "${YELLOW}Updating the system...${NC}"
sudo apt update
sudo apt-get install git curl build-essential make jq gcc snapd chrony lz4 tmux unzip bc -y

print_title "Step 2: Install Go"
echo -e "${YELLOW}Installing Go...${NC}"
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

print_title "Step 3: Install Node"
echo -e "${YELLOW}Installing Node...${NC}"
cd $HOME
mkdir -p /root/go/bin/
wget https://ss-t.self.nodestake.top/selfchaind
chmod +x selfchaind
mv selfchaind /root/go/bin/

print_title "Step 4: Initialize Node"
echo -e "${YELLOW}Initializing Node...${NC}"
selfchaind init $NODENAME --chain-id=self-dev-1

print_title "Download Genesis"
echo -e "${YELLOW}Downloading Genesis...${NC}"
curl -Ls https://raw.githubusercontent.com/brsbrc/Testnetler-ve-Rehberler/main/Selfchain/genesis.json > $HOME/.selfchain/config/genesis.json

print_title "Download addrbook"
echo -e "${YELLOW}Downloading addrbook...${NC}"
curl -Ls https://raw.githubusercontent.com/brsbrc/Testnetler-ve-Rehberler/main/Selfchain/addrbook.json > $HOME/.selfchain/config/addrbook.json

print_title "Create Service"
echo -e "${YELLOW}Creating Service...${NC}"
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

print_title "Snapshot"
echo -e "${YELLOW}Performing Snapshot...${NC}"
SNAP_NAME=$(curl -s https://ss-t.self.nodestake.top/ | egrep -o ">20.*\.tar.lz4" | tr -d ">")
curl -o - -L https://ss-t.self.nodestake.top/${SNAP_NAME} | lz4 -c -d - | tar -x -C $HOME/.selfchain
sudo systemctl restart selfchaind
journalctl -u selfchaind -f

# Tamamlandı mesajı
echo -e "${GREEN}Selfchain Node Kurulumu Tamamlandı.${NC}"
echo -e "Beni takip etmeyi unutmayın: \e[4m\e[96mhttps://twitter.com/brsbtc\e[0m"
