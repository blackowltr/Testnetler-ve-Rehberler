# Nibiru (nibiru-itn-2) Node Kurulum

![6565yy](https://github.com/brsbrc/Testnetler-ve-Rehberler/assets/107190154/f05367a7-b1db-4ba7-96a2-7f75ef02ba15)

### Sistem Gereksinimleri
> Burada yazan gereksinimler önerilen gereksinimlerdir. İlla 1000GB alana sahip bir sunucu kullanmanız gerekmiyor. Rehberde kurulum yaparken indexer kapatma ve Pruning ayarlarını da yapmış olacaksınız. Bu sayede yüksek disk kapasitesi olmayan bir sunucuya da kurabilirsiniz. Örn: 400GB-600GB gibi.

|CPU | RAM  | Disk  | 
|----|------|----------|
|   4| 16GB  | 1TB    |

## [Resmi Doküman](https://nibiru.fi/docs/run-nodes/testnet/)
## [Nibiru Discord](https://discord.gg/nibirufi)
## [Nibiru Twitter](https://twitter.com/NibiruChain)
## [BlackOwl Twitter](https://twitter.com/brsbtc)

## Tarayıcı: 

https://explorer.nibiru.fi/

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------

**Adım 1: Güncelleme ve Kütüphane Kurulumu**
>Öncelikle sistemi güncelleyin ve gerekli kütüphaneleri kurun. Bu komut, sistem paketlerini güncelleyecek, gerekli araçları ve kütüphaneleri yükleyecektir.

```bash
sudo apt update && sudo apt upgrade -y && sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential bsdmainutils git make ncdu gcc git jq chrony liblz4-tool -y
```

**Adım 2: Go Kurulumu**
>Go programlama dilini kurun. Bu adımda, belirli bir Go sürümünü indirecek ve kuracaksınız.

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

**Adım 3: Nibid Kurulumu**
>Nibid'i kurun. Bu komut, Nibid'in belirli bir sürümünü indirecek ve kurulumunu yapacaktır.

```bash
curl -s https://get.nibiru.fi/@v0.21.9! | bash
```

**Adım 4: Versiyon Kontrolü**
>Kurulumun başarılı olduğunu doğrulayın. Nibid'in versiyonunu kontrol edin.

```bash
nibid version
```

**Adım 5: Initialize İşlemi**
>Nibid'i başlatmak için gerekli ayarları yapın. "NODEADINIZ" yazan yere kendi isminizi yazın.

```bash
nibid init NODEADINIZ --chain-id=nibiru-itn-2 --home $HOME/.nibid
```

**Adım 6: Genesis Dosyası**
>Genesis dosyasını indirin ve yapılandırma dosyasına ekleyin.

```bash
NETWORK=nibiru-itn-2
curl -s https://networks.itn2.nibiru.fi/$NETWORK/genesis > $HOME/.nibid/config/genesis.json
```

**Adım 7: Seed ve Peers Ayarı**
>Seed ve Peers ayarlarını yapılandırma dosyasına ekleyin.

```bash
NETWORK=nibiru-itn-2
seeds=$(curl -s https://networks.itn2.nibiru.fi/$NETWORK/seeds)
sed -i 's|seeds =.*|seeds = "'$seeds'"|g' $HOME/.nibid/config/config.toml
peers="02ddb201a1ceca73e43647d53a82a0342a6532ab@148.251.90.138:11656,9a3d3357c38dc553e0fd2e89f9d2213016751fb5@176.9.110.12:36656,111dd6b7ac9d0f80d7a04ce212267ce95cb913e9@195.201.76.69:26656,7d443bfaec2780c72319ea7de03c09e0a9c9fbfc@78.46.103.246:26656,faf332f0f0e56398314935a1b72de2e0a70ddd82@91.107.214.162:26656,ea516128d449c0a6a3c042a32020c98203b7b501@188.166.29.139:26656,766ca434a82fe30158845571130ee7106d52d0c2@34.140.226.56:26656,8d2735274fddfd6f38585f94b748a91280086def@62.171.167.76:26656,c060180df8c01546c66d21ee307b09f700780f65@34.34.137.125:26656,2cbae8362c1953cbe7badac73dd547ae0854cb63@104.199.24.9:26656,7a0d35b3cb1eda647d57c699c3e847d4e41d890d@65.108.8.28:36656,081ff903784a3f1b69522d6167c998c88c91ce61@65.108.13.154:27656,96e26da24f2b70b1314301263477e1a3c8a159be@65.109.26.21:11656,d5519e378247dfb61dfe90652d1fe3e2b3005a5b@65.109.68.190:13956,c068c45ef902b35dd9ea4f6b82405e6ab2dfc730@65.109.92.241:11036,d092162ed9c61c9921842ff1fb221168c68d4872@65.109.65.248:27656,41bb02a3e2b60761f07ddcc7138bcf17b6a1eda9@65.109.90.171:27656,0269836fc9a3db6b34828c57d9130b62cbbf59f2@134.249.103.215:26656,142142567b8a8ec79075ff3729e8e5b9eb2debb7@35.195.230.189:26656,ac163da500a9a1654f5bf74179e273e2fb212a75@65.108.238.147:27656,e36ada54e3d1e7c05c1c3b585b4235134aa185ef@65.108.206.118:60656,fac29c5446afa4c44285394468172fe423d3a5f4@188.40.106.246:46656,16827b8ba8a336adea0bdabb6ea5be7cb8db471b@136.169.209.32:26656"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$peers\"|" $HOME/.nibid/config/config.toml
```

**Adım 8: Minimum Gas Price Ayarı ve Prometheus Ayarı**
>Minimum gas price ayarını ve Prometheus ayarını yapın.

```bash
sed -i 's/minimum-gas-prices =.*/minimum-gas-prices = "0.025unibi"/g' $HOME/.nibid/config/app.toml
sed -i 's|^prometheus *=.*|prometheus = true|' $HOME/.nibid/config/config.toml
```

**Adım 9: Indexer Kapatma (Opsiyonel)**
>Indexer'ı kapatma (disk kullanımını azaltma) ayarını yapmak isterseniz, aşağıdaki komutu kullanın.

```bash
indexer="null"
sed -i -e "s/^indexer *=.*/indexer = \"$indexer\"/" $HOME/.nibid/config/config.toml
```

**Adım 10: Pruning Ayarları (Opsiyonel)**
>Pruning ayarlarını yapılandırmak isterseniz, aşağıdaki komutları kullanın.

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

**Adım 11: Unsafe Reset**
>Chain verisini sıfırla
```bash
nibid tendermint unsafe-reset-all --home $HOME/.nibid --keep-addr-book
```

**Adım 12: Servis Dosyası Oluşturma ve Başlatma**
>Nibid'i bir servis olarak başlatmak için aşağıdaki komutları kullanın.

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

**Adım 13: Log Kontrol**
>Nibid servisinin günlüklerini kontrol etmek için aşağıdaki komutu kullanın.

```bash
sudo journalctl -u nibid -f -o cat
```

**Adım 14: Sync Durumu Kontrolü**
>Nibid'in senkronizasyon durumunu kontrol edin.

```bash
nibid status 2>&1 | jq .SyncInfo
```

**Cüzdan Oluşturma**

1. KEPLR'da Yeni Test Ağını Eklemek

   - Önce eski "nibiru-itn-1" ağını kaldırın ve [KEPLR web sitesine](https://app.nibiru.fi/) giderek yeni test ağını ekleyin. Siteye bağlandığınızda, yeni test ağı otomatik olarak eklenir.

2. Cüzdanı İçe Aktarın

   - Nibiru cüzdanınızı içe aktarmak için aşağıdaki komutu kullanın ve "CUZDAN" yerine cüzdan adınızı yazın:

   ```bash
   nibid keys add CUZDAN --recover
   ```

3. Faucet ile Test UNIBI Alın

   - [Nibiru Discord sunucusuna](https://discord.gg/nibirufi) veya [Faucet web sitesine](https://app.nibiru.fi/faucet) giderek test UNIBI alabilirsiniz.

**Validator Oluşturma**

4. Validator Oluşturma

   - Kendi validator düğümünüzü oluşturmak için aşağıdaki komutu kullanın. Özellikle "NODEADINIZ", "KEYBASEID" "CÜZDANADINIZ", ve "WEBSITEADRESİNİZ" parametreleri kendi bilgilerinizle doldurun:

   ```bash
   nibid tx staking create-validator \
   --amount 1000000unibi \
   --pubkey $(nibid tendermint show-validator) \
   --moniker "NODEADINIZ" \
   --identity "KEYBASEID" \
   --website "WEBSITEADRESİNİZ" \
   --chain-id nibiru-itn-2 \
   --commission-rate 0.05 \
   --commission-max-rate 0.20 \
   --commission-max-change-rate 0.01 \
   --min-self-delegation 1 \
   --from CUZDANADINIZ \
   --gas-adjustment 1.4 \
   --gas auto \
   --gas-prices 0.025unibi \
   -y
   ```

**Faydalı Komutlar**

5. Kendi ya da Başka Validatore Delege Etme

   - Kendi ya da başka bir validatora UNIBI delegesi yapmak için aşağıdaki komutu kullanabilirsiniz. İlgili adresleri ve miktarı doldurmayı unutmayın:

   ```bash
   nibid tx staking delegate VALOPERADRESİNİZİYAZIN 1000000unibi --from CÜZDANADINIZIYAZIN --chain-id nibiru-itn-2 --gas-adjustment 1.4 --gas auto --gas-prices 0.025unibi -y
   ```

6. Redelege

   - Delegasyonunuzu yeniden düzenlemek için aşağıdaki komutu kullanabilirsiniz:

   ```bash
   nibid tx staking redelegate gönderenvaloper alıcıvaloperadres 10000000unibi --from CÜZDANADINIZIYAZIN --chain-id nibiru-itn-2 --gas-adjustment 1.4 --gas auto --gas-prices 0.025unibi -y
   ```

7. Cüzdandan Cüzdana Transfer

   - UNIBI transferi yapmak için aşağıdaki komutu kullanabilirsiniz:

   ```bash
   nibid tx bank send GÖNDERENADRES ALICIADRES 10000000unibi --from CÜZDANADINIZIYAZIN --chain-id nibiru-itn-2 --gas-adjustment 1.4 --gas auto --gas-prices 0.025unibi -y
   ```

8. Biriken Ödülleri Toplama

   - Ödüllerinizi toplamak için aşağıdaki komutu kullanabilirsiniz:

   ```bash
   nibid tx distribution withdraw-all-rewards --from CÜZDANADINIZIYAZIN --chain-id nibiru-itn-2 --gas-adjustment 1.4 --gas auto --gas-prices 0.025unibi -y
   ```

9. Unbound

   - UNIBI'yi çözme işlemi için aşağıdaki komutu kullanabilirsiniz:

   ```bash
   nibid tx staking unbond VALOPERADRESİNİZ 1000000unibi --from CÜZDANADINIZ --chain-id nibiru-itn-2 --gas-prices 0.1unibi --gas-adjustment 1.5 --gas auto -y 
   ```

10. Oy Kullanma

    - Bir teklife "yes" oy vermek için aşağıdaki komutu kullanabilirsiniz:

    ```bash
    nibid tx gov vote 1 yes --from CÜZDANADINIZIYAZIN --chain-id nibiru-itn-2 --gas-adjustment 1.4 --gas auto --gas-prices 0.025unibi -y
    ```

11. Unjail

    - Jailed bir validatoru serbest bırakmak için aşağıdaki komutu kullanabilirsiniz:

    ```bash
    nibid tx slashing unjail --from CÜZDANADINIZIYAZIN --chain-id nibiru-itn-2 --gas-adjustment 1.4 --gas auto --gas-prices 0.025unibi -y
    ```

12. Validator Düzenleme

    - Mevcut bir validatoru düzenlemek için aşağıdaki komutu kullanabilirsiniz:

    ```bash
    nibid tx staking edit-validator \
    --new-moniker YENİADINIZIYAZIN \
    --identity KEYBASE.IO ID'NİZ \
    --details "AÇIKLAMA" \
    --website "WEBSİTEADRESNİZ" \
    --chain-id nibiru-itn-2 \
    --gas-prices 0.025unibi \
    --from CÜZDANADINIZ
    ```

**Node Silme Komutları**

13. Node Silme Komutları

    - Nibiru node'unu tamamen kaldırmak için aşağıdaki komutları kullanabilirsiniz:

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

### Herkese Kolay Gelsin.

