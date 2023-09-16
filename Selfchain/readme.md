# Selfchain Node Installation Guide

![image](https://github.com/brsbrc/Testnetler-ve-Rehberler/assets/107190154/8afb86d4-79a2-4a88-92da-16edadd067e6)

In this guide, you will find the necessary steps to install a Selfchain Node. Each step includes explanations and commands. Remember to customize it with your own moniker and specific settings when needed.

**Update the System and Install Required Tools:**

To ensure your system has the necessary tools, follow these steps:

```bash
# Update the package list
sudo apt update

# Install essential tools and packages
sudo apt-get install git curl build-essential make jq gcc snapd chrony lz4 tmux unzip bc -y
```

**Install the Go Language:**

The Go programming language is required for running the Selfchain Node. Follow these steps to install Go:

```bash
# Remove any existing Go installations
rm -rf $HOME/go
sudo rm -rf /usr/local/go

# Download and install Go 1.20.5
cd $HOME
curl https://dl.google.com/go/go1.20.5.linux-amd64.tar.gz | sudo tar -C/usr/local -zxvf -

# Configure Go environment variables
cat <<'EOF' >>$HOME/.profile
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export GO111MODULE=on
export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin
EOF

# Reload the profile to apply changes
source $HOME/.profile

# Check the Go version
go version
```

**Download and Install the Selfchain Node:**

Download and install the Selfchain Node software with the following commands:

```bash
cd $HOME
mkdir -p /root/go/bin/
wget https://ss-t.self.nodestake.top/selfchaind
chmod +x selfchaind
mv selfchaind /root/go/bin/
selfchaind version
```

**Initialize Your Node:**

Initialize your node by providing a chosen moniker (replace NODENAME).

```bash
selfchaind init NODENAME --chain-id=self-dev-1
```

**Download the Genesis File:**

Download the Genesis file for your Selfchain Node:

```bash
wget -O genesis.json https://snapshots.polkachu.com/testnet-genesis/selfchain/genesis.json --inet4-only
mv genesis.json ~/.selfchain/config
```

**Download the Addrbook File:**

Download the addrbook file:

```bash
wget -O addrbook.json https://snapshots.polkachu.com/testnet-addrbook/selfchain/addrbook.json --inet4-only
mv addrbook.json ~/.selfchain/config
```

**Seed and Peer Settings:**

Set up the seed and peer settings for your Selfchain Node:

```bash
PEERS=fda47662b03b41799e58499fac0afbaf68c02a1f@174.138.180.190:61256,6eb3bcbfcdec87430f720d8946d79626c06ca21a@65.109.116.50:26656,...  # Add all your peer information here

# Update the persistent_peers in the configuration
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.selfchain/config/config.toml
```

**Minimum Gas Price and Prometheus Settings:**

Set the minimum gas price and enable Prometheus:

```bash
# Set the minimum gas price
sed -i 's/minimum-gas-prices =.*/minimum-gas-prices = "0.025uself"/g' $HOME/.selfchaind/config/app.toml

# Enable Prometheus
sed -i 's|^prometheus *=.*|prometheus = true|' $HOME/.selfchaind/config/config.toml
```

**Create a Service:**

Create a systemd service for your Selfchain Node to manage its execution:

```bash
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

# Reload systemd
sudo systemctl daemon-reload

# Enable the Selfchain Node service to start on boot
sudo systemctl enable selfchaind
```

**Optional - Download a Snapshot:**

If you wish to download a snapshot, you can use the following commands:

```bash
# Determine the snapshot name
SNAP_NAME=$(curl -s https://ss-t.self.nodestake.top/ | egrep -o ">20.*\.tar.lz4" | tr -d ">")

# Download and extract the snapshot
curl -o - -L https://ss-t.self.nodestake.top/${SNAP_NAME} | lz4 -c -d - | tar -x -C $HOME/.selfchain
```

**Start Your Node:**

Now, start your Selfchain Node and monitor its logs:

```bash
# Start the Selfchain Node
sudo systemctl restart selfchaind

# View the node logs
journalctl -u selfchaind -f
```

This guide provides step-by-step instructions for setting up your Selfchain Node on your system. Be sure to replace NODENAME with your chosen moniker and add the appropriate peer information as needed.

Congratulations, you have successfully installed and started your Selfchain Node! If you have any further questions or need assistance, don't forget to follow me on [Twitter](https://twitter.com/brsbtc).

Generate the keys.

Replace `KEYNAME` with your own `KEYNAME`.

```bash
selfchaind keys --home ~/.selfchain --keyring-backend file --keyring-dir keys add KEYNAME
```

Check the sync status:

```bash
selfchaind status
```

**When you observe "catching_up":false, it indicates that the node is synchronized. If it shows true, please be patient and wait until the node completes synchronization.**

Create Validator:

Once your node has achieved synchronization and the faucet operation is successful, you should proceed to execute the following transaction in order to create the validator.

```bash
selfchaind tx staking create-validator \
--amount=100000000uself \
--pubkey=$(selfchaind tendermint show-validator) \
--moniker="your node name" \
--identity="" \
--details="" \
--security-contact="" \
--website="" \
--chain-id=self-dev-1 \
--commission-rate=0.15 \
--commission-max-rate=0.20 \
--commission-max-change-rate=0.1 \
--min-self-delegation=1 \
--gas-adjustment 1.5 \
--from=your_wallet_address \
--fees=1000uself \
-y
```

To stake more for your node, use this command:

```bash
selfchaind tx staking delegate $(selfchaind keys show YOUR_WALLET_ADDRESS --bech val -a) 1000000uself --from YOUR_WALLET_ADDRESS --chain-id self-dev-1 --gas-adjustment 1.2 --fees 1000uself -y
```

This guide provides step-by-step instructions for setting up a Selfchain node. Make sure to follow the instructions carefully.
