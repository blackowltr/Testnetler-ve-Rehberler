# Nibiru (nibiru-itn-3) Node Kurulum

## Faydalı Bağlantılar

- [Resmi Doküman](https://nibiru.fi/docs/run-nodes/testnet/)
- [Nibiru Discord](https://discord.gg/nibirufi)
- [Nibiru Twitter](https://twitter.com/NibiruChain)
- [Tarayıcı](https://explorer.nibiru.fi/)
- [BlackOwl Twitter](https://twitter.com/brsbtc)

**Bu bağlantıları kullanarak Nibiru hakkında daha fazla bilgi edinebilirsiniz!**

## Sistem Gereksinimleri

| **CPU** | **RAM** | **Disk** |
|---------|---------|----------|
| 4 çekirdek | 16GB RAM | 1TB depolama |

# Nibiru itn-3 kurulum rehberine Hoş Geldiniz!

Merhaba! Bu rehber için sizlerden ufak bir ricam var.

1. Rehberi yıldızlayın!
   - Rehberi beğendiyseniz, lütfen yıldız eklemeyi unutmayın. Bu, rehberin daha fazla kişi tarafından görülmesine yardımcı olur.

2. Rehberi forklayın ve siz de geliştirmeye başlayın!
   - Kendi GitHub hesabınıza bu rehberi forklayarak üzerinde çalışabilir, yeni özellikler ekleyebilir ve hataları düzeltebilirsiniz.

3. Değişikliklerinizi benimle paylaşın!
   - Yaptığınız değişiklikleri bu projeye geri göndermek için bir pull request oluşturun. Değişikliklerinizi inceleyip rehbere entegre etmekten mutluluk duyarı.

Teşekkürler! Bana verdiğiniz destek için minnettarım. 

İyi çalışmalar! 

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------

<h1 align="center">Kurulum</h1>

<p align="center">Rehberi adım adım takip edin.</p>

**Adım 1: Güncelleme ve Kütüphane Kurulumu**
>Öncelikle sistemi güncelleyin ve gerekli kütüphaneleri kurun. Bu komut, sistem paketlerini güncelleyecek, gerekli araçları ve kütüphaneleri yükleyecektir.

```
sudo apt update && sudo apt upgrade -y && sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential bsdmainutils git make ncdu gcc git jq chrony liblz4-tool -y
```

**Adım 2: Go Kurulumu**
>Go programlama dilini kurun. Bu adımda, belirli bir Go sürümünü indirecek ve kuracaksınız.

```
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

```
cd $HOME
rm -rf nibiru
git clone https://github.com/NibiruChain/nibiru.git
cd nibiru
git checkout v0.21.10
make install
```

**Adım 4: Versiyon Kontrolü**
>Kurulumun başarılı olduğunu doğrulayın. Nibid'in versiyonunu kontrol edin.

```
nibid version
```

**Adım 5: Initialize İşlemi**
>Nibid'i başlatmak için gerekli ayarları yapın. "NODEADINIZ" yazan yere kendi isminizi yazın.

```bash
nibid init NODEADINIZ --chain-id=nibiru-itn-3 --home $HOME/.nibid
```

**Adım 6: Genesis ve Addrbook Dosyası**
>Genesis ve addrbook dosyasını indirin ve yapılandırma dosyasına ekleyin.

```
curl -Ls https://ss-t.nibiru.nodestake.top/genesis.json > $HOME/.nibid/config/genesis.json 
curl -Ls https://ss-t.nibiru.nodestake.top/addrbook.json > $HOME/.nibid/config/addrbook.json
```

**Adım 7: Seed ve Peers Ayarı**
>Seed ve Peers ayarlarını yapılandırma dosyasına ekleyin.

```
peers="306b7549a5fd41c77a1695dea306292ffae38d8b@34.38.59.17:26656,4bff31485a402a0e2bd2c0671f9056ed2cb60478@34.77.52.8:26656,6052d09554a442f22f71c33dbc5f25bee538e087@65.109.82.249:28656,d5519e378247dfb61dfe90652d1fe3e2b3005a5b@65.109.68.190:13956,044a7d256f86502dde98a41c316ee35ecc4fa038@95.217.198.190:11656,c01be69fdaf3efb04c4d4c7e7ea8a1dc6c4e9831@95.217.35.112:11656,c89f80e6f8dd254b905d14eaeb574dd3bb2ca0a7@95.216.96.115:11656,ab1f5a09ca1521cb71bac55ec5ac6d89435c090c@65.21.76.104:11656,4eb5f6172ae72af481a4a7103f4acb3caa21d76a@88.99.94.44:11656,ab1f5a729cdb5cc21256e81416e459747aa88e97@148.251.91.16:11656,3000353cb772b2aad18d07479185ab2e159114b0@95.217.105.54:11656,ec679c03b4d066fe22e16055f6d20fef99bb949d@94.130.135.112:11656,14642dc20de4841b4c89845d9c0515721da329a1@95.217.84.7:11656,3e2cfd0e743fcfaba59d37915d2379f9e3098524@95.217.46.56:11656,ed21fa911d4e09f4fa3b22ea8414d83fcfcc631f@95.217.57.33:11656,43dbd550727bdaf41fc56cb36df11eb54fdb43a1@176.9.0.48:11656,68ac62b38723c8ec87d2cf1c61c28b00178a42e5@94.130.34.60:11656,5b55e611d10e53376301c1e7731be46d901b86a8@144.76.162.231:11656,723fee27a7d10cd47ae8025aa975fc20e19cb790@135.181.217.249:11656,dc674b8cde230fe4050f7bf8bab18396ef747cd8@116.202.210.90:11656,d5c6a1cf32808af900b4728949331d2e7f6e847f@5.9.138.165:11656,e1978fb3404a1b54c64ef1586ff1f43c204ebd9f@95.217.47.60:11656,47e072b9727d032d08727346174329a87725076c@135.181.138.224:11656,6c6217df2132eb7f7935c2324f1e523ad7db082d@65.108.75.107:33656,2792592c05aa270b61ae3cacf5d0519a5f9a46fe@135.181.222.108:11656,f1697eaa6d481289fd9aeec33feed8e79213846d@88.99.115.105:11656,af6e18e66451977bdfbec38d4a37ba5cc4be36ff@65.21.141.155:11656,e81abdcb29a19749e31cea0412c393ed330c3ce0@178.63.95.122:11656,c72c047e643ea4fc90ff9a2ad907cac983a59b62@65.21.141.248:11656,a8fd07952f5fdd95be2ece5a8c8064f60e951d80@178.63.41.62:11656,98a740724f2d9e660b871859e4556224b0295bc3@88.99.167.59:11656,458ed65dc03a0eb0601f6fd8afcd175a582f589c@135.181.181.120:11656,ab2226f5a58e1034f4a9f69c5fc7b7b11124f884@135.181.216.112:11656,91cc2e28a88820923ae10f03f6f6127e9ef721d4@95.216.77.58:11656,1d419d40399295b9899d4ea7dddb515378891526@95.217.57.76:11656,4107117f76ebbd0795f44dbbdd02b82a8a96f36e@95.216.246.139:11656,fcc4d23b184c6dc8e455b47297c53401bea840d2@138.201.58.93:11656,b8e9585b55f7b24e822bfba0a04f008e4f49c633@95.217.57.228:11656,8825b79f5610daea5ce745aed719ef2cbd198878@95.217.39.116:11656,552fa8073051b32fa6b888882ff0e77b762d4580@65.21.141.101:11656,ab2d6168c41c3482807abc82ce23087bafbbac38@78.46.87.55:11656,b8df9449470d138556f7ee9de11c815f3aa00839@95.217.40.249:11656,ccaddd04ddad4be3fa73b64de1858f1101954761@46.4.101.90:11656,d1f815deb6a64ea6c3b99507ad6c3b471eba42f1@95.217.88.223:11656,80ee0e7cc35a15ae12d1fe00f991d0f76fadf174@195.201.173.91:11656,5a51c1b4ac94edd4a62f7e416388cea257f55aa4@195.201.199.50:11656,325dedb1e94c679f52d84e443168059fa7fe35ae@65.21.235.185:11656,60c57abee12861b1a665da75242de428c5aae1dc@95.217.83.240:11656,a92d331b4a3c168fb5998fe03b6f04d15858637a@95.217.88.81:11656,6a5befe831443e1fc2259100cdcccf9a534b8de5@80.254.8.54:26656,999f47093de4b6f7fefeaaa43c7240f9b539423d@88.99.70.183:11656,eda26b4e5d73dc67937d8072195ffab54964e4c8@178.63.103.56:11656,ca7fd036c17c8a95f38d626c8151a2bdd355afba@95.217.107.213:11656,cf6fe19cd1457822397e38b0ee6eb490d33d8ecd@135.181.211.202:11656,f99e05b0a8c5dbee04093601e0c7f4fd6bac73fe@95.216.33.155:11656,f147e5f490df8be99a852f25522d0ce87f102b19@195.201.171.182:11656,338553c10ce0e4d100383b2acc8dec5455214e8b@78.46.33.202:11656,1b0cb92ab8edaf05498d3c568d7a7d5845b7427c@65.21.202.160:11656,308f7e49e241a7c8ab142754b19db355df182780@95.217.57.203:11656,2c6de8f5183330c21754a68836d06a3969ca31e8@95.217.89.100:11656,6a695be5eac4b957f5e2f5052c585f0fab5c958c@65.21.123.218:11656,6a85ca2da8e02eccd8333244db18b384fd5775e5@168.119.64.20:19856,729949706e9947e5b7aa10a411a9d2b96e5fe42b@34.77.50.246:26656,97b3bfe0ca018e56d67353463c81a06ceeebad3e@213.133.110.82:11656,afe1a8d392b2caaa02c51165dd2b37e0181dacf9@65.108.72.233:21656,6ff80258704e55f8d8f8a7a52189d0eeb7a726ea@135.181.142.93:11656,67294cc6ca6ae617af4cdb22b12ecb8d6e57f2d7@165.22.72.7:26656,8e0e6c1583153282d07511d3ea13e53f6ce77b51@162.55.234.70:55356,1950737470bd21ec7e339d5db38a3812448a0fd9@78.46.86.188:11656,1d38aea3087e92752773127300bab5e3696395db@95.217.114.180:11656,66fbf61ae0f61b8733ef7c9cd3f0b5a09241fff9@148.251.54.202:11656,24c47bda071750485494237476530d3940e53ee2@135.181.182.89:11656,2032c0663fb43bc45b69f079131eb1517a3266e4@31.220.75.138:30656,fde9af88d74140323540fa4e3480ed22187fee5e@34.140.142.102:26656,7116f02fc8e94b027716ddcc3048a0b0ac3e26e0@135.181.140.175:11656,6879d778ba201582dfd190e25d770cf047979b57@135.181.140.158:11656,4db96a2899d48215edbb4b0cbdb3a403954f5b83@95.216.37.117:11656,5a03ec54426344267927a4776c6c1143452aa574@95.216.116.57:11656,fbb57fa3d1ce3c8b32d1547d558852ad792d9a49@5.9.111.153:11656,58a7601262b3505411b48215511d98043f0ddb26@95.216.244.142:11656,73dd43a0d99ed8c2cfcee4eeaf5b55589dbd191f@95.217.144.105:11656,c709cad9e11b315644fe8f1d2e90c03c5cba685c@79.168.171.177:26656,507594862b417a89409f29c8e509e88f8b8d904d@65.108.68.119:13956,8bf9948e69aacf49961b8ef9305cceefda56cb26@35.241.192.44:26656,ae05085a3b3d09dd3a5e074a8af51b219d878542@138.201.18.44:11656,2f974a69f9d140a9e85d80ce185d6297d1f35c7e@135.181.164.150:11656,53530fabd75f0b9d066cc9c22fa9df2d904e6514@116.202.193.198:11656,601a62385466333d350b30223998cebda15abd3f@65.21.202.212:11656,081ff903784a3f1b69522d6167c998c88c91ce61@65.108.13.154:27656,e08089921baf39382920a4028db9e5eebd82f3d7@142.132.199.236:21656,f0ed83d79311fae98d091ad406ebf05451b6316e@135.181.138.231:11656,49d99cdbb968bf2a209b9c787c363c8cb49d30ee@148.251.1.154:11656,111dd6b7ac9d0f80d7a04ce212267ce95cb913e9@95.217.140.17:26656,dec66e7bc857f95a407bd7db779d255ef77bbf0f@65.109.135.235:26656,87c70eebba41c360feee53c4aaf253d9086261a8@159.69.142.175:11656,c025f741b21458433bbefe36e84ccf790a9b049d@65.109.92.148:26656,141f624174152cb55489088587df67cdc04b3e16@65.21.91.203:11656,ad78382e5a62af25fb67567dddb657ce538e9c5a@148.251.90.138:11656,7f8bd4eaf6b9b213fd7b89ceefc517bcaa517d24@5.9.147.22:22656,bbe3dd5571e24bbe68f44127d61060d62777769f@65.108.44.238:11656,209386ffd4b9896f52227385a15c41d7ab27764e@65.21.199.74:11656,478d5c9b81ae055e465a5b41f82f1fdd2cdd2dc8@135.181.210.94:11656,4b301623153e8bcc236873a65b2cee45bd5453ab@65.108.126.226:26656,835396eefd533c5ebf3b91dc53a05a42544eb1ea@65.21.229.91:11656,3b26b81bcaa33b6cde72d478d11f5aa45d448b3d@88.198.48.112:11656,581dd3bb619fbdb927781464ef0b0836daf92c22@195.201.175.24:11656,689a0abf3c818bf18ad91519e731f3d0b76453ee@65.108.197.164:56101"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$peers\"|" $HOME/.nibid/config/config.toml
```

**Adım 8: Minimum Gas Price Ayarı ve Prometheus Ayarı**
>Minimum gas price ayarını ve Prometheus ayarını yapın.

```
sed -i -e "s|^minimum-gas-prices *=.*|minimum-gas-prices = \"0.025unibi\"|" $HOME/.nibid/config/app.toml
sed -i 's|^prometheus *=.*|prometheus = true|' $HOME/.nibid/config/config.toml
```

**Adım 9: Indexer Kapatma (Opsiyonel)**
>Indexer'ı kapatma (disk kullanımını azaltma) ayarını yapmak isterseniz, aşağıdaki komutu kullanın.

```
indexer="null"
sed -i -e "s/^indexer *=.*/indexer = \"$indexer\"/" $HOME/.nibid/config/config.toml
```

**Adım 10: Pruning Ayarları (Opsiyonel)**
>Pruning ayarlarını yapılandırmak isterseniz, aşağıdaki komutları kullanın.

```
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
```
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

   - Önce eski "nibiru-itn-2" ağını kaldırın ve [Nibiru web sitesine](https://app.nibiru.fi/) giderek yeni test ağını ekleyin. Siteye bağlandığınızda, yeni test ağı otomatik olarak eklenir.

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
   --chain-id nibiru-itn-3 \
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
   nibid tx staking delegate VALOPERADRESİNİZİYAZIN 1000000unibi --from CÜZDANADINIZIYAZIN --chain-id nibiru-itn-3 --gas-adjustment 1.4 --gas auto --gas-prices 0.025unibi -y
   ```

6. Redelege

   - Delegasyonunuzu yeniden düzenlemek için aşağıdaki komutu kullanabilirsiniz:

   ```bash
   nibid tx staking redelegate gönderenvaloper alıcıvaloperadres 10000000unibi --from CÜZDANADINIZIYAZIN --chain-id nibiru-itn-3 --gas-adjustment 1.4 --gas auto --gas-prices 0.025unibi -y
   ```

7. Cüzdandan Cüzdana Transfer

   - UNIBI transferi yapmak için aşağıdaki komutu kullanabilirsiniz:

   ```bash
   nibid tx bank send GÖNDERENADRES ALICIADRES 10000000unibi --from CÜZDANADINIZIYAZIN --chain-id nibiru-itn-3 --gas-adjustment 1.4 --gas auto --gas-prices 0.025unibi -y
   ```

8. Biriken Ödülleri Toplama

   - Ödüllerinizi toplamak için aşağıdaki komutu kullanabilirsiniz:

   ```bash
   nibid tx distribution withdraw-all-rewards --from CÜZDANADINIZIYAZIN --chain-id nibiru-itn-3 --gas-adjustment 1.4 --gas auto --gas-prices 0.025unibi -y
   ```

9. Unbound

   - UNIBI'yi çözme işlemi için aşağıdaki komutu kullanabilirsiniz:

   ```bash
   nibid tx staking unbond VALOPERADRESİNİZ 1000000unibi --from CÜZDANADINIZ --chain-id nibiru-itn-3 --gas-prices 0.1unibi --gas-adjustment 1.5 --gas auto -y 
   ```

10. Oy Kullanma

    - Bir teklife "yes" oy vermek için aşağıdaki komutu kullanabilirsiniz:

    ```bash
    nibid tx gov vote 1 yes --from CÜZDANADINIZIYAZIN --chain-id nibiru-itn-3 --gas-adjustment 1.4 --gas auto --gas-prices 0.025unibi -y
    ```

11. Unjail

    - Jailed bir validatoru serbest bırakmak için aşağıdaki komutu kullanabilirsiniz:

    ```bash
    nibid tx slashing unjail --from CÜZDANADINIZIYAZIN --chain-id nibiru-itn-3 --gas-adjustment 1.4 --gas auto --gas-prices 0.025unibi -y
    ```

12. Validator Düzenleme

    - Mevcut bir validatoru düzenlemek için aşağıdaki komutu kullanabilirsiniz:

    ```bash
    nibid tx staking edit-validator \
    --new-moniker YENİADINIZIYAZIN \
    --identity KEYBASE.IO ID'NİZ \
    --details "AÇIKLAMA" \
    --website "WEBSİTEADRESNİZ" \
    --chain-id nibiru-itn-3 \
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
