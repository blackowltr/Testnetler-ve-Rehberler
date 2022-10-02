# NuLink Worker Update

![NULINK - UPDATE](https://user-images.githubusercontent.com/107190154/193439759-3910565f-e794-48a8-9408-36ceab53d9db.gif)

### Port ayarı için
 ```
 sudo su
 sudo ufw enable
 sudo ufw allow 9152
 ```

### Stake ve worker hesabınız varsa

Sadece node'u durdurun, en son NuLink image dosyasını çekin ve node'u yeniden başlatın.
1. Çalışan node'u durduralım
> container ID öğrenmek için `docker ps` yazıp çıkan kısma göz atabilirsiniz.
 ```
docker kill container ID
 ```

2. NuLink image dosyasını çekelim
```
docker pull nulink/nulink:latest
```

3.  Node'u yeniden başlatalım
```
docker run --restart on-failure -d \
--name ursula \
-p 9151:9151 \
-v /root/nulink:/code \
-v /root/nulink:/home/circleci/.local/share/nulink \
-e NULINK_KEYSTORE_PASSWORD \
-e NULINK_OPERATOR_ETH_PASSWORD \
nulink/nulink nulink ursula run --no-block-until-ready
```

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

### Stake ve worker hesabınız yoksa ya da kaybettiyseniz

1. Docker'da çalışan node'u durdurup ardından kaldırıyoruz
> container ID öğrenmek için `docker ps` yazıp çıkan kısma göz atabilirsiniz.
```
docker kill container ID
docker rm container ID
 ```

2. NuLink image dosyasını çekelim
```
docker pull nulink/nulink:latest
```

3. Eski klasörü kaldırıp yenisini oluşturalım 
```
cd /root
```
```
rm -rf nulink
```
```
mkdir nulink
```

4.  Copy the keystore file of the Worker account to the host directory selected in step 3.(if you lost the old worker account, you could generate a new one and copy the keystore file of the new worker account here) **Please ensure that this directory has 777 permissions**:
```
cp path of secret key kısmında yazanları girin /root/nulink
```
```
chmod -R 777 /root/nulink
   ```
5.  Şifrelerimizi ayarlayalım 
```
export NULINK_KEYSTORE_PASSWORD=8karakterlişifre

export NULINK_OPERATOR_ETH_PASSWORD=8karakterlişifre
```

6.  Node Konfigürasyonunu ayarlayacağız ve port değişikliği yapacağız 
```
docker run -it --rm \
-p 9152:9152  \
-v /root/nulink:/code \
-v /root/nulink:/home/circleci/.local/share/nulink \
-e NULINK_KEYSTORE_PASSWORD \
nulink/nulink nulink ursula init \
--signer keystore:///code/utcdenitibarenyazın \
--eth-provider https://data-seed-prebsc-2-s2.binance.org:8545 \
--network horus \
--payment-provider https://data-seed-prebsc-2-s2.binance.org:8545 \
--payment-network bsc_testnet \
--operator-address publicadresiniziyazın \
--max-gas-price 100
```

7.   Yeni yapılandırmayı kullanarak Node'u başlatalım

```
docker run --restart on-failure -d \
--name ursula \
-p 9152:9152 \
-v /root/nulink:/code \
-v /root/nulink:/home/circleci/.local/share/nulink \
-e NULINK_KEYSTORE_PASSWORD \
-e NULINK_OPERATOR_ETH_PASSWORD \
nulink/nulink nulink ursula run \
--rest-port 9152 \
--config-file /root/nulink/ursula.json \
 --no-block-until-ready
```

8.  Node'un çalışma durumunu kontrol edin ve yeni worker hesabını yeni staking hesabına bağlayın [NuLink Staking](https://test-staking.nulink.org/).

## [Nulink Türkiye Resmi Telegram Kanalı](https://t.me/NuLink_Turkey)
## Kendi [Telegram Sohbet](https://t.me/NotitiaGroup) ve [Duyuru Kanalım](https://t.me/NotitiaGroup)
## Herkese Kolay Gelsin..



