# Nibiru (nibiru-itn-2) Node Installation Guide

![6565yy](https://github.com/brsbrc/Testnetler-ve-Rehberler/assets/107190154/f05367a7-b1db-4ba7-96a2-7f75ef02ba15)

## Useful Links

- [Official Documentation](https://nibiru.fi/docs/run-nodes/testnet/)
- [Nibiru Discord](https://discord.gg/nibirufi)
- [Nibiru Twitter](https://twitter.com/NibiruChain)
- [Explorer](https://explorer.nibiru.fi/)
- [BlackOwl Twitter](https://twitter.com/brsbtc)

**You can use these links to learn more about Nibiru!**

## System Requirements

| **CPU** | **RAM** | **Disk** |
|---------|---------|----------|
| 4 cores | 16GB RAM | 1TB storage |

# Welcome to the Nibiru itn-2 Installation Guide!

Hello! I have a small request for you before we start with this guide.

1. Star this guide!
   - If you find this guide helpful, please don't forget to give it a star. This helps more people discover the guide.

2. Fork the guide and start contributing!
   - By forking this guide to your own GitHub account, you can work on it, add new features, and fix errors.

3. Share your changes with me!
   - Create a pull request to contribute your changes back to this project. I'll be happy to review and integrate your modifications.

Thank you! I appreciate your support.

Let's get started!

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------

<h1 align="center">Installation</h1>

<p align="center">Follow the guide step by step.</p>

**Step 1: Update and Library Installation**
>First, update the system and install the necessary libraries. This command will update system packages and install the required tools and libraries.

```bash
sudo apt update && sudo apt upgrade -y && sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential bsdmainutils git make ncdu gcc git jq chrony liblz4-tool -y
```

**Step 2: Install Go**
>Install the Go programming language. In this step, you will download and install a specific version of Go.

```bash
ver="1.20.3"
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> $HOME/.bash_profile
source $HOME/.bash_profile
go version
```

**Step 3: Install Nibid**
>Install Nibid. This command will download and install a specific version of Nibid.

```bash
curl -s https://get.nibiru.fi/@v0.21.9! | bash
```

**Step 4: Version Check**
>Verify that the installation was successful by checking the version of Nibid.

```bash
nibid version
```

**Step 5: Initialization**
>Configure the necessary settings to start Nibid. Replace "YOURNODENAME" with your own node name.

```bash
nibid init YOURNODENAME --chain-id=nibiru-itn-2 --home $HOME/.nibid
```

**Step 6: Genesis File**
>Download the Genesis file and add it to the configuration.

```bash
NETWORK=nibiru-itn-2
curl -s https://networks.itn2.nibiru.fi/$NETWORK/genesis > $HOME/.nibid/config/genesis.json
```

**Step 7: Seed and Peers Configuration**
>Add seed and peers settings to the configuration.

```bash
NETWORK=nibiru-itn-2
seeds=$(curl -s https://networks.itn2.nibiru.fi/$NETWORK/seeds)
sed -i 's|seeds =.*|seeds = "'$seeds'"|g' $HOME/.nibid/config/config.toml
peers="02ddb201a1ceca73e43647d53a82a0342a6532ab@148.251.90.138:11656,9a3d3357c38dc553e0fd2e89f9d2213016751fb5@176.9.110.12:36656,111dd6b7ac9d0f80d7a04ce212267ce95cb913e9@195.201.76.69:26656,7d443bfaec2780c72319ea7de03c09e0a9c9fbfc@78.46.103.246:26656,faf332f0f0e56398314935a1b72de2e0a70ddd82@91.107.214.162:26656,ea516128d449c0a6a3c042a32020c98203b7b501@188.166.29.139:26656,766ca434a82fe30158845571130ee7106d52d0c2@34.140.226.56:26656,8d2735274fddfd6f38585f94b748a91280086def@62.171.167.76:26656,c060180df8c01546c66d21ee307b09f700780f65@34.34.137.125:26656,2cbae8362c1953cbe7badac73dd547ae0854cb63@104.199.24.9:26656,7a0d35b3cb1eda647d57c699c3e847d4e41d890d@65.108.8.28:36656,081ff903784a3f1b69522d6167c998c88c91ce61@65.108.13.154:27656,96e26da24f2b70b1314301263477e1a3c8a159be@65.109.26.21:11656,d5519e378247dfb61dfe90652d1fe3e2b3005a5b@65.109.68.190:13956,c068c45ef902b35dd9ea4f6b82405e6ab2dfc730@65.109.92.241:11036,d092162ed9c61c9921842ff1fb221168c68d4872@65.109.65.248:27656,41bb02a3e2b60761f07ddcc7138bcf17b6a1eda9@65.109.90.171:27656,0269836fc9a3db6b34828c57d9130b62cbbf59f2@134.249.103.215:26656,142142567b8a8ec79075ff3729e8e5b9eb2debb7@35.195.230.189:26656,ac163da500a9a1654f5bf74179e273e2fb212a75@65.108.238.147:27656,e36ada54e3d1e7c05c1c3b585b4235134aa185ef@65.108.206.118:60656,fac29c5446afa4c44285394468172fe423d3a5f4@188.40.106.246:46656,16827b8ba8a336adea0bdabb6ea5be7cb8db471b@136.169.209.32:26656"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$peers\"|" $HOME/.nibid/config/config.toml
```   

**Step 8: Minimum Gas Price and Prometheus Configuration**
>Set the minimum gas price and Prometheus settings.            

```bash
sed -i 's/minimum-gas-prices =.*/minimum-gas-prices = "0.025unibi"/g' $HOME/.nibid/config/app.toml
sed -i 's|^prometheus *=.*|prometheus = true|' $HOME/.nibid/config/config.toml
```

**Step 9: Disable Indexer (Optional)**
>If you want to disable the indexer (reduce disk usage), use the following command.

```bash
indexer="null"
sed -i -e "s/^indexer *=.*/indexer = \"$indexer\"/" $HOME/.nibid/config/config.toml
```

**Step 10: Pruning Settings (Optional)**
>If you want to configure pruning settings, use the following commands.

```bash
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.nibid/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.nibid/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.nibid/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.nibid/config/app.toml
sed -i "s/snapshot-interval *=.*/snapshot-interval = 0/g" $HOME/.nibid/config/app.toml
```

**Step 11: Unsafe Reset**
>Reset the chain data.

```bash
nibid tendermint unsafe-reset-all --home $HOME/.nibid --keep-addr-book
```

**Step 12: Create a Service File and Start**
>To run Nibid as a service, use the following commands.

```bash
tee /etc/systemd/system/nibid.service > /dev/null <<EOF
[Unit]
Description=nibid
After=network-online.target

[Service]
User=$USER
ExecStart=$(which nibid) start
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl enable nibid
sudo systemctl start nibid
```

**Step 13: Check Logs**
>To check Nibid service logs, use the following command.

```bash
sudo journalctl -u nibid -f -o cat
```

**Step 14: Check Sync Status**
>Check the synchronization status of Nibid.

```bash
nibid status 2>&1 | jq .SyncInfo
```

**Creating a Wallet**

1. Adding a New Test Network in KEPLR

   - First, remove the old "nibiru-itn-1" network and go to the [Nibiru website](https://app.nibiru.fi/) to add the new test network. When you connect to the site, the new test network will be added automatically.

2. Importing the Wallet

   - To import your Nibiru wallet, use the following command, replacing "WALLET" with your wallet name:

   ```bash
   nibid keys add WALLET --recover
   ```

3. Get Test UNIBI from Faucet

   - You can get test UNIBI by visiting the [Nibiru Discord server](https://discord.gg/nibirufi) or the [Faucet website](https://app.nibiru.fi/faucet).

**Creating a Validator**

4. Creating a Validator

   - To create your own validator node, use the following command. Make sure to fill in "YOURNODENAME," "KEYBASEID," "YOURWALLETNAME," and "YOURWEBSITEURL" with your own information:

   ```bash
   nibid tx staking create-validator \
   --amount 1000000unibi \
   --pubkey $(nibid tendermint show-validator) \
   --moniker "YOURNODENAME" \
   --identity "KEYBASEID" \
   --website "YOURWEBSITEURL" \
   --chain-id nibiru-itn-2 \
   --commission-rate 0.05 \
   --commission-max-rate 0.20 \
   --commission-max-change-rate 0.01 \
   --min-self-delegation 1 \
   --from YOURWALLETNAME \
   --gas-adjustment 1.4 \
   --gas auto \
   --gas-prices 0.025unibi \
   -y
   ```

**Useful Commands**

5. Delegating to Your Validator or Another Validator

   - To delegate UNIBI tokens to your validator or another validator, use the following command. Make sure to fill in the relevant addresses and the amount:

   ```bash
   nibid tx staking delegate VALIDATOROPERATORADDRESS 1000000unibi --from YOURWALLETNAME --chain-id nibiru-itn-2 --gas-adjustment 1.4 --gas auto --gas-prices 0.025unibi -y
   ```

6. Redelegating

   - To redelegate your delegation, use the following command:

   ```bash
   nibid tx staking redelegate SENDERVALIDATOROPERATORADDRESS RECEIVERVALIDATOROPERATORADDRESS 10000000unibi --from YOURWALLETNAME --chain-id nibiru-itn-2 --gas-adjustment 1.4 --gas auto --gas-prices 0.025unibi -y
   ```

7. Transferring Between Wallets

   - To transfer UNIBI tokens between wallets, use the following command:

   ```bash
   nibid tx bank send SENDERADDRESS RECEIVERADDRESS 10000000unibi --from YOURWALLETNAME --chain-id nibiru

-itn-2 --gas-adjustment 1.4 --gas auto --gas-prices 0.025unibi -y
   ```

8. Claiming Accumulated Rewards

   - To claim accumulated rewards, use the following command:

   ```bash
   nibid tx distribution withdraw-all-rewards --from YOURWALLETNAME --chain-id nibiru-itn-2 --gas-adjustment 1.4 --gas auto --gas-prices 0.025unibi -y
   ```

9. Unbonding

   - To unbond UNIBI tokens, use the following command:

   ```bash
   nibid tx staking unbond VALIDATOROPERATORADDRESS 1000000unibi --from YOURWALLETNAME --chain-id nibiru-itn-2 --gas-prices 0.1unibi --gas-adjustment 1.5 --gas auto -y
   ```

10. Voting

    - To vote "yes" on a proposal, use the following command:

    ```bash
    nibid tx gov vote 1 yes --from YOURWALLETNAME --chain-id nibiru-itn-2 --gas-adjustment 1.4 --gas auto --gas-prices 0.025unibi -y
    ```

11. Unjail

    - To unjail a jailed validator, use the following command:

    ```bash
    nibid tx slashing unjail --from YOURWALLETNAME --chain-id nibiru-itn-2 --gas-adjustment 1.4 --gas auto --gas-prices 0.025unibi -y
    ```

12. Editing a Validator

    - To edit an existing validator, use the following command:

    ```bash
    nibid tx staking edit-validator \
    --new-moniker YOURNEWNAME \
    --identity YOURKEYBASE.IOID \
    --details "DESCRIPTION" \
    --website "YOURWEBSITEURL" \
    --chain-id nibiru-itn-2 \
    --gas-prices 0.025unibi \
    --from YOURWALLETNAME
    ```

**Node Deletion Commands**

13. Node Deletion Commands

    - To completely remove the Nibiru node, use the following commands:

    ```bash
    cd $HOME
    sudo systemctl stop nibid
    sudo systemctl disable nibid
    sudo rm /etc/systemd/system/nibid.service
    sudo systemctl daemon-reload
    rm -f $(which nibid)
    rm -rf $HOME/.nibid
    rm -rf $HOME/nibiru
    ```

### Best of luck to everyone.

This is a guide for installing Nibiru nodes. Please let me know if you need any further assistance or if you have any questions. Good luck!
