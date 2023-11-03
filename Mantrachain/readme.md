# MantraChain Kurulum Rehberi

![gfgdfgd](https://github.com/brsbrc/Testnetler-ve-Rehberler/assets/107190154/d6936f43-fc71-4214-a33b-cce333c873ed)

Bu rehberde, MantraChain node'unu kurma adımlarını bulacaksınız. Bu adımları takip ederek MantraChain node'unu başarıyla kurabilirsiniz. Kolay gelsin..

### Rehberi yıldızlamayı ve forklamayı unutmayın..

## Gereksinimler

**MantraChain node'unu çalıştırmak için aşağıdaki gereksinimlere sahip olmanız önerilir:**

- 4 veya daha fazla CPU 
- En az 200GB SSD disk depolama
- En az 8GB RAM
- En az 100mbps ağ bant genişliği

## Gerekli kütüphaneleri yükleme ve sistem güncellemesi

Aşağıdaki komutları kullanarak sistem güncellemesi yapın ve gerekli kütüphaneleri yükleyin:

```
sudo apt update && sudo apt upgrade -y
sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential bsdmainutils git make ncdu gcc git jq chrony liblz4-tool -y
```

## Go Kurulumu

MantraChain için Go'yu kurun:

```
ver="1.20.6"
cd $HOME
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile
source ~/.bash_profile
go version
```

## Binary Dosyayı İndirme ve Kurulum

MantraChain Binary dosyasını indirin ve kurun:

```
wget https://github.com/MANTRA-Finance/public/raw/main/mantrachain-testnet/mantrachaind-linux-amd64.zip
unzip mantrachaind-linux-amd64.zip
sudo wget -P /usr/lib https://github.com/CosmWasm/wasmvm/releases/download/v1.3.0/libwasmvm.x86_64.so
sudo mv ./mantrachaind /usr/local/bin
```

## Node'u Başlatma

Lütfen aşağıdaki komutları kullanarak node'u başlatın ve kendi NODEADINIZ'ı belirtin:

```
mantrachaind init "NODEADINIZ" --chain-id mantrachain-1
mantrachaind config keyring-backend test
```

## Genesis Dosyasını ve Addrbook'u İndirme

Genesis dosyasını ve addrbook dosyasını indirin:

```
wget -O $HOME/.mantrachain/config/genesis.json https://raw.githubusercontent.com/MANTRA-Finance/public/main/mantrachain-testnet/genesis.json
```

## Seeds ve Peers Ayarları

Aşağıdaki komutları kullanarak Seeds ve Peers ayarlarınızı yapın:

```
SEEDS=""
sed -i -e "s|^seeds *=.*|seeds = \"$SEEDS\"|" $HOME/.mantrachain/config/config.toml
peers="0e687ef17922361c1aa8927df542482c67fb7571@35.222.198.102:26656,114988f9a053f594ab9592beb79b924430d355ba@34.123.40.240:26656,c533d7ee2037ee6d382f773be04c5bbf27da7a29@34.70.189.2:26656,a435339f38ce3f973739a08afc3c3c7feb862dc5@35.192.223.187:26656"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.mantrachain/config/config.toml
sed -i -e "s|^minimum-gas-prices *=.*|minimum-gas-prices = \"0.00uaum\"|" $HOME/.mantrachain/config/app.toml
```

## Pruning ayarları

Aşağıdaki komutları kullanarak # Pruning ayarlarını yapın:

```
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.mantrachain/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.mantrachain/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.mantrachain/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.mantrachain/config/app.toml
```

## Servis Dosyası Oluşturma ve Node'u Başlatma

Aşağıdaki komutları kullanarak MantraChain node'u için bir servis dosyası oluşturun ve başlatın:

```
sudo tee /etc/systemd/system/mantrachaind.service > /dev/null <<EOF
[Unit]
Description=mantrachain
After=network-online.target

[Service]
User=$USER
ExecStart=$(which mantrachaind) start
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
```
```
sudo systemctl daemon-reload
sudo systemctl enable mantrachaind
sudo systemctl start mantrachaind
```

## Snapshot ile hızlı sync

Snapshot'ı indirin:

```
SNAP_NAME=$(curl -s https://ss-t.mantra.nodestake.top/ | egrep -o ">20.*\.tar.lz4" | tr -d ">")
curl -o - -L https://ss-t.mantra.nodestake.top/${SNAP_NAME}  | lz4 -c -d - | tar -x -C $HOME/.mantrachain
```

## Peer 
>Peer sorunu yaşarsanız bu komutu kullanarak peer ekleyebilirsiniz.
```
peers=$(curl -s https://ss-t.mantra.nodestake.top/peers.txt)
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" ~/.mantrachain/config/config.toml

sudo systemctl restart mantrachaind
journalctl -u mantrachaind -f
```

## Senkronizasyon Kontrolü

Node'unuzun senkronize olup olmadığını kontrol edin:
> Komut çıktısı "false" ise ağ ile senkronize olduğunuz anlamına gelir.
```
mantrachaind status 2>&1 | jq .SyncInfo
```

# Faydalı Komutlar

### Cüzdan Oluşturma
```
mantrachaind keys add CÜZDANADINIZ
```

### Cüzdan Kurtarma
```
mantrachaind keys add CÜZDANADINIZ --recover
```

### Cüzdan Listeleme
```
mantrachaind keys list
```

### Cüzdan Silme
```
mantrachaind keys delete CÜZDANADINIZ
```

### Cüzdan Bakiyesini Kontrol Etme
```
mantrachaind q bank balances $(mantrachaind keys show CÜZDANADINIZ -a)
```

### Validator Oluşturma
`
--moniker=NODEADINIZ ve --from=CÜZDANADINIZ kısımlarını düzenlemeyi unutmayın.
`
```
mantrachaind tx staking create-validator \
--amount=10000000uaum \
--pubkey=$(mantrachaind tendermint show-validator) \
--moniker=NODEADINIZ \
--chain-id="mantrachain-1" \
--commission-rate="0.10" \
--commission-max-rate="0.20" \
--commission-max-change-rate="0.01" \
--min-self-delegation="1000000" \
--from=CÜZDANADINIZ \
--gas-adjustment 1.4 \
--gas=auto \
-y
```

### Validator Düzenleme
`
--new-moniker=NODEADINIZ ve --from=CÜZDANADINIZ kısımlarını düzenlemeyi unutmayın.
`
```
mantrachaind tx staking edit-validator \
--new-moniker=NODEADINIZ \
--chain-id=mantrachain-1 \
--from=CÜZDANADINIZ \
--gas-adjustment 1.4 \
--gas="auto" \
-y
```

###  Unjail Komutu
`
CÜZDANADINIZ kısmını unutmayın.
`
```
mantrachaind tx slashing unjail --from CÜZDANADINIZ --chain-id mantrachain-1 --gas-adjustment 1.4 --gas auto -y
```

### Jail Nedenini Kontrol Etme
```
mantrachaind query slashing signing-info $(mantrachaind tendermint show-validator)
```

### Ödülleri Çekme
`
CÜZDANADINIZ kısmını unutmayın.
`
```
mantrachaind tx distribution withdraw-all-rewards --from CÜZDANADINIZ --chain-id mantrachain-1 --gas-adjustment 1.4 --gas auto -y
```

### Komisyonlu Ödülleri Çekme
`
CÜZDANADINIZ kısmını unutmayın.
`
```
mantrachaind tx distribution withdraw-rewards $(mantrachaind keys show CÜZDANADINIZ --bech val -a) --commission --from CÜZDANADINIZ --chain-id mantrachain-1 --gas-adjustment 1.4 --gas auto -y
```

### Tokenları Kendi Validatorünüze Delege Etme
```
mantrachaind tx staking delegate $(mantrachaind keys show CÜZDANADINIZ --bech val -a) 1000000uaum --from CÜZDANADINIZ --chain-id mantrachain-1 --gas-adjustment 1.4 --gas auto -y
```

### Tokenları Başka Bir Validator'e Yeniden Delege Etme
```
mantrachaind tx staking redelegate $(mantrachaind keys show CÜZDANADINIZ --bech val -a) YENİVALOPERADRES 1000000uaum --from CÜZDANADINIZ --chain-id mantrachain-1 --gas-adjustment 1.4 --gas auto -y
```

### Tokenların Delegasyonunu Kaldırma
```
mantrachaind tx staking unbond $(mantrachaind keys show CÜZDANADINIZ --bech val -a) 1000000uaum --from CÜZDANADINIZ --chain-id mantrachain-1 --gas-adjustment 1.4 --gas auto -y
```

### Token Gönderme
```
mantrachaind tx bank send GÖNDERENCÜZDAN ALICICÜZDAN 1000000uaum --from CÜZDANADINIZ --chain-id mantrachain-1 --gas-adjustment 1.4 --gas auto -y
```

### Oylama Katılma
`
CÜZDANADI'nızı yazmayı unutmayın. "yes" kısmını eğer hayır oyu kullanacaksanız "no" ile değiştirin.
`
```
mantrachaind tx gov vote 1 yes --from CÜZDANADI --chain-id mantrachain-1 --gas-adjustment 1.4 --gas auto -y
```

### Zincir Verisini Sıfırlama

```
mantrachaind tendermint unsafe-reset-all --home $HOME/.mantrachain --keep-addr-book
```

## MantraChain Node Silme Komutu

**UYARI! Bu komutu dikkatli kullanın. Önce cüzdanınızı ve priv.validator.key.json dosyanızı yedekleyin, çünkü bu işlem sunucunuzdan MantraChain'i tamamen kaldırır.**

```
sudo systemctl stop mantrachaind
sudo systemctl disable mantrachaind
sudo rm /etc/systemd/system/mantrachaind.service
sudo systemctl daemon-reload
rm -f $(which mantrachaind)
rm -rf .mantrachain
rm -rf mantrachaind
```
