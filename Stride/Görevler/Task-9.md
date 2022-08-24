# Task-9 Rehber

## 🛰  Relayer Tasks 

| #     | Pts |  Task                                                                                                             | Evidence                                                                           | Instructions      |
| ----- | --- | ----------------------------------------------------------------------------------------------------------------- |:----------------------------------------------------------------------------------:| ----------------- |
| **9** | 750 | relay interchain queries using the new [v2 go relayer](https://github.com/cosmos/relayer/releases/tag/v2.0.0-rc4) | link to ICQ packets relayed and link to the configured relayer fork on your github | - |

## Binary Dosyasını İndirelim
```
cd $HOME
git clone https://github.com/Stride-Labs/interchain-queries.git
cd interchain-queries
go build
sudo mv interchain-queries /usr/local/bin/icq
```

## RPC-GRPC Nasıl Öğreniriz?

**Gaia RPC**
```
echo "$(curl -s ifconfig.me)$(grep -A 3 "\[rpc\]" ~/.gaia/config/config.toml | egrep -o ":[0-9]+")"
```

**Gaia GRPC**
```
echo "$(curl -s ifconfig.me)$(grep -A 6 "\[grpc\]" ~/.gaia/config/app.toml | egrep -o ":[0-9]+")"
```

**Stride RPC**
```
echo "$(curl -s ifconfig.me)$(grep -A 3 "\[rpc\]" ~/.stride/config/config.toml | egrep -o ":[0-9]+")"
```

**Stride GRPC**
```
echo "$(curl -s ifconfig.me)$(grep -A 6 "\[grpc\]" ~/.stride/config/app.toml | egrep -o ":[0-9]+")"
```

## Yapılandırma Dosyamızı Ayarlayalım
> Wallet yazan kısma cüzdan adınızı yazın
```
cd $HOME && mkdir .icq
sudo tee $HOME/.icq/config.yaml > /dev/null <<EOF
default_chain: stride-testnet
chains:
  gaia-testnet:
    key: wallet
    chain-id: GAIA
    rpc-addr: http://127.0.0.1:buraya      # Gaia RPC yazacağız
    grpc-addr: http://127.0.0.1:buraya     # Gaia GRPC yazacağız
    account-prefix: cosmos
    keyring-backend: test
    gas-adjustment: 1.2
    gas-prices: 0.001uatom
    key-directory: /root/.icq/keys
    debug: false
    timeout: 20s
    block-timeout: ""
    output-format: json
    sign-mode: direct
  stride-testnet:
    key: wallet
    chain-id: STRIDE-TESTNET-4
    rpc-addr: http://127.0.0.1:buraya      # Stride RPC yazacağız
    grpc-addr: http://127.0.0.1:buraya     # Stride GRPC yazacağıze
    account-prefix: stride
    keyring-backend: test
    gas-adjustment: 1.2
    gas-prices: 0.001ustrd
    key-directory: /root/.icq/keys
    debug: false
    timeout: 20s
    block-timeout: ""
    output-format: json
    sign-mode: direct
cl: {}
EOF
```

## Cüzdanımızı İmport Edelim
> Wallet yazan kısma cüzdan adınızı yazın
> NOT: Lütfen, aynı cüzdanınızı kullanın. Node cüzdanınız, relayer çalıştırdığınız cüzdanınız olsun.
```
icq keys restore --chain stride-testnet wallet
icq keys restore --chain gaia-testnet wallet
```
> Cüzdan kelimelerinizi girmenizi isteyecek.

## Icq Servis Dosyamızı Oluşturalım
```
sudo tee /etc/systemd/system/icqd.service > /dev/null <<EOF
[Unit]
Description=Interchain Query Service
After=network-online.target

[Service]
User=$USER
ExecStart=$(which icq) run --debug
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
```

## Servisi Başlatalım
```
sudo systemctl daemon-reload
sudo systemctl enable icqd
sudo systemctl restart icqd
```

## Log Kontrol
```
journalctl -u icqd -f -o cat
```

**Logların görünmesi 30 dakika hatta 1 saatten fazla sürebilir, beklemelisiniz:**

### Örnek Çıktı;
```
store/bank/key
height parsed from GetHeightFromMetadata= 0
Fetching client update for height height 176886
store/bank/key
height parsed from GetHeightFromMetadata= 0
Fetching client update for height height 176886
Requerying lightblock
Requerying lightblock
Requerying lightblock
ICQ RELAYER | query.Height= 0
ICQ RELAYER | res.Height= 176885
Requerying lightblock
ICQ RELAYER | query.Height= 0
ICQ RELAYER | res.Height= 176885
Send batch of 4 messages
1 ClientUpdate message
1 SubmitResponse message
1 ClientUpdate message
1 SubmitResponse message
Sent batch of 2 (deduplicated) messages
```

### Icq Command Not Found Alanlar

**Icq'yi tamamen siliyoruz.**
```
cd $HOME
rm -rf interchain-queries
rm -rf /usr/local/bin/icq
rm -rf .icq
rm -rf /etc/systemd/system/icqd.service
```

### Go Yüklüyoruz.
```
wget -c https://go.dev/dl/go1.18.3.linux-amd64.tar.gz && rm -rf /usr/local/go && tar -C /usr/local -xzf go1.18.3.linux-amd64.tar.gz && rm -rf go1.18.3.linux-amd64.tar.gz
```
**Ayarlarımızı yapıyoruz.**
```
echo 'export GOROOT=/usr/local/go' >> $HOME/.bash_profile
echo 'export GOPATH=$HOME/go' >> $HOME/.bash_profile
echo 'export GO111MODULE=on' >> $HOME/.bash_profile
echo 'export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin' >> $HOME/.bash_profile && . $HOME/.bash_profile
```

## Tekrar Icq Kurulum yapalım
```
cd $HOME
git clone https://github.com/Stride-Labs/interchain-queries.git
cd interchain-queries
go build
sudo mv interchain-queries /usr/local/bin/icq
```

**Yapılandırma dosyanızdaki satırlarda kaydırma ya da kaymalar olmamalıdır.**

**Tx'leri, explorerdan Kontrol Edelim**

**Ardından bu repoyu forklayacağız.**

https://github.com/Stride-Labs/interchain-queries

![image](https://user-images.githubusercontent.com/107190154/186484524-26d30412-bc05-4e21-abd4-b36c90acb94e.png)

**Forkladıktan sonra kendi profilimizde gözükecektir. Üstüne tıklayıp açıyoruz ve add file diyoruz `config.yaml` isimli dosya oluşturuyoruz.**

![image](https://user-images.githubusercontent.com/107190154/186484894-47de1d29-a473-4ba4-96ee-f54b83207c13.png)

**Dosyanın içine az önce düzenlediğimiz yapılandırma ayarını gireceğiz.
> Bunu direkt girmeyeceksiniz. Kendi bilgilerinize göre revize edip add file dedikten sonra `config.yaml` adlı dosyanın içine yazacaksınız.
```
default_chain: stride-testnet
chains:
  gaia-testnet:
    key: cüzdanisminiz
    chain-id: GAIA
    rpc-addr: http://127.0.0.1:buraya      # Gaia RPC yazacağız
    grpc-addr: http://127.0.0.1:buraya     # Gaia GRPC yazacağız
    account-prefix: cosmos
    keyring-backend: test
    gas-adjustment: 1.2
    gas-prices: 0.001uatom
    key-directory: /root/.icq/keys
    debug: false
    timeout: 20s
    block-timeout: ""
    output-format: json
    sign-mode: direct
  stride-testnet:
    key: cüzdanisminiz
    chain-id: STRIDE-TESTNET-4
    rpc-addr: http://127.0.0.1:buraya      # Stride RPC yazacağız
    grpc-addr: http://127.0.0.1:buraya     # Stride GRPC yazacağıze
    account-prefix: stride
    keyring-backend: test
    gas-adjustment: 1.2
    gas-prices: 0.001ustrd
    key-directory: /root/.icq/keys
    debug: false
    timeout: 20s
    block-timeout: ""
    output-format: json
    sign-mode: direct
cl: {}
```

** İşlem bu kadar.**

### Icq Silme Komutu
```
sudo systemctl stop icqd
sudo systemctl disable icqd
sudo rm /etc/systemd/system/icqd* -rf
sudo rm $(which icq) -rf
sudo rm -rf $HOME/.icq
sudo rm -rf $HOME/interchain-queries
```

### Hepinize Kolay Gelsin.

**Form**
> https://docs.google.com/forms/d/e/1FAIpQLSeoZEC5kd89KCQSJjn5Zpf-NQPX-Gc8ERjTIChK1BEbiVfMVQ/viewform

### Herkese Kolay Gelsin.
