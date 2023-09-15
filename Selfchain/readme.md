# Selfchain Node Installation Guide

![image](https://github.com/brsbrc/Testnetler-ve-Rehberler/assets/107190154/8afb86d4-79a2-4a88-92da-16edadd067e6)

## Step 1: Update the System

```bash
sudo apt update
sudo apt-get install git curl build-essential make jq gcc snapd chrony lz4 tmux unzip bc -y
```

## Step 2: Install Go

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

## Step 3: Install Node

```bash
cd $HOME
mkdir -p /root/go/bin/
wget https://ss-t.self.nodestake.top/selfchaind
chmod +x selfchaind
mv selfchaind /root/go/bin/
```

## Step 4: Initialize Node
>*NODENAME
```bash
selfchaind init *NODENAME --chain-id=self-dev-1
```

### Download Genesis

```bash
curl -Ls https://raw.githubusercontent.com/brsbrc/Testnetler-ve-Rehberler/main/Selfchain/genesis.json > $HOME/.selfchain/config/genesis.json 
```

### Download addrbook

```bash
curl -Ls https://raw.githubusercontent.com/brsbrc/Testnetler-ve-Rehberler/main/Selfchain/addrbook.json > $HOME/.selfchain/config/addrbook.json
```

### Create Service

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

## Snapshot 
```
SNAP_NAME=$(curl -s https://ss-t.self.nodestake.top/ | egrep -o ">20.*\.tar.lz4" | tr -d ">")

curl -o - -L https://ss-t.self.nodestake.top/${SNAP_NAME}  | lz4 -c -d - | tar -x -C $HOME/.selfchain
sudo systemctl restart selfchaind
journalctl -u selfchaind -f
```

### Check Sync Status

```bash
journalctl -u selfchaind -f
```

## Step 5: Create the Keys

Replace `<key_name>` with your node name. For example, `<key_name> = BlackOwl`.

```bash
selfchaind keys --home ~/.selfchain --keyring-backend file --keyring-dir keys add <key_name>
```

The wallet address will start with "self…". Keep it for the next steps, for example: `self168ehkjdsfıuh90sdjfksdjkf9jkmsdıuus9`.

## Step 6: Modify the Denomination and Minimum Gas

Edit the `~/.selfchain/config/app.toml` file and make the following changes:

Change:

```
"0stake" —> "0.005uself"
```

Change:

```
"uatom" —> "uself"
```

## Step 7: Modify the Config.toml File

Edit the `.selfchain/config/config.toml` file and change:

```
laddr = "tcp://0.0.0.0:26657"
```

## Step 8: Stop and Restart the Node

```bash
sudo systemctl stop selfchaind
sudo systemctl restart selfchaind
```

Check the sync status:

```bash
selfchaind status
```

Once you see "catching_up":false, that means the node is synced. If it's true, then wait until the node is synced.

## Step 9: Go to Discord and Faucet

Create Validator:

After the node is synced and the faucet is successful, you need to execute the following transaction to create the validator.

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
