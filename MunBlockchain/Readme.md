

```
sudo apt update
sudo apt upgrade -y
sudo apt install build-essential jq -y
```
```
wget -q -O - https://raw.githubusercontent.com/canha/golang-tools-install-script/master/goinstall.sh | bash -s -- --version 1.18
source ~/.profile
```
```
go version
```

```
git clone https://github.com/munblockchain/mun
cd mun
```

```
sudo rm -rf ~/.mun
go mod tidy
make install

clear

mkdir -p ~/.mun/upgrade_manager/upgrades
mkdir -p ~/.mun/upgrade_manager/genesis/bin
```

```
cp $(which mund) ~/.mun/upgrade_manager/genesis/bin
sudo cp $(which mund-manager) /usr/bin
```

```
mund init [moniker_name] --chain-id testmun
```

```
mund keys add [wallet_name] --keyring-backend test
```

```
curl --tlsv1 https://node1.mun.money/genesis? | jq ".result.genesis" > ~/.mun/config/genesis.json
```

```
nano ~/.mun/config/config.toml
seeds = "6a08f2f76baed249d3e3c666aaef5884e4b1005c@167.71.0.38:26656"
```

```
sed -i 's/stake/utmun/g' ~/.mun/config/genesis.json
```

```
sudo nano /etc/systemd/system/mund.service
```

```
[Unit]
Description=mund
Requires=network-online.target
After=network-online.target

[Service]
Restart=on-failure
RestartSec=3
User=root
Group=root
Environment=DAEMON_NAME=mund
Environment=DAEMON_HOME=/root/.mun
Environment=DAEMON_ALLOW_DOWNLOAD_BINARIES=on
Environment=DAEMON_RESTART_AFTER_UPGRADE=on
PermissionsStartOnly=true
ExecStart=/usr/bin/mund-manager start --pruning="nothing" --rpc.laddr "tcp://0.0.0.0:26657"
StandardOutput=file:/var/log/mund/mund.log
StandardError=file:/var/log/mund/mund_error.log
ExecReload=/bin/kill -HUP $MAINPID
KillSignal=SIGTERM
LimitNOFILE=4096

[Install]
WantedBy=multi-user.target
```

```
whoami
```

```
cd ~/.mun
pwd
```

```
make log-files

sudo systemctl enable mund
sudo systemctl start mund
```

```
mund status
```


mund tx staking create-validator --from cüzdanismi --moniker nodeismi --pubkey $(mund tendermint show-validator) --chain-id testmun --keyring-backend test --amount 50000000000utmun --commission-max-change-rate 0.01 --commission-max-rate 0.2 --commission-rate 0.1 --min-self-delegation 1 --fees 200000utmun --gas auto --gas=auto --gas-adjustment=1.5 -y
