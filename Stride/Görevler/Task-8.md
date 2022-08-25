# Stride ve GAIA arasında GO Relayer v2'yi Kurma Rehberi

![TT](https://user-images.githubusercontent.com/107190154/185767388-ef38d0bd-d138-413c-bf06-4a7a21c80877.png)

## 🛰  Relayer Tasks 

| #     | Pts |  Task                                                                                                             | Evidence                                                                           | Instructions      |
| ----- | --- | ----------------------------------------------------------------------------------------------------------------- |:----------------------------------------------------------------------------------:| ----------------- |
| **8** | 250 | relay using the new [v2 go relayer](https://github.com/cosmos/relayer/releases/tag/v2.0.0-rc4)                    | link to packets relayed and link to the configured relayer fork on your github     | - |


### Not;

```
İşlemlere geçmeden önce cüzdanınızda bakiye olduğundan emin olun çünkü tokeniniz olmadan bu işlemleri yapamazsınız.
```

### Bu Görevi Yapabilmek İçin İndexer Açık Olmalıdır. Kapalıysa Şu komutla Açalım
> Stride
```
sed -i -e "s/^indexer *=.*/indexer = \"kv\"/" $HOME/.stride/config/config.toml
```

**Gaia İçin de Açıyoruz**
> Gaia
```
sed -i -e "s/^indexer *=.*/indexer = \"kv\"/" $HOME/.gaia/config/config.toml
```
## Öncelikle RPC bilgilerimizi öğreneceğiz.
> RPC-GRPC nasıl öğreneceğinize dair komut bıraktım.

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

> Tekrar ifade ediyorum; bu işlemleri tokensiz yapamazsınız, cüzdanınızda tokeniniz mutlaka olmalıdır.

## Değişkenlerin Ayarlamasını Yapalım
> RPC-GRPC komutunun çıktısında bulunan sunucu ip kullanmayacağız.
> RPC değerinizi sunucu ip + port şeklinde değil, 127.0.0.1:port şeklinde girin.

**Örneğin;**
`127.0.0.1:16657`

```
RELAYER_ID='discord#1234'                           # Discord id'nizi yazabilirsiniz.
STRIDE_RPC_ADDR='127.0.0.1:RPCYAZIN'                # Stride RPC yazın
GAIA_RPC_ADDR='127.0.0.1:RPCYAZIN'                  # Gaia RPC yazın
```

## Sistemi Güncelleyelim.
```
sudo apt update && sudo apt upgrade -y
```
## Go'yu yükleyelim.
```
if ! [ -x "$(command -v go)" ]; then
  ver="1.18.3"
  cd $HOME
  wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
  sudo rm -rf /usr/local/go
  sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
  rm "go$ver.linux-amd64.tar.gz"
  echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile
  source ~/.bash_profile
fi
```
## Go Relayer V2 Kuralım ve Başlatalım.
```
git clone https://github.com/cosmos/relayer.git
cd relayer && git checkout v2.0.0-rc4
make install
rly config init --memo $RELAYER_ID
sudo mkdir $HOME/.relayer/chains
sudo mkdir $HOME/.relayer/paths
```

## Stride için Json DosyasI Oluşturalım.
> Key kısımında bulunan `wallet` yerine cüzdan isminizi yazabilirsiniz.
```
sudo tee $HOME/.relayer/chains/stride.json > /dev/null <<EOF
{
  "type": "cosmos",
  "value": {
    "key": "wallet",
    "chain-id": "STRIDE-TESTNET-4",
    "rpc-addr": "http://${STRIDE_RPC_ADDR}",
    "account-prefix": "stride",
    "keyring-backend": "test",
    "gas-adjustment": 1.2,
    "gas-prices": "0.000ustrd",
    "gas": 200000,
    "timeout": "20s",
    "trusting-period": "8h",
    "output-format": "json",
    "sign-mode": "direct"
  }
}
EOF
```
## Gaia için Json DosyasI Oluşturalım.
> Key kısımında bulunan `wallet` yerine cüzdan isminizi yazabilirsiniz.
```
sudo tee $HOME/.relayer/chains/gaia.json > /dev/null <<EOF
{
  "type": "cosmos",
  "value": {
    "key": "wallet",
    "chain-id": "GAIA",
    "rpc-addr": "http://${GAIA_RPC_ADDR}",
    "account-prefix": "cosmos",
    "keyring-backend": "test",
    "gas-adjustment": 1.2,
    "gas-prices": "0.000uatom",
    "gas": 200000,
    "timeout": "20s",
    "trusting-period": "8h",
    "output-format": "json",
    "sign-mode": "direct"
  }
}
EOF
```
## Yapılandırma Ayarlarını Aktarıcıya Yükleyelim.
```
rly chains add --file=$HOME/.relayer/chains/stride.json stride
rly chains add --file=$HOME/.relayer/chains/gaia.json gaia
```
## Relayere Eklenen Zincirleri Kontrol Edelim
```
rly chains list
```
### Çıktı şu şekilde olmalıdır;
```
1: GAIA             -> type(cosmos) key(✘) bal(✘) path(✘)
2: STRIDE-TESTNET-4 -> type(cosmos) key(✘) bal(✘) path(✘)
```
## Cüzdanları Aktarıcıya Yükleyelim.
> Cüzdan Adımızı ve Kelimelerimizi Girelim.
```
rly keys restore stride cüzdanismi "cüzdankelimeleriniziyazın"
rly keys restore gaia cüzdanismi "cüzdankelimeleriniziyazın"
```
## Stride-Gaia Paths Json Dosyasını Oluşturalım
> Direkt yapıştırın. Değişiklik yapmanıza gerek yok.

```
sudo tee $HOME/.relayer/paths/stride-gaia.json > /dev/null <<EOF
{
  "src": {
    "chain-id": "STRIDE-TESTNET-4",
    "client-id": "07-tendermint-0",
    "connection-id": "connection-0"
  },
  "dst": {
    "chain-id": "GAIA",
    "client-id": "07-tendermint-0",
    "connection-id": "connection-0"
  },
  "src-channel-filter": {
    "rule": "allowlist",
    "channel-list": ["channel-0", "channel-1", "channel-2", "channel-3", "channel-4"]
  }
}
EOF
```
## Paths ekleyelim
```
rly paths add STRIDE-TESTNET-4 GAIA stride-gaia --file $HOME/.relayer/paths/stride-gaia.json
```
## Paths Doğruluğunu Kontrol Edelim
```
rly paths list
```
### Çıktı şu şekilde olmalıdır;
```
0: stride-gaia -> chns(✔) clnts(✔) conn(✔) (STRIDE-TESTNET-4<>GAIA)
```
## Servisi Oluşturalım
> Direkt yapıştırın. Değişiklik yapmanıza gerek yok.

```
sudo tee /etc/systemd/system/relayerd.service > /dev/null <<EOF
[Unit]
Description=GO Relayer v2 Service
After=network.target
[Service]
Type=simple
User=$USER
ExecStart=$(which rly) start stride-gaia -p events
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF
```

## Halihazırda Hermes çalışıyorsa önce onu durdurmalısınız.
```
sudo systemctl stop hermesd
sudo systemctl disable hermesd
```

## Servisi Başlatalım
```
sudo systemctl daemon-reload
sudo systemctl enable relayerd
sudo systemctl start relayerd
```
## Log Kontrol Edelim
```
journalctl -u relayerd -f -o cat
```
### Örnek log kontrol şu şekilde tx'ler vermelidir.;

![txxxx](https://user-images.githubusercontent.com/107190154/185777311-dfcbe031-5c98-4526-871e-b773ec01da27.png)

### İşlem Tx'lerimizi explorerdan kontrol edebiliriz. Bu tx'ler bizler için öenmli. Formu doldururken kullanacağız.

![rrrrrr](https://user-images.githubusercontent.com/107190154/185925166-ef5b7a75-660e-47d9-a6d8-a424c9c7f288.png)

## Kalan İşlemlere Devam Edelim

**Aşağıya bıraktığım linke gidip forklama işlemi yapacağız.**

> https://github.com/cosmos/relayer

![github11](https://user-images.githubusercontent.com/107190154/185777067-af25c64a-f07d-46d6-965b-597a7acef86d.png)

**Forklama işlemini yaptıktan sonra kendi oluşturduğumuz repolar kısmında gözükecek. Bu repoya gireceğiz ve add file butonuyla yeni bir dosya oluşturalım.**

![22qqq](https://user-images.githubusercontent.com/107190154/185776459-06186bab-c1c0-45e3-946e-a78349f966b8.png)

**Dosyayı şu şekilde oluşturacağız;**

**add file dedikten sonra çıkan boşluğa şunu yapıştıralım.**
```
configs/stride/chains/gaia.json
```

**Ardından şunu direkt kopyalayalım ve aşağıya inip dosyamızı oluşturalım.**
> Stride Json
> Cüzdan İsminiz Wallet Değilse Değiştirin.
```
{
  "type": "cosmos",
  "value": {
    "key": "wallet",                      ## cüzdan İsmimizi Yazalım
    "chain-id": "STRIDE-TESTNET-4",
    "rpc-addr": "http://127.0.0.1:26657", ## Stride RPC Yazalım
    "account-prefix": "stride",
    "keyring-backend": "test",
    "gas-adjustment": 1.2,
    "gas-prices": "0.000ustrd",
    "gas": 200000,
    "timeout": "20s",
    "trusting-period": "8h",
    "output-format": "json",
    "sign-mode": "direct"
  }
}
```
![gt333](https://user-images.githubusercontent.com/107190154/185777098-d7f384b1-f093-42b8-8ae6-9ad8c48cdebc.png)

**Tekrar add file diyoruz ve bu sefer şunu yapıştırıyoruz;**

```
configs/stride/chains/stride.json
```
**Ardından şunu direkt kopyalayalım ve aşağıya inip dosyamızı oluşturalım.**
> Gaia Json
> Cüzdan İsminiz Wallet Değilse Değiştirin.
```
{
  "type": "cosmos",
  "value": {
    "key": "wallet",                      ## cüzdan İsmimizi Yazalım
    "chain-id": "GAIA",
    "rpc-addr": "http://127.0.0.1:23657", ## Gaia RPC Yazalım
    "account-prefix": "cosmos",
    "keyring-backend": "test",
    "gas-adjustment": 1.2,
    "gas-prices": "0.000uatom",
    "gas": 200000,
    "timeout": "20s",
    "trusting-period": "8h",
    "output-format": "json",
    "sign-mode": "direct"
  }
}
```
![image](https://user-images.githubusercontent.com/107190154/185777368-85efc845-0a1f-4fe0-90f9-2908a8070e7e.png)

Ve son olarak birkez daha add file diyelim ve şunu yapıştıralım;

```
configs/stride/paths/stride-gaia.json
```
**Ardından şunu direkt kopyalayalım ve aşağıya inip dosyamızı oluşturalım.**

```
{
  "src": {
    "chain-id": "STRIDE-TESTNET-4",
    "client-id": "07-tendermint-0",
    "connection-id": "connection-0"
  },
  "dst": {
    "chain-id": "GAIA",
    "client-id": "07-tendermint-0",
    "connection-id": "connection-0"
  },
  "src-channel-filter": {
    "rule": "allowlist",
    "channel-list": ["channel-0", "channel-1", "channel-2", "channel-3", "channel-4"]
  }
}
```
![image](https://user-images.githubusercontent.com/107190154/185777386-cb5f2499-3280-48ed-93e7-831a961e7047.png)

### Dosyalarımızı kaydettikten sonra şöyle gözükecek, arkadaşlar;

![g44555](https://user-images.githubusercontent.com/107190154/185777120-d978fd11-4ff8-413a-815a-ecfcb78866ae.png)

**İşlemler bu kadardı, arkdaşlar.
Tx'i alıp aynı zamanda bu oluşturduğumuz github repomuzun linkini de formda yollamayı unutmayalım.**

**Kendi forkladığınız reponun linkini bırakacaksınız, forma.**

### Görev Form Linki

> https://docs.google.com/forms/d/e/1FAIpQLSeoZEC5kd89KCQSJjn5Zpf-NQPX-Gc8ERjTIChK1BEbiVfMVQ/viewform

### Hepinize Kolay Gelsin..
