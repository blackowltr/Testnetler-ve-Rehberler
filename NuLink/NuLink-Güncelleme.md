# NuLink Worker Update

![NULINK - UPDATE](https://user-images.githubusercontent.com/107190154/193439759-3910565f-e794-48a8-9408-36ceab53d9db.gif)

 <h1 align="center">Halihazırda sunucusunda NuLink kurulu olanlar burada bulunan komutları kullanın. </h1>

## Kurulum

### Stake ve worker hesabınız varsa

Sadece node'u durdurun, en son NuLink image dosyasını çekin ve node'u yeniden başlatın.

**1. Çalışan node'u durduralım**
```
docker kill ursula
docker rm ursula
```
```
export NULINK_KEYSTORE_PASSWORD=mevcutşifreniz

export NULINK_OPERATOR_ETH_PASSWORD=mevcutşifreniz
```

**2. NuLink image dosyasını çekelim**
```
docker pull nulink/nulink:latest
```

**3.  Node'u yeniden başlatalım**
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

### Şu şekilde bir log çıktısı alıyorsanız, [NuLink Staking](https://test-staking.nulink.org/) buraya gidin ve bond worker işlemi yapın.

![image](https://user-images.githubusercontent.com/107190154/196955884-0323cfe1-f8ca-4cf7-82fb-f5fb772f706e.png)

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

 <h1 align="center">İlk defa kuracaksanız ya da sıfırdan bir kurulum yapacaksanız burada bulunan komutları kullanın. </h1>

### Stake ve worker hesabınız yoksa ya da kaybettiyseniz

## Kurulum

### Port ayarı için
 ```
 sudo su
 sudo ufw enable
 sudo ufw allow 9152
 ```

### Worker Hesabı OLuşturmak İçin

### Bize gerekli olan dosyayı indiriyoruz ve ayarları yapıp bir worker hesabı oluşturuyoruz.
```
wget https://gethstore.blob.core.windows.net/builds/geth-linux-amd64-1.10.24-972007a5.tar.gz

tar -xvzf geth-linux-amd64-1.10.24-972007a5.tar.gz

cd geth-linux-amd64-1.10.24-972007a5/

./geth account new --keystore ./keystore
```

### Docker'ı kuralım
```
sudo apt install docker.io -y
```
```
sudo systemctl enable --now docker
```

### Docker zaten sunucunuzda yüklü ise size şöyle bir çıktı verecektir:

![image](https://user-images.githubusercontent.com/107190154/195498531-9463f14e-c8b2-415f-adf9-17c0b22283c2.png)

**1. NuLink image dosyasını çekelim**
```
docker pull nulink/nulink:latest
```

**2. Eski klasörü kaldırıp yenisini oluşturalım**
```
cd /root
```
```
rm -rf nulink
```
```
mkdir nulink
```

**3.  Burada Path of the secret key file yazan kısımda gördüğünüz kısmı alıp cp den sonraki kısma yapıştırıyorsunuz. Aşağıda örnek şeklini gösterdim.**

**Örnek: cp /root/geth-linux-amd64-1.10.23-d901d853/keystore/UTC--2022-01-11T01-12-01.4XXXXXXXX--8XXXXXXXXXXXXXXXXXXXXXXXXXXX /root/nulink**

```
cp path of secret key kısmında yazanları girin /root/nulink
```
```
chmod -R 777 /root/nulink
```

**4. Şifrelerimizi ayarlayalım**
```
export NULINK_KEYSTORE_PASSWORD=8karakterlişifre

export NULINK_OPERATOR_ETH_PASSWORD=8karakterlişifre
```

**5. Node Konfigürasyonunu ayarlayacağız ve port değişikliği yapacağız** 
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

**6. Yeni yapılandırmayı kullanarak Node'u başlatalım**

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

### Başarılı Bir Kurulum Örneği:

![image](https://user-images.githubusercontent.com/107190154/193912627-c68faa7e-6455-4caa-8e6e-1d17720bc79e.png)

**7.  Node'un çalışma durumunu kontrol edin ve yeni worker hesabını yeni staking hesabına bağlayın [NuLink Staking](https://test-staking.nulink.org/).**

## [Nulink Türkiye Resmi Telegram Kanalı](https://t.me/NuLink_Turkey)
## Kendi [Telegram Sohbet](https://t.me/NotitiaGroup) ve [Duyuru Kanalım](https://t.me/NotitiaGroup)
## Herkese Kolay Gelsin..

