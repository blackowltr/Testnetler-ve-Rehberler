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

# Prompt the user to enter the node name and key name
read -p $'\e[1;32mEnter your desired node name (NODENAME):\e[0m ' NODENAME
read -p $'\e[1;32mEnter your desired key name (KEYNAME):\e[0m ' KEYNAME

# Display the node name and key name entered by the user
echo -e $'\e[1;36mNode name:\e[0m '$NODENAME
echo -e $'\e[1;36mKey name:\e[0m '$KEYNAME
echo -e $'\e[1;32mThese values will be used for the installation.\e[0m'

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
selfchaind init $NODENAME --chain-id=self-dev-1
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
PEERS="fda47662b03b41799e58499fac0afbaf68c02a1f@174.138.180.190:61256,6eb3bcbfcdec87430f720d8946d79626c06ca21a@65.109.116.50:26656,..."  # Add all your peer information here
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

# Check if the Selfchain Node started successfully
if sudo systemctl is-active --quiet selfchaind; then
  echo -e $'\e[1;32mSelfchain Node has been successfully installed and started!\e[0m'
else
  echo -e $'\e[1;31mSelfchain Node installation or startup encountered an error.\e[0m'
fi

# Backing up priv.validator.key.json to the home directory.
cp $HOME/.selfchain/config/priv.validator.key.json $HOME/priv.validator.key.json.bak
sleep 2

# Follow me on Twitter for updates: https://twitter.com/brsbtc
echo "For updates and more information, follow me on Twitter: https://twitter.com/brsbtc"

# Connect with me on Discord: BlackOwl#1234
echo "Connect with me on Discord: blackowl"
