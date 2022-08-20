# Stafihub-Test

### Sistem Gereksinimleri

|     RAM     |       Cpu      |      Disk      |
|-------------|----------------|----------------|
|     8GB     |    4x CPUs     |     300GB      |

Öncelikle aşağıdaki komutlarla başlayalım
```
cd $HOME
sudo apt update && sudo apt upgrade -y
```
Library yani Kütüphane kurulumu yapıyoruz
```
sudo apt install make clang pkg-config libssl-dev build-essential git jq ncdu bsdmainutils -y < "/dev/null"
```
Go kurulumunu yapıyoruz
```
cd $HOME
wget -O go1.18.2.linux-amd64.tar.gz https://go.dev/dl/go1.18.2.linux-amd64.tar.gz
rm -rf /usr/local/go && tar -C /usr/local -xzf go1.18.2.linux-amd64.tar.gz && rm go1.18.2.linux-amd64.tar.gz
echo 'export GOROOT=/usr/local/go' >> $HOME/.bashrc
echo 'export GOPATH=$HOME/go' >> $HOME/.bashrc
echo 'export GO111MODULE=on' >> $HOME/.bashrc
echo 'export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin' >> $HOME/.bashrc && . $HOME/.bashrc
go version
```
Klonlama yapıyoruz
```
git clone --branch public-testnet-v3 https://github.com/stafihub/stafihub
```
Yüklemeyi Başlatıyoruz
```
cd $HOME/stafihub && make install
```
Your node name kısmına kendi node isminizi yazın
```
stafihubd init YOUR_NODE_NAME --chain-id stafihub-public-testnet-3
```
Genesis dosyamızı indiriyoruz.
```
wget -O $HOME/.stafihub/config/genesis.json "https://raw.githubusercontent.com/stafihub/network/main/testnets/stafihub-public-testnet-3/genesis.json"
stafihubd tendermint unsafe-reset-all --home ~/.stafihub
```
Son ayarlarımızı yapıyoruz
```
sed -i.bak -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.01ufis\"/" $HOME/.stafihub/config/app.toml
sed -i '/\[grpc\]/{:a;n;/enabled/s/false/true/;Ta};/\[api\]/{:a;n;/enable/s/false/true/;Ta;}' $HOME/.stafihub/config/app.toml
peers="4e2441c0a4663141bb6b2d0ea4bc3284171994b6@46.38.241.169:26656,79ffbd983ab6d47c270444f517edd37049ae4937@23.88.114.52:26656"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.stafihub/config/config.toml
```
Node başlatıyoruz
```
stafihubd start
```
Log kontrol için 
```
journalctl -u stafihubd -f
```

Cüzdanınız yoksa şu komutla cüzdan alabilirsiniz
```
stafihubd keys add cüzdan_ismi
```

Eğer cüzdanınız varsa recover etmek istiyorsanız

```
stafihubd keys add cüzdan_ismi --recover
```

Discord kanalından token isteyebilirsiniz (https://discord.com/invite/KXMt24cb)
```
!faucet send YOUR_WALLET_ADDRESS
```

Sync durumunu kontrol
```
stafihubd status 2>&1 | jq .SyncInfo
```

Validator oluşturma
```
stafihubd tx staking create-validator \
--moniker="NodeName" \
--amount=80000000ufis \
--gas auto \
--fees=5000ufis \
--pubkey=$(stafihubd tendermint show-validator) \
--chain-id=stafihub-public-testnet-3 \
--commission-max-change-rate=0.01 \
--commission-max-rate=0.20 \
--commission-rate=0.10 \
--min-self-delegation=1 \
--from=WalletName \
--yes
```

Unjail Komutu
```
stafihubd tx slashing unjail --from=<key_name> --chain-id=stafihub-public-testnet-3 --gas-prices=0.025ufis
```
Explorer
```
https://testnet-explorer.stafihub.io/stafi-hub-testnet
```

### Herkese Kolay Gelsin.
