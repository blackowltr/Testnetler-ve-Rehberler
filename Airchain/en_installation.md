# Airchains Installation Guide

![Space-x](https://github.com/user-attachments/assets/c80e8e43-3435-4886-84cf-f042b26b9625)

## 1. Installing Necessary Packages

First, you need to install the necessary packages on your system. Use the following commands to update and install the required packages.

```bash
apt update && apt upgrade -y
apt install curl build-essential pkg-config libssl-dev git wget jq make gcc chrony -y
```

## 2. Installing Go

The Go programming language is required to run Airchains. You can install Go with the following commands.

```bash
ver="1.22.2" && \
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz" && \
rm -rf /usr/local/go && \
tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz" && \
rm "go$ver.linux-amd64.tar.gz" && \
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> $HOME/.bash_profile && \
source $HOME/.bash_profile
```

## 3. Cloning Required Repositories

We need to clone the Airchains and Tracks repositories.

```bash
git clone https://github.com/airchains-network/evm-station.git
git clone https://github.com/airchains-network/tracks.git
```

## 4. Installing EVM Station

Navigate to the EVM Station directory and install the necessary dependencies.

```bash
cd evm-station
go mod tidy
```
```bash
/bin/bash ./scripts/local-setup.sh
```
```bash
/bin/bash ./scripts/local-start.sh
```

After running the above commands, stop the process by pressing CTRL + C.

## 5. Creating the Systemd Service File

Create a systemd service file for EVM Station.

```bash
tee /etc/systemd/system/evmosd.service > /dev/null <<EOF
[Unit]
Description=evmosd node
After=network-online.target
[Service]
User=$USER
WorkingDirectory=$HOME/.evmosd
ExecStart=/root/evm-station/build/station-evm start \
--metrics "" \
--log_level "info" \
--json-rpc.api eth,txpool,personal,net,debug,web3 \
--chain-id "stationevm_1234-1"
Restart=on-failure
RestartSec=5
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF
```

Start and enable the service.

```bash
systemctl daemon-reload && \
systemctl enable evmosd && \
systemctl restart evmosd
```

Check the logs.

```bash
journalctl -u evmosd -fo cat
```

## 6. Editing the Configuration File

Edit the `/root/.evmosd/config/app.toml` file with the following commands. This will set the necessary configurations.

```bash
sed -i 's/address = "127.0.0.1:8545"/address = "0.0.0.0:8545"/' /root/.evmosd/config/app.toml
sed -i 's/ws-address = "127.0.0.1:8546"/ws-address = "0.0.0.0:8546"/' /root/.evmosd/config/app.toml
```

## 7. Installing Tracks

Navigate to the Tracks directory and perform the necessary steps.

```bash
cd $HOME/tracks
screen -S track
```

```bash
make build
go mod tidy
```

For mock installation, use the following command. Installation with Eigen requires different codes and a da-key.

```bash
go run cmd/main.go init --daRpc "mock-rpc" --daKey "Mock-Key" --daType "mock" --moniker "ENTERMONIKER" --stationRpc "http://127.0.0.1:8545" --stationAPI "http://127.0.0.1:8545" --stationType "evm"
```

Only change the ENTERMONIKER part.

## 8. Creating an Account and Mnemonic 

```bash
go run cmd/main.go keys junction --accountName wallet --accountPath $HOME/.tracks/junction-accounts/keys
```

Save the mnemonics. You can obtain air tokens in your air wallet via faucet or by sending.

```bash
go run cmd/main.go prover v1EVM
```

Just enter your wallet address and then run the entire command in the terminal.
```bash
WALLET="enterwalletaddress" && \
IP=$(wget -qO- eth0.me) && \
ID=$(grep 'node_id' /root/.tracks/config/sequencer.toml | awk -F ' = ' '{gsub(/"/, "", $2); print $2}')
```

> You can directly enter the following command without modification as we have assigned variables.

```bash
go run cmd/main.go create-station --accountName wallet --accountPath $HOME/.tracks/junction-accounts/keys --jsonRPC "https://junction-testnet-rpc.synergynodes.com/" --info "EVM Track" --tracks $WALLET --bootstrapNode "/ip4/$IP/tcp/2300/p2p/$ID"
```

```
git pull
```
```
make build
```

## 9. Creating the Systemd Service File

Create a systemd service file for Tracks.

```bash
tee /etc/systemd/system/tracksd.service > /dev/null <<EOF
[Unit]
Description=tracksd node
After=network-online.target
StartLimitIntervalSec=0
StartLimitBurst=0

[Service]
User=root
WorkingDirectory=/root/.tracks
ExecStart=/root/tracks/build/tracks start

Restart=always
RestartSec=10
LimitNOFILE=65535
SuccessExitStatus=0 1 2 3

[Install]
WantedBy=multi-user.target
EOF
```

Start and enable the service.

```bash
systemctl daemon-reload && \
systemctl enable tracksd && \
systemctl restart tracksd
```

Check the logs.

```bash
journalctl -fu tracksd -o cat
```

## 10. Installing Node.js and Required Modules
> Your Node.js version should be v20.X.X.

Install Node.js and the required modules.

```bash
cd
curl -sL https://deb.nodesource.com/setup_20.x | sudo -E bash -
apt-get install -y nodejs
apt install nodejs npm
npm install web3@1.5.3
```

### For those experiencing Node.js errors, follow these steps first:
```bash
nvm ls
```
The above command will show you the existing versions. Under the default section, you will likely see version 18. To change the default version, write the highest version you have. For example, 22.4.0.
```bash
nvm use v22.4.0
```
If the error persists, you can move on to the following solution.

### For those experiencing Node.js errors, use these commands:
```bash
apt-get purge nodejs npm
apt-get autoremove --purge
rm -rf /usr/local/lib/node_modules
rm -rf /usr/local/bin/npm
rm -rf /usr/local/share/man/man1/node.1.gz
```
### Reinstallation
```
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
apt-get install -y nodejs
apt install nodejs npm
npm install web3@1.5.3
```
### Check the version.
```
nodejs --version
```
NOTE: Your version should be v20.X.X.
---

## 11. Running Airchains Scripts

Download and run the necessary scripts. First, run the 20.sh script.

```bash
chmod +x 20.sh && ./20.sh
```

It will create 20 wallets and send tokens at the end, giving you the keys. Save the keys.

To check the balance, run the following script.

```bash
chmod +x balance.sh && ./balance.sh
```

To send transactions to 20 wallets, run the 20.js script.

```bash
screen -S 20
```
```bash
chmod +x 20.js && node 20.js
```

Here, transactions will be sent to 20 wallets. You need to specify the private key of the 20 wallets, the target address, the amount, and the duration. If the transactions are successful (i.e., success), you can exit with CTRL + A, D.
> The target wallet can be any of your EVM wallets.
> The amount of tevmos can be 0.001 or 0.002.
> You need to set the duration to 15 seconds.

## 12. Setting Up Restart Scripts

Set up the restart scripts.

```bash
chmod +x check_tracksd.sh rpc.sh nilvrf.sh vrf.sh initvrf.sh transvrf.sh
```

You can enter the commands all at once.

```shell
(crontab -l 2>/dev/null; echo "*/3 * * * * /root/check_tracksd.sh >> /root/tracksd_check.txt 2>&1") | crontab -
(crontab -l 2>/dev/null; echo "*/3 * * * * /root/rpc.sh") | crontab -
(crontab -l 2>/dev/null; echo "*/3 * * * * /root/vrf.sh") | crontab -
(crontab -l 2>/dev/null; echo "*/3 * * * * /

root/initvrf.sh") | crontab -
(crontab -l 2>/dev/null; echo "*/3 * * * * /root/nilvrf.sh") | crontab -
(crontab -l 2>/dev/null; echo "*/3 * * * * /root/transvrf.sh") | crontab -
service cron start
```
## 13. Rollback Procedures

If the restart scripts do not solve the problem, you need to perform a rollback.

```bash
service cron stop && systemctl stop tracksd
```

Navigate to the Tracks directory, pull updates, and rebuild.

```bash
cd tracks
git pull
make build
```

Run the following command 5-6 times.

```bash
go run cmd/main.go rollback
```

Finally, restart the service and activate cron.

```bash
systemctl restart tracksd && service cron start
```

Check the logs.

```bash
journalctl -u tracksd -f --no-hostname -o cat
```
## 13a. Automatic Rollback (performs rollback every 6 hours)

Alternatively, download the rollback.sh file here and give it execute permission.

```bash
chmod +x rollback.sh
```

Then add the following lines to the end of the crontab file:

```bash
(crontab -l 2>/dev/null; echo "0 */6 * * * /root/rollback.sh") | crontab -

service cron restart
```

> If you want to run it manually:
```bash
cd $HOME
./rollback.sh
```

### Changing RPC

```shell
RPC="enterrpc"
sed -i "s|JunctionRPC = \".*\"|JunctionRPC = \"$RPC\"|" ~/.tracks/config/sequencer.toml
systemctl restart tracksd
```

#### RPCs you can use:
```
- https://airchains-rpc.sbgid.com/
- https://junction-testnet-rpc.nodesync.top/
- https://airchains.rpc.t.stavr.tech/
- https://airchains-testnet-rpc.corenode.info/
- https://airchains-testnet-rpc.spacestake.tech/
- https://airchains-rpc.chainad.org/
- https://rpc.airchains.stakeup.tech/
- https://airchains-testnet-rpc.spacestake.tech/
- https://airchains-testnet-rpc.stakerhouse.com/
- https://airchains-rpc.tws.im/
- https://junction-testnet-rpc.synergynodes.com/
- https://airchains-testnet-rpc.nodesrun.xyz/
- https://t-airchains.rpc.utsa.tech/
- https://airchains-testnet.rpc.stakevillage.net/
- https://airchains-rpc.elessarnodes.xyz/
- https://rpc.airchains.aknodes.net
- https://rpcair.aznope.com/
- https://rpc1.airchains.t.cosmostaking.com/
- https://rpc.nodejumper.io/airchainstestnet
- https://airchains-testnet-rpc.staketab.org
- https://junction-rpc.kzvn.xyz/
- https://airchains-testnet-rpc.zulnaaa.com/
- https://airchains-testnet-rpc.suntzu.dev/
- https://airchains-testnet-rpc.nodesphere.net/
- https://junction-rpc.validatorvn.com/
- https://rpc-testnet-airchains.nodeist.net/
- https://airchains-rpc.kubenode.xyz/
- https://airchains-testnet-rpc.cosmonautstakes.com/
- https://airchains-testnet-rpc.itrocket.net/
```

## If you want to delete everything and start over
```bash
systemctl stop tracksd.service && \
systemctl disable tracksd.service && \
rm /etc/systemd/system/tracksd.service && \
systemctl stop evmosd.service && \
systemctl disable evmosd.service && \
rm /etc/systemd/system/evmosd.service && \
rm privkey_* && \
rm -rf evm-station .evmosd .tracks tracks 
```
