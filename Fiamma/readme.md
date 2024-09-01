# Fiamma Node Kurulumu

![Fiamma Node](https://github.com/user-attachments/assets/7c5e46ae-6135-428f-a58a-96bf545756ce)

## 1. Güncellemeler ve Gerekli Paketlerin Kurulumu

İlk adım olarak sisteminizi güncelleyip gerekli paketleri yükleyin.

```bash
sudo apt update && sudo apt upgrade -y
sudo apt install curl git wget htop tmux build-essential jq make lz4 gcc unzip -y
sudo apt-get install -y libssl-dev
```

## 2. Go Kurulumu

Golang'ın belirtilen versiyonunu sisteminize kurun.

```bash
ver="1.22.3" 
cd $HOME 
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz" 
sudo rm -rf /usr/local/go 
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz" 
rm "go$ver.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> $HOME/.bash_profile
source $HOME/.bash_profile    
```

## 3. Fiamma İndirimi ve Kurulumu

Fiamma yazılımını indirin ve kurun.

```bash
cd $HOME
rm -rf fiamma
git clone https://github.com/fiamma-chain/fiamma
cd fiamma
git checkout v0.2.1
make install
```

## 4. Node Başlatma

Validator adınızı belirleyerek node'u başlatın. "validatoradınızıyazın" ifadesini, kendi validator adınızla değiştirin.

```bash
fiammad init validatoradınızıyazın --chain-id fiamma-testnet-1
```

Client ayarlarını yapılandırın:

```bash
sed -i -e "s|^node *=.*|node = \"tcp://localhost:26657\"|" $HOME/.fiamma/config/client.toml
sed -i -e "s|^keyring-backend *=.*|keyring-backend = \"os\"|" $HOME/.fiamma/config/client.toml
sed -i -e "s|^chain-id *=.*|chain-id = \"fiamma-testnet-1\"|" $HOME/.fiamma/config/client.toml
```

## 5. Genesis ve AddrBook Dosyalarını İndirme

Aşağıdaki komutlarla gerekli dosyaları indirin.

```bash
wget -O $HOME/.fiamma/config/genesis.json "https://raw.githubusercontent.com/111STAVR111/props/main/Fiamma/genesis.json"
wget -O $HOME/.fiamma/config/addrbook.json "https://raw.githubusercontent.com/111STAVR111/props/main/Fiamma/addrbook.json"
```

## 6. Pruning Ayarları

Pruning ayarlarını yapılandırın.

```bash
sed -i -e "s/^pruning *=.*/pruning = \"custom\"/" $HOME/.fiamma/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"100\"/" $HOME/.fiamma/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"50\"/" $HOME/.fiamma/config/app.toml
sed -i 's|minimum-gas-prices =.*|minimum-gas-prices = "0.0001ufia"|g' $HOME/.fiamma/config/app.toml
```

## 7. Peers / Seeds Ayarları

Peers ve Seeds ayarlarını yapılandırın.

```bash
SEEDS=""
PEERS="16b7389e724cc440b2f8a2a0f6b4c495851934ff@fiamma-testnet-peer.itrocket.net:49656,74ec322e114b6757ac066a7b6b55cd224cdb8885@65.21.167.216:37656,37e2b149db5558436bd507ecca2f62fe605f92fe@88.198.27.51:60556,e30701492127fdd86ccf243a55b9dc4146772235@213.199.42.85:37656,e2b57b310a6f3c4c0f85fc3dc3447d7e9696cd65@95.165.89.222:26706,421beadda6355465be81703fd8d25c30b2233df0@5.78.71.69:26656,21a5cae23e835f99735798024eef39fa0875bc62@65.109.30.110:17456,dd09c5a54d233d7b1b238eecedf7d855b4cb549c@65.108.81.145:26656,043da1f559e0f83eff52ff65f76b012f0f0ee9b3@198.7.119.198:37656,5a6bdb09c087012e9aa9bbdaa95694a82d489a94@144.76.155.11:26856,a03a1a53fafb669bfcce53b8b2a1362aa153cf99@77.90.13.137:37656"
sed -i -e "/^\[p2p\]/,/^\[/{s/^[[:space:]]*seeds *=.*/seeds = \"$SEEDS\"/}" \
       -e "/^\[p2p\]/,/^\[/{s/^[[:space:]]*persistent_peers *=.*/persistent_peers = \"$PEERS\"/}" $HOME/.fiamma/config/config.toml
```

## 8. Servis Dosyası Oluşturma

Fiamma node'unu sistem hizmeti olarak çalıştırmak için bir servis dosyası oluşturun.

```bash
sudo tee /etc/systemd/system/fiammad.service > /dev/null <<EOF
[Unit]
Description=Fiamma Node
After=network-online.target
[Service]
User=$USER
WorkingDirectory=$HOME/.fiamma
ExecStart=$(which fiammad) start --home $HOME/.fiamma
Restart=on-failure
RestartSec=5
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF
```

## 9. Servisi Başlatma

Servisi etkinleştirin ve başlatın.

```bash
sudo systemctl daemon-reload
sudo systemctl enable fiammad
sudo systemctl restart fiammad && sudo journalctl -u fiammad -f
```

## 10. Logları Görüntüleme

Logları takip etmek için aşağıdaki komutu kullanın. Çıkmak için `CTRL + C` tuşlarına basabilirsiniz.

```bash
journalctl -u fiammad -f -o cat
```

## 11. Cüzdan Oluşturma

Yeni bir cüzdan oluşturun ve kelimeleri saklayın.

```bash
fiammad keys add walletadı
```

Cüzdanınızı geri yüklemek isterseniz:

```bash
fiammad keys add walletadı --recover
```

## 12. Faucet

Test tokenları almak için aşağıdaki faucet bağlantısını kullanabilirsiniz:

[https://testnet-faucet.fiammachain.io/](https://testnet-faucet.fiammachain.io/)

## 13. Validator Oluşturma

**Önemli:** Validator oluşturmak için node'unuzun tamamen senkronize olduğundan emin olmalısınız.

### 1. Validator Yapılandırma Dosyasını Oluşturun

Public key'inizi ve diğer gerekli bilgileri kullanarak bir validator yapılandırma dosyası oluşturun. Aşağıdaki komut ile bunu yapabilirsiniz. "moniker", "identity", "website" ve "details" kısımlarını kendinize uygun şekilde doldurmayı unutmayın.

```bash
cd $HOME
echo "{\"pubkey\":{\"@type\":\"/cosmos.crypto.ed25519.PubKey\",\"key\":\"$(fiammad tendermint show-validator | grep -Po '\"key\":\s*\"\K[^"]*')\"},
    \"amount\": \"1000000ufia\",
    \"moniker\": \"monikeryazın\",
    \"identity\": \"identityyazın\",
    \"website\": \"websiteyazın\",
    \"security\": \"güvenlikbilgilerinizi yazın\",
    \"details\": \"detaylarınızı yazın\",
    \"commission-rate\": \"0.1\",
    \"commission-max-rate\": \"0.2\",
    \"commission-max-change-rate\": \"0.01\",
    \"min-self-delegation\": \"1\"
}" > validator.json
```

### 2. Validator'ı Oluşturun

Oluşturduğunuz `validator.json` dosyasını kullanarak validator oluşturma işlemini gerçekleştirin. "walletadı" kısmını, cüzdan adınızla değiştirin.

```bash
fiammad tx staking create-validator validator.json \
    --from walletadı \
    --chain-id fiamma-testnet-1 \
    --gas auto --gas-adjustment 1.5
```

Servisi yeniden başlatın:

```bash
sudo systemctl restart fiammad
```

Validator oluşturmak için:

```bash
fiammad tx staking create-validator ~/.fiamma/config/validator.json --from walletadı --chain-id fiamma-testnet-1 --fees 20ufia
```

## 14. Delegasyon İşlemi

Validator'a delegasyon yapmak için aşağıdaki komutu kullanın:

```bash
fiammad tx staking delegate valoper-address 10000ufia \
--chain-id fiamma-testnet-1 \
--from "walletadı" \
--fees 500ufia \
--node=http://localhost:(your_custom_port)657
```

## 15. Node'u Silme

Node'u kaldırmak için:

```bash
cd $HOME
sudo systemctl stop fiammad
sudo systemctl disable fiammad
sudo rm -rf /etc/systemd/system/fiammad.service
sudo systemctl daemon-reload
sudo rm -f /usr/local/bin/fiammad
sudo rm -f $(which fiamma)
sudo rm -rf $HOME/.fiamma $HOME/fiamma
sed -i "/FIAMMA_/d" $HOME/.bash_profile
```
