# Merhabalar, worker adresimizle yeni bir sunucuda node nasıl çalıştırabiliriz ondan bahsedeceğim.

## Öncelikle adımları dikkatli yaparsanız sorunsuz kurulum yapar ve taşımayı gerçekleştirirsiniz.

## Kurulum

### Öncelikle eski sunucumuza winscp ile bağlanıp `nulink` ve `geth-linux-amd64-1.10.24-972007a5` adlı klasörleri yedekleyin.

![Ekran görüntüsü 2022-10-05 154844](https://user-images.githubusercontent.com/107190154/194064102-f950319a-4012-4e1f-8b7e-adf02027840e.png)

```
sudo su
sudo ufw allow 9151
```
```
sudo apt-get update && apt-get upgrade -y
```
```
cd /root
```
```
sudo apt install docker.io -y
```
```
sudo systemctl enable --now docker
```
```
docker pull nulink/nulink:latest
```

### Yeni kullancağınız sunucunuza bağlanın ve az evvel yedeklediğiniz `nulink` ve `geth-linux-amd64-1.10.24-972007a5` adlı klasörleri yeni sunucuya taşıyın.

![Ekran görüntüsü 2022-10-05 150323](https://user-images.githubusercontent.com/107190154/194058580-0f9c5ec5-4454-4d5e-b4a1-2b6670b900c2.png)

### Taşıma bittikten sonra şu komutu yazıp devam edin.
```
rm -rf /root/nulink/ursula.json
```

### Bu kısma daha evvel kurulum yaparken size verilen bilgileri yazacağız. Örnek için görsele bakınız.

![Ekran görüntüsü 2022-10-05 153009](https://user-images.githubusercontent.com/107190154/194060618-6a3bd024-8f4b-4c4a-85b5-fad2d74227f5.png)

```
cp burayapathofthesecretkeyfileyazın /root/nulink
```
```
chmod -R 777 /root/nulink
```
```
export NULINK_KEYSTORE_PASSWORD=8karakterlişifre

export NULINK_OPERATOR_ETH_PASSWORD=8karakterlişifre
```

### Aaşağıdaki komutu yazmadan evvel signer keystore kısmına ve operator adress kısmına kendi bilginizi girin. Bu komuttan sonra y-n sorusuna y diyerek devam edin sonra seed kelimeleri oluşturacak onları yedekleyin ve yeniden y-n diyecek y diyerek devam edin az önce kopyaladığınız seed kelimelerinizi yazın ve enter'a basın.

```
docker run -it --rm \
-p 9151:9151 \
-v /root/nulink:/code \
-v /root/nulink:/home/circleci/.local/share/nulink \
-e NULINK_KEYSTORE_PASSWORD \
nulink/nulink nulink ursula init \
--signer keystore:///code/UTC-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX \
--eth-provider https://data-seed-prebsc-2-s2.binance.org:8545  \
--network horus \
--payment-provider https://data-seed-prebsc-2-s2.binance.org:8545 \
--payment-network bsc_testnet \
--operator-address publicadresiniziyazın \
--max-gas-price 100
```

### Tek seferde girin ve çalıştırın.

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

### Log Kontrol
```
docker logs -f ursula
```

### Site üzerinden kalan adımları yaparken unbound etmediyseniz önce unbound edin. Arından yeni sunucu ip ve eski worker adresinizi yazıp bond worker işlemini geröekleştirin.
**Not: Unbound 1 gün sürmektedir.**
