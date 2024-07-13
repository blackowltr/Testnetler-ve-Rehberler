# Airchains Kurulum Rehberi

## 1. Gerekli Paketlerin Kurulumu

İlk olarak, sisteminizde gerekli paketlerin kurulumunu yapmanız gerekmektedir. Aşağıdaki komutlar ile güncellemeleri yapabilir ve gerekli paketleri kurabilirsiniz.

```bash
apt update && apt upgrade -y
apt install curl build-essential pkg-config libssl-dev git wget jq make gcc chrony -y
```

## 2. Go Kurulumu

Airchains çalıştırmak için Go programlama dili gereklidir. Aşağıdaki komutlar ile Go'yu kurabilirsiniz.

```bash
ver="1.22.2" && \
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz" && \
rm -rf /usr/local/go && \
tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz" && \
rm "go$ver.linux-amd64.tar.gz" && \
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> $HOME/.bash_profile && \
source $HOME/.bash_profile
```

## 3. Gerekli Repoların Klonlanması

Airchains ve Tracks repolarını klonlamamız gerekiyor.

```bash
git clone https://github.com/airchains-network/evm-station.git
git clone https://github.com/airchains-network/tracks.git
```

## 4. EVM Station Kurulumu

EVM Station dizinine geçiş yapın ve gerekli bağımlılıkları yükleyin.

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

Yukarıdaki komutlar çalıştıktan sonra, CTRL + C tuşlarına basarak durdurun.

## 5. Systemd Servis Dosyasının Oluşturulması

EVM Station için bir systemd servis dosyası oluşturun.

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

Servisi başlatın ve aktif hale getirin.

```bash
systemctl daemon-reload && \
systemctl enable evmosd && \
systemctl restart evmosd
```

Logları kontrol edin.

```bash
journalctl -u evmosd -fo cat
```

## 6. Konfigürasyon Dosyasının Düzenlenmesi

`/root/.evmosd/config/app.toml` dosyasını düzenlemek için aşağıdaki komutları çalıştırın. Bu, gerekli ayarları yapacaktır.

```bash
sed -i 's/address = "127.0.0.1:8545"/address = "0.0.0.0:8545"/' /root/.evmosd/config/app.toml
sed -i 's/ws-address = "127.0.0.1:8546"/ws-address = "0.0.0.0:8546"/' /root/.evmosd/config/app.toml
```

## 7. Tracks Kurulumu

Tracks dizinine geçiş yapın ve gerekli işlemleri gerçekleştirin.

```bash
cd $HOME/tracks
screen -S track
```

```bash
make build
go mod tidy
```

Mock olarak kurulum için aşağıdaki komutu kullanın. Eigen ile kurulum için farklı kodlar ve da-key gerekecektir.

```bash
go run cmd/main.go init --daRpc "mock-rpc" --daKey "Mock-Key" --daType "mock" --moniker "MONIKERYAZIN" --stationRpc "http://127.0.0.1:8545" --stationAPI "http://127.0.0.1:8545" --stationType "evm"
```

Sadece MONIKERYAZIN kısmını değiştirin.

## 8. Hesap Oluşturma ve Mnemonic 

```bash
go run cmd/main.go keys junction --accountName wallet --accountPath $HOME/.tracks/junction-accounts/keys
```

Mnemonic'leri saklayın. Air cüzdanına air tokeni faucet ile alabilir veya gönderebilirsiniz.

```bash
go run cmd/main.go prover v1EVM
```

Sadece Cüzdan Adresinizi yazın ve ardından tüm komutu tek seferde terminale yazın.
```bash
CUZDAN="airadresiniziyazın" && \
IP=$(wget -qO- eth0.me) && \
ID=$(grep 'node_id' /root/.tracks/config/sequencer.toml | awk -F ' = ' '{gsub(/"/, "", $2); print $2}')
```

> Değişken atadığımız için aşağıdaki komutu düzeltme yapmadan direkt girebilirsiniz.

```bash
go run cmd/main.go create-station --accountName wallet --accountPath $HOME/.tracks/junction-accounts/keys --jsonRPC "https://junction-testnet-rpc.synergynodes.com/" --info "EVM Track" --tracks $CUZDAN --bootstrapNode "/ip4/$IP/tcp/2300/p2p/$ID"
```

```
git pull
```
```
make build
```

## 9. Systemd Servis Dosyasının Oluşturulması

Tracks için bir systemd servis dosyası oluşturun.

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

Servisi başlatın ve aktif hale getirin.

```bash
systemctl daemon-reload && \
systemctl enable tracksd && \
systemctl restart tracksd
```

Logları kontrol edin.

```bash
journalctl -fu tracksd -o cat
```

## 10. Node.js ve Gerekli Modüllerin Kurulumu
> Nodejs versiyonunuz v20.X.X olmalıdır.

Node.js ve gerekli modülleri kurun.

```bash
cd
curl -sL https://deb.nodesource.com/setup_20.x | sudo -E bash -
apt-get install -y nodejs
apt install nodejs npm
npm install web3@1.5.3
```

---
### nodejs Hatası Alanlar Öncelikle Aşağıdakileri Yapsın
```bash
nvm ls
```
Yukarıdaki çıktıda mevcut olan sürümleri size verecek. Onun altında ise defaultt bölümünde büyük ihtimalle kullanılan version 18 olarak gözükecek.
Default olanı değiştirmek için sizdeki en yüksek sürümü yazacaksınız. 22.4.0 
```bash
nvm use v22.4.0
```
Eğer hata devam ederse aşağıdaki çözüme geçebilirsiniz.

### Dikkat, Nodejs hatası alanlar bu komutları kullansın.
```bash
apt-get purge nodejs npm
apt-get autoremove --purge
rm -rf /usr/local/lib/node_modules
rm -rf /usr/local/bin/npm
rm -rf /usr/local/share/man/man1/node.1.gz
```
### Kurulum
```
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
apt-get install -y nodejs
apt install nodejs npm
npm install web3@1.5.3
```
### Versiyonu kontrol edin.
```
nodejs --version
```
NOT: versiyonunuz v20.X.X olmalıdır.
---

## 11. Airchains Scriptlerinin Çalıştırılması

Gerekli scriptleri indirip çalıştırın. İlk olarak 20.sh scriptini çalıştırın.

```bash
chmod +x 20.sh && ./20.sh
```

20 cüzdan oluşturacak ve sonunda token gönderip keyleri verecektir. Keyleri kaydedin.

Bakiye kontrolü için aşağıdaki scripti çalıştırın.

```bash
chmod +x balance.sh && ./balance.sh
```

20 cüzdana tx gönderme için 20.js scriptini çalıştırın.

```bash
screen -S 20
```
```bash
chmod +x 20.js && node 20.js
```

Burada 20 cüzdana tx gönderilecektir. 20 private keyi yazıp gönderilecek adresi, miktarı ve süreyi belirlemeniz gerekmektedir. İşlemler başarılı -yani success- oluyorsa CTRL + A, D ile çıkabilirsiniz.
> Gönderilecek -hedef- cüzdan herhangi bir evm cüzdanınız olabilir.
> tevmos adedi: 0.001 ya da 0.002 olabilir.
> Saniyeyi, 15 sn olarak ayarlamanız gerekli.

## 12. Restart Scriptlerinin Ayarlanması

Restart scriptlerini ayarlayın.

```bash
chmod +x check_tracksd.sh rpc.sh nilvrf.sh vrf.sh initvrf.sh transvrf.sh
```

Komutları tek tek yerine direkt girebilirsiniz.

```shell
(crontab -l 2>/dev/null; echo "*/3 * * * * /root/check_tracksd.sh >> /root/tracksd_check.txt 2>&1") | crontab -
(crontab -l 2>/dev/null; echo "*/3 * * * * /root/rpc.sh") | crontab -
(crontab -l 2>/dev/null; echo "*/3 * * * * /root/vrf.sh") | crontab -
(crontab -l 2>/dev/null; echo "*/3 * * * * /root/initvrf.sh") | crontab -
(crontab -l 2>/dev/null; echo "*/3 * * * * /root/nilvrf.sh") | crontab -
(crontab -l 2>/dev/null; echo "*/3 * * * * /root/transvrf.sh") | crontab -
service cron start
```
## 13. Rollback İşlemleri

Eğer restart scriptleri hatayı çözemiyorsa rollback yapmanız gerekir.

```bash
service cron stop && systemctl stop tracksd
```

Tracks dizinine geçip güncellemeleri çekin ve tekrar derleyin.

```bash
cd tracks
git pull
make build
```

Aşağıdaki komutu 5-6 defa çalıştırın.

```bash
go run cmd/main.go rollback
```

Son olarak, servisi yeniden başlatın ve cron'u aktif hale getirin.

```bash
systemctl restart tracksd && service cron start
```

Logları kontrol edin.

```bash
journalctl -u tracksd -f --no-hostname -o cat
```
## 13a. Otomatik rollback islemi(her 6 saatte bir rollback islemi yapar)

Alternatif olarak burdaki rollback.sh dosyasini indirin ve calistirma izni verin.

```bash
chmod +x rollback.sh
```

daha sonra crontab dosyasinin sonuna su kodlari ekleyin:

```bash
(crontab -l 2>/dev/null; echo "0 */6 * * * /root/rollback.sh") | crontab -

service cron restart
```

> Elle çalıştırmak isterseniz
```bash
cd $HOME
./rollback.sh
```

### RPC değişimi

```shell
RPC="rpcyazın"
sed -i "s|JunctionRPC = \".*\"|JunctionRPC = \"$RPC\"|" ~/.tracks/config/sequencer.toml
systemctl restart tracksd
```

#### Ekleyebileceğiniz RPC'ler
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

## Her şeyi Silip Baştan Kurmak İsterseniz
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
