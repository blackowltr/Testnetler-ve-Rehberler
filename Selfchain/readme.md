# Selfchain Node Installation Guide

![image](https://github.com/brsbrc/Testnetler-ve-Rehberler/assets/107190154/8afb86d4-79a2-4a88-92da-16edadd067e6)

In this guide, you will find the necessary steps to install a Selfchain Node. Each step includes explanations and commands. Remember to customize it with your own moniker and specific settings when needed.

## 1. Installing Required Tools

Update your system and install the necessary tools:

```bash
sudo apt update
sudo apt-get install git curl build-essential make jq gcc snapd chrony lz4 tmux unzip bc -y
```

## 2. Installing the Go Language

Go language is required for the Selfchain node to run. Follow these steps:

```bash
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
```

## 3. Downloading and Installing the Selfchain Node

Download and install the Selfchain node:

```bash
cd $HOME
mkdir -p /root/go/bin/
wget https://ss-t.self.nodestake.top/selfchaind
chmod +x selfchaind
mv selfchaind /root/go/bin/
selfchaind version
```

## 4. Initializing Your Node

Before starting your node, choose a node name (NODENAME) and run the following:

```bash
# Set your node name (NODENAME) and initialize the node
NODENAME="your_node_name"
selfchaind init "$NODENAME" --chain-id=self-dev-1
```

## 5. Downloading the Genesis and Addrbook Files

Download the Genesis and Addrbook files:

```bash
curl -Ls https://ss-t.self.nodestake.top/genesis.json > $HOME/.selfchain/config/genesis.json 
curl -Ls https://ss-t.self.nodestake.top/addrbook.json > $HOME/.selfchain/config/addrbook.json 
```

## 6. Configuring Seed and Peer Settings

Configure seed and peer settings:

```bash
PEERS="bae21418b80df93ab49f3cd612989dd1d739bdda@167.235.132.251:26656,c66b609d52cd9b4062520ef5eff1081db1ddca85@5.75.178.181:26656,5f180263bec701b722b750b9fa63ee95969e5d02@65.109.238.88:26656,7b972e7dc4e5fd1225c94f9f8f146c321fb0d380@5.75.159.86:26656,342702c9800ae15c46d40d24e7f6d209a60a9cf7@116.203.59.248:26656,88ffe6a82f9f5425c7484d3659130db88b0907a5@38.242.230.118:57656,59b50622fedb264ba4871b48c42ef21b518566da@141.94.18.48:26656,c244ea9c8d45923b00439617324552eaf20efd3e@5.9.61.78:33656,e50e9d1ad731164a54a403bd6bafda11ba13b749@170.64.141.15:26656,ca4b6131d616d4d5930e50f1f557950f17fe4091@188.166.218.244:26656,2425d2ba5f493a10d4decd0fb42ef47dc13efec2@206.189.206.88:26656" 
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.selfchain/config/config.toml
```

## 7. Configuring Minimum Gas Price and Prometheus Settings

Configure minimum gas price and Prometheus settings:

```bash
sed -i 's/minimum-gas-prices =.*/minimum-gas-prices = "0.025uself"/g' $HOME/.selfchain/config/app.toml
sed -i 's|^prometheus *=.*|prometheus = true|' $HOME/.selfchain/config/config.toml
```

## 8. Creating a Service

Create a systemd service for your node:

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
sudo systemctl daemon-reload
sudo systemctl enable selfchaind
sudo systemctl start selfchaind
```

## 9. Optional - Downloading a State Sync

Optionally, you can download a state sync:

```bash
sudo systemctl stop selfchaind
selfchaind tendermint unsafe-reset-all --home ~/.selfchain/ --keep-addr-book

SNAP_RPC="https://rpc-t.self.nodestake.top:443"
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 1000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)
echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" ~/.selfchain/config/config.toml
more ~/.selfchain/config/config.toml | grep 'rpc_servers'
more ~/.selfchain/config/config.toml | grep 'trust_height'
more ~/.selfchain/config/config.toml | grep 'trust_hash'

sudo systemctl restart selfchaind
journalctl -u selfchaind -f
```

## Warning: Port Issue

If you encounter an "already in use..." error, it indicates a port problem. In such cases, you need to change the port configurations to resolve this issue. Here's an example command to change the ports:

Please note that you can use this command if the ports mentioned are different from the ones you are using.

```bash
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:28658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:28657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:6260\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:28656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":28660\"%" $HOME/.selfchain/config/config.toml && sed -i.bak -e "s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:9290\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:9291\"%; s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:1517\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:8745\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:8746\"%; s%^address = \"127.0.0.1:8545\"%address = \"127.0.0.1:8745\"%; s%^ws-address = \"127.0.0.1:8546\"%ws-address = \"127.0.0.1:8746\"%" $HOME/.selfchain/config/app.toml && sed -i.bak -e "s%^node = \"tcp://localhost:26657\"%node = \"tcp://localhost:28657\"%" $HOME/.selfchain/config/client.toml
sudo systemctl restart selfchaind
journalctl -u selfchaind -f
```

Make sure to adjust the port values as needed, and this will help you resolve the port problem.

## 10. Follow for Updates

- Follow for updates on Twitter: [Twitter](https://twitter.com/brsbtc)
- Connect with us on Discord: blackowl


This guide provides step-by-step instructions for setting up your Selfchain Node on your system. Be sure to replace NODENAME with your chosen moniker and add the appropriate peer information as needed.

# Generating Keys and Setting Up Validator

In this section, we'll guide you through the process of generating keys and setting up your validator on the Selfchain network.

### 1. Generate Your Keys

First, you need to generate the necessary keys. Replace `KEYNAME` with your preferred key name:

```bash
selfchaind keys --home ~/.selfchain --keyring-backend file --keyring-dir keys add KEYNAME
```

### 2. Check Sync Status

To ensure that your node is synchronized with the network, use the following command:

```bash
selfchaind status
```

- If you see `"catching_up": false`, it means your node is synchronized and ready.
- If it shows `"catching_up": true`, please be patient and wait until synchronization is complete.

### 3. Create Validator

Once your node has achieved synchronization and your faucet operation has been successful, you can proceed with the creation of your validator by executing the following command:

```bash
selfchaind tx staking create-validator \
--amount=100000000uself \
--pubkey=$(selfchaind tendermint show-validator) \
--moniker="Your Node Name" \
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

Replace the following placeholders:
- `Your Node Name`: Choose a name for your node.
- `your_wallet_address`: Replace with your wallet address.

### 4. Stake More Tokens (Optional)

If you wish to add more tokens to stake for your node, simply use this command:

```bash
selfchaind tx staking delegate $(selfchaind keys show YOUR_WALLET_ADDRESS --bech val -a) 1000000uself --from YOUR_WALLET_ADDRESS --chain-id self-dev-1 --gas-adjustment 1.2 --fees 1000uself -y
```

Replace 'YOUR_WALLET_ADDRESS' with your own wallet address, and change the amount as required.

By following these simple steps, you'll be well on your way to generating your keys, creating a validator for your Selfchain node, and staking tokens to support the network.

This guide has been designed to provide you with a clear and straightforward set of instructions for setting up your Selfchain node. Please take your time to go through each step carefully.

### 5. Removing Your Selfchain Node
```bash
sudo systemctl stop selfchaind && rm -rf ~/.selfchain /etc/systemd/system/selfchaind.service && sudo systemctl disable selfchaind && sudo systemctl daemon-reload
```

-BlackOwl
