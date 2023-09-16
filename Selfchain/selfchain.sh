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
echo -e '\e[40m\e[97m\e[1m  🦉 BlackOwl 🦉  \e[0m'

# Prompt the user to enter NODENAME and KEYNAME
read -p "Enter your desired node name (NODENAME): " NODENAME
read -p "Enter your desired key name (KEYNAME): " KEYNAME

# Display the entered NODENAME and KEYNAME
echo "You entered NODENAME: $NODENAME"
echo "You entered KEYNAME: $KEYNAME"
echo "These values will be used for the installation."

# Update the System and Install Required Tools
sudo apt update
sudo apt-get install git curl build-essential make jq gcc snapd chrony lz4 tmux unzip bc -y
sleep 2

# Install the Go Language
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
sleep 2

# Download and Install the Selfchain Node
cd $HOME
mkdir -p /root/go/bin/
wget https://ss-t.self.nodestake.top/selfchaind
chmod +x selfchaind
mv selfchaind /root/go/bin/
selfchaind version
sleep 2

# Initialize Your Node
selfchaind init $NODENAME --chain-id=self-dev-1
sleep 2

# Download the Genesis File
wget -O genesis.json https://snapshots.polkachu.com/testnet-genesis/selfchain/genesis.json --inet4-only
mv genesis.json ~/.selfchain/config
sleep 2

# Download the Addrbook File
wget -O addrbook.json https://snapshots.polkachu.com/testnet-addrbook/selfchain/addrbook.json --inet4-only
mv addrbook.json ~/.selfchain/config
sleep 2

# Seed and Peer Settings
PEERS="fda47662b03b41799e58499fac0afbaf68c02a1f@174.138.180.190:61256,6eb3bcbfcdec87430f720d8946d79626c06ca21a@65.109.116.50:26656,..."  # Add all your peer information here
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.selfchain/config/config.toml
sleep 2

# Minimum Gas Price and Prometheus Settings
sed -i 's/minimum-gas-prices =.*/minimum-gas-prices = "0.025uself"/g' $HOME/.selfchaind/config/app.toml
sed -i 's|^prometheus *=.*|prometheus = true|' $HOME/.selfchaind/config/config.toml
sleep 2

# Create a Service
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
SNAP_NAME=$(curl -s https://ss-t.self.nodestake.top/ | egrep -o ">20.*\.tar.lz4" | tr -d ">")
curl -o - -L https://ss-t.self.nodestake.top/${SNAP_NAME} | lz4 -c -d - | tar -x -C $HOME/.selfchain
sleep 2

# Start Your Node
sudo systemctl restart selfchaind

# Check if the Selfchain Node started successfully
if journalctl -u selfchaind -f | grep -q "exit code"; then
  echo "Selfchain Node installation or startup encountered an error."
else
  echo "Selfchain Node has been successfully installed and started!"
fi

# Backing up priv.validator.key.json to the home directory.
cp $HOME/.selfchain/config/priv.validator.key.json $HOME/priv.validator.key.json.bak
sleep 2

# Create a wallet password
read -s -p "Create a wallet password: " WALLET_PASSWORD
echo ""
sleep 2
# Save the wallet password to a text file
echo "$WALLET_PASSWORD" > walletinfo.txt

selfchaind keys --home ~/.selfchain --keyring-backend file --keyring-dir keys add $KEYNAME

# Follow me on Twitter for updates: https://twitter.com/brsbtc
echo "For updates and more information, follow me on Twitter: https://twitter.com/brsbtc"

# Connect with me on Discord: BlackOwl#1234
echo "Connect with me on Discord: blackowl"
