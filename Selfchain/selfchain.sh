#!/bin/bash

echo -e ''
echo -e '\e[40m\e[92m'
echo ' ██████╗ ██╗      █████╗  ██████╗██╗  ██╗ ██████╗ ██╗    ██╗██╗'     
echo ' ██╔══██╗██║     ██╔══██╗██╔════╝██║ ██╔╝██╔═══██╗██║    ██║██║'
echo ' ██████╔╝██║     ███████║██║     █████╔╝ ██║   ██║██║ █╗ ██║██║'    
echo ' ██╔══██╗██║     ██╔══██║██║     ██╔═██╗ ██║   ██║██║███╗██║██║'
echo ' ██████╔╝███████╗██║  ██║╚██████╗██║  ██╗╚██████╔╝╚███╔███╔╝███████╗'
echo ' ╚═════╝ ╚══════╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝ ╚═════╝  ╚══╝╚══╝ ╚══════╝'
echo -e '\e[0m'
echo ''

# Prompt the user to enter the node name (NODENAME)
read -p $'\e[1;32mEnter your desired node name (NODENAME):\e[0m ' NODENAME

# Set KEYNAME to the same value as NODENAME
KEYNAME="$NODENAME"

# Display a message indicating that KEYNAME is set to NODENAME
echo -e $'\e[1;32mKEYNAME has been set to the same value as NODENAME.\e[0m'

# Display the values of NODENAME and KEYNAME with colors
echo -e $'\e[1;36mNode Name:\e[0m' "$NODENAME"
echo -e $'\e[1;36mKey Name:\e[0m' "$KEYNAME"

# Update the System and Install Required Tools
echo -e $'\e[1;34mUpdating the system and installing required tools...\e[0m'
sudo apt update
sudo apt-get install git curl build-essential make jq gcc snapd chrony lz4 tmux unzip bc -y
sleep 3

# Install the Go Language
echo -e $'\e[1;34mInstalling the Go Language...\e[0m'
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
sleep 3

# Download and Install the Selfchain Node
echo -e $'\e[1;34mDownloading and installing the Selfchain Node...\e[0m'
cd $HOME
mkdir -p /root/go/bin/
wget https://ss-t.self.nodestake.top/selfchaind
chmod +x selfchaind
mv selfchaind /root/go/bin/
selfchaind version
sleep 3

# Initialize Your Node
echo -e $'\e[1;34mInitializing Your Node...\e[0m'
selfchaind init "$NODENAME" --chain-id=self-dev-1
sleep 3

# Download the Genesis File
echo -e $'\e[1;34mDownloading the Genesis File...\e[0m'
curl -Ls https://ss-t.self.nodestake.top/genesis.json > $HOME/.selfchain/config/genesis.json 
sleep 2

# Download the Addrbook File
echo -e $'\e[1;34mDownloading the Addrbook File...\e[0m'
curl -Ls https://ss-t.self.nodestake.top/addrbook.json > $HOME/.selfchain/config/addrbook.json 
sleep 2

# Seed and Peer Settings
echo -e $'\e[1;34mConfiguring Seed and Peer Settings...\e[0m'
PEERS="bae21418b80df93ab49f3cd612989dd1d739bdda@167.235.132.251:26656,c66b609d52cd9b4062520ef5eff1081db1ddca85@5.75.178.181:26656,5f180263bec701b722b750b9fa63ee95969e5d02@65.109.238.88:26656,7b972e7dc4e5fd1225c94f9f8f146c321fb0d380@5.75.159.86:26656,342702c9800ae15c46d40d24e7f6d209a60a9cf7@116.203.59.248:26656,88ffe6a82f9f5425c7484d3659130db88b0907a5@38.242.230.118:57656,59b50622fedb264ba4871b48c42ef21b518566da@141.94.18.48:26656,c244ea9c8d45923b00439617324552eaf20efd3e@5.9.61.78:33656,e50e9d1ad731164a54a403bd6bafda11ba13b749@170.64.141.15:26656,ca4b6131d616d4d5930e50f1f557950f17fe4091@188.166.218.244:26656,2425d2ba5f493a10d4decd0fb42ef47dc13efec2@206.189.206.88:26656" 
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.selfchain/config/config.toml
sleep 2

# Minimum Gas Price and Prometheus Settings
echo -e $'\e[1;34mConfiguring Minimum Gas Price and Prometheus Settings...\e[0m'
sed -i 's/minimum-gas-prices =.*/minimum-gas-prices = "0.025uself"/g' $HOME/.selfchain/config/app.toml
sed -i 's|^prometheus *=.*|prometheus = true|' $HOME/.selfchain/config/config.toml
sleep 2

# Create a Service
echo -e $'\e[1;34mCreating a Service...\e[0m'
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
sleep 2

# Optional - Download a Snapshot
echo -e $'\e[1;34mDownloading an Optional Snapshot...\e[0m'
SNAP_NAME=$(curl -s https://ss-t.self.nodestake.top/ | egrep -o ">20.*\.tar.lz4" | tr -d ">")
curl -o - -L https://ss-t.self.nodestake.top/${SNAP_NAME} | lz4 -c -d - | tar -x -C $HOME/.selfchain
sleep 2

# Start Your Node
echo -e $'\e[1;34mStarting Your Node...\e[0m'
sudo systemctl restart selfchaind

# Port Değiştirme Komutları
echo -e $'\e[1;34mChanging Ports...\e[0m'
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:28658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:28657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:6260\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:28656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":28660\"%" $HOME/.selfchain/config/config.toml && sed -i.bak -e "s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:9290\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:9291\"%; s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:1517\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:8745\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:8746\"%; s%^address = \"127.0.0.1:8545\"%address = \"127.0.0.1:8745\"%; s%^ws-address = \"127.0.0.1:8546\"%ws-address = \"127.0.0.1:8746\"%" $HOME/.selfchain/config/app.toml && sed -i.bak -e "s%^node = \"tcp://localhost:26657\"%node = \"tcp://localhost:28657\"%" $HOME/.selfchain/config/client.toml

# Check if the Selfchain Node started successfully
if sudo systemctl is-active --quiet selfchaind; then
  echo -e $'\e[1;32mSelfchain Node has been successfully installed and started!\e[0m'
else
  echo -e $'\e[1;31mSelfchain Node installation or startup encountered an error.\e[0m'
fi

# Follow me on Twitter for updates: https://twitter.com/brsbtc
echo "For updates and more information, follow me on Twitter: https://twitter.com/brsbtc"

# Connect with me on Discord: BlackOwl#1234
echo "Connect with me on Discord: blackowl"
