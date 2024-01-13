# Useful Commands

# Key Management
## Add New Key
```
artelad keys add wallet
```
## Recover Existing Key
```
artelad keys add wallet --recover
```
## List All Keys
```
artelad keys list
```
## Delete Key
```
artelad keys delete wallet
```
## Export Key (save to wallet.backup)
```
artelad keys export wallet
```
## Import Key
```
artelad keys import wallet wallet.backup
```
## Query Wallet Balance
```
artelad q bank balances $(artelad keys show wallet -a)
```
# Validator Operations
## Create New Validator
```
artelad tx staking create-validator \
--amount=1000000uart \
--pubkey=$(artelad tendermint show-validator) \
--moniker="YourMonikerName" \
--identity=YOUR_IDENTITY \ #Optional
--details="YOUR_DETAILS" \ #Optional
--chain-id=artela_11822-1 \
--commission-rate=0.10 \
--commission-max-rate=0.20 \
--commission-max-change-rate=0.01 \
--min-self-delegation=1 \
--from=YOURWALLETNAME \
--gas-prices=0.1uart \
--gas-adjustment=1.5 \
--gas=auto \
-y
```
## Edit Existing Validator
```
artelad tx staking edit-validator \
--new-moniker="YourMonikerName" \
--chain-id=artela_11822-1 \
--commission-rate=0.1 \
--from=YOURWALLETNAME \
--gas-prices=0.1uart \
--gas-adjustment=1.5 \
--gas=auto \
-y
```
## Unjail Validator
```
artelad tx slashing unjail --from wallet --chain-id artela_11822-1 --gas-prices 0.1uart --gas-adjustment 1.5 --gas auto -y
```
## Signing Info
```
artelad query slashing signing-info $(artelad tendermint show-validator)
```
## List All Active Validators
```
artelad q staking validators -oj --limit=3000 | jq '.validators[] | select(.status=="BOND_STATUS_BONDED")' | jq -r '(.tokens|tonumber/pow(10; 6)|floor|tostring) + " \t " + .description.moniker' | sort -gr | nl
```
## List All Inactive Validators
```
artelad q staking validators -oj --limit=3000 | jq '.validators[] | select(.status=="BOND_STATUS_UNBONDED") or .status=="BOND_STATUS_UNBONDING")' | jq -r '(.tokens|tonumber/pow(10; 6)|floor|tostring) + " \t " + .description.moniker' | sort -gr | nl
```
## View Validator Details
```
artelad q staking validator $(artelad keys show wallet --bech val -a)
```
# Staking and Delegation
## Withdraw Rewards From All Validators
```
artelad tx distribution withdraw-all-rewards --from wallet --chain-id artela_11822-1 --gas-prices 0.1uart --gas-adjustment 1.5 --gas auto -y
```
## Withdraw Commission And Rewards From Your Validator
```
artelad tx distribution withdraw-rewards $(artelad keys show wallet --bech val -a) --commission --from wallet --chain-id artela_11822-1 --gas-prices 0.1uart --gas-adjustment 1.5 --gas auto -y
```
## Delegate to yourself
```
artelad tx staking delegate $(artelad keys show wallet --bech val -a) 1000000uart --from wallet --chain-id artela_11822-1 --gas-prices 0.1uart --gas-adjustment 1.5 --gas auto -y
```
## Delegate
```
artelad tx staking delegate YOUR_TO_VALOPER_ADDRESS 1000000uart --from wallet --chain-id artela_11822-1 --gas-prices 0.1uart --gas-adjustment 1.5 --gas auto -y
```
## Redelegate
```
artelad tx staking redelegate $(artelad keys show wallet --bech val -a) YOUR_TO_VALOPER_ADDRESS 1000000uart --from wallet --chain-id artela_11822-1 --gas-prices 0.1uart --gas-adjustment 1.5 --gas auto -y
```
## Unbond
```
artelad tx staking unbond $(artelad keys show wallet --bech val -a) 1000000uart --from wallet --chain-id artela_11822-1 --gas-prices 0.1uart --gas-adjustment 1.5 --gas auto -y
```
# Transactions and Bank Operations
## Send
```
artelad tx bank send wallet YOUR_TO_WALLET_ADDRESS 1000000uart --from wallet --chain-id artela_11822-1 --gas-prices 0.1uart --gas-adjustment 1.5 --gas auto -y
```
# Governance Operations
## Create New Text Proposal
```
artelad tx gov submit-proposal \
--title="Title" \
--description="Description" \
--deposit=1000000uart \
--type="Text" \
--from=wallet \
--gas-prices=0.1uart \
--gas-adjustment=1.5 \
--gas=auto \
-y
```
## List All Proposals
```
artelad query gov proposals
```
## View Proposal By ID
```
artelad query gov proposal 1
```
## Vote YES
```
artelad tx gov vote 1 yes --from wallet --chain-id artela_11822-1 --gas-prices 0.1uart --gas-adjustment 1.5 --gas auto -y
```
## Vote NO
```
artelad tx gov vote 1 no --from wallet --chain-id artela_11822-1 --gas-prices 0.1uart --gas-adjustment 1.5 --gas auto -y
```
## Vote NO_WITH_VETO
```
artelad tx gov vote 1 no_with_veto --from wallet --chain-id artela_11822-1 --gas-prices 0.1uart --gas-adjustment 1.5 --gas auto -y
```
## Vote ABSTAIN
```
artelad tx gov vote 1 abstain --from wallet --chain-id artela_11822-1 --gas-prices 0.1uart --gas-adjustment 1.5 --gas auto -y
```
## Query Transaction
```
artelad query tx YOUR_TX_ID
```
# Query and Utility Commands
## Change Default Ports
### Update gRPC and Web gRPC ports
```
sed -i.bak -e "s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:9090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:9091\"%" $HOME/.artelad/config/app.toml
```
### Update proxy_app, laddr, and pprof_laddr ports
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:26658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:26657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:6060\"%" $HOME/.artelad/config/config.toml
```
### Update laddr and prometheus_listen_addr ports
```
sed -i.bak -e "s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:26656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":26660\"%" $HOME/.artelad/config/app.toml
```
### Update gRPC, Web gRPC, and API ports
```
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:1317\"%" $HOME/.artelad/config/config.toml
```
## Update Indexer
```
sed -i 's|^indexer *=.*|indexer = "kv"|' $HOME/.artelad/config/config.toml
```
## Update Pruning
```
sed -i.bak -e 's|^pruning *=.*|pruning = "custom"|; s|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|; s|^pruning-keep-every *=.*|pruning-keep-every = "0"|; s|^pruning-interval *=.*|pruning-interval = "17"|' $HOME/.artelad/config/app.toml
```
## Get Validator Info
```
artelad status 2>&1 | jq .ValidatorInfo
```
## Get Denom Info
```
artelad q bank denom-metadata -oj | jq
```
## Get Sync Status
```
artelad status 2>&1 | jq .SyncInfo.catching_up
```
## Get Latest Height
```
artelad status 2>&1 | jq .SyncInfo.latest_block_height
```
## Get Peer
```
echo $(artelad tendermint show-node-id)'@'$(curl -s ifconfig.me)':'$(cat $HOME/.artelad/config/config.toml | sed -n '/Address to listen for incoming connection/{n;p;}' | sed 's/.*://; s/".*//')
```
## Reset Node
```
artelad tendermint unsafe-reset-all --home $HOME/.artelad --keep-addr-book
```
## Remove Node
```
sudo systemctl stop artelad && sudo systemctl disable artelad && sudo rm /etc/systemd/system/artelad.service && sudo systemctl daemon-reload && rm -rf $HOME/.artelad && rm -rf artela && sudo rm -rf $(which artelad)
```
## Get IP Address
```
wget -qO- eth0.me
```
## Servername
```
artela-testnet-node
```
## Update Servername
```
sudo hostnamectl set-hostname artela-testnet-node
```
# Service Management
## Reload Services
```
sudo systemctl daemon-reload
```
## Enable Service
```
sudo systemctl enable artelad
```
## Disable Service
```
sudo systemctl disable artelad
```
## Run Service
```
sudo systemctl start artelad
```
## Stop Service
```
sudo systemctl stop artelad
```
## Restart Service
```
sudo systemctl restart artelad
```
## Check Service Status
```
sudo systemctl status artelad
```
## Check Service Logs
```
sudo journalctl -u artelad -f --no-hostname -o cat
```
