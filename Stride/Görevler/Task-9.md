#Task-9 Rehber

## Binary Dosyasını İndirelim
```
cd $HOME
git clone https://github.com/Stride-Labs/interchain-queries.git
cd interchain-queries
go build
sudo mv interchain-queries /usr/local/bin/icq
```

## Yapılandırma Dosyamızı Ayarlayalım
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
> NOT: Lütfen, aynı cüzdanınızı kullanın. Farklı cüzdanlar kullanmayın. Node cüzdanınız, relayer çalıştırdığınız cüzdanınız olsun.
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

**Logların görünmesi 10-15 dakika sürebilir, beklemelisiniz:**

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

**Tx'leri, explorerdan Kontrol Edelim**

**Form**
> https://docs.google.com/forms/d/e/1FAIpQLSeoZEC5kd89KCQSJjn5Zpf-NQPX-Gc8ERjTIChK1BEbiVfMVQ/viewform

### Herkese Kolay Gelsin.
