# Erbie Testnet Rehberi

![BlackOwlww](https://user-images.githubusercontent.com/107190154/195496348-fabca337-183d-4998-b56c-9527fcb57af0.gif)

### Sistem Gereksinimleri (Minimum)

![image](https://user-images.githubusercontent.com/107190154/193319079-00dd8efb-61ed-4dd7-8d74-f7713cccad12.png)

## [Orijinal Doküman](https://www.wormholes.com/docs/Install/run/index.html)

------------------------------------------------------------------------------------------------------------------

# <h1 align="center">Güncelleme ---- Son Güncelleme
> Bu komutları girin ve ardından alttaki güncelleme komutunu girip devam edin, arkadaşlar.
```
docker stop wormholes
docker rm wormholes
docker rmi wormholestech/wormholes:v1 
rm -rf /wm
```
> Güncelleme Komutu
```
wget -O erbie_install.sh https://docker.erbie.io/erbie_install.sh && sudo bash erbie_install.sh
```
--------------------------------------------------------------------------------------------------------------------------------------------------------------

## Bazı Komutlar

### Versiyon Kontrol : 
```
curl -X POST -H "Content-Type:application/json" --data '{"jsonrpc":"2.0","method":"eth_version","id":64}' http://127.0.0.1:8545
```
>Örnek çıktı: son güncelleme (10.08.2023 tarihinde yazıldı.)

### Log Kontrol Komutu
```
wget -O monitor.sh https://raw.githubusercontent.com/brsbrc/Testnetler-ve-Rehberler/main/Wormholes/monitor/monitor.sh && chmod +x monitor.sh && ./monitor.sh
```

### Bağlantı Durumu İçin
```
curl -X POST -H 'Content-Type:application/json' --data '{"jsonrpc":"2.0","method":"net_peerCount","id":1}' http://127.0.0.1:8545
```

### Blok Kontrol İçin
```
curl -X POST -H 'Content-Type:application/json' --data '{"jsonrpc":"2.0","method":"eth_blockNumber","id":1}' http://127.0.0.1:8545
```

### Bakiye Durumu Öğrenme
> cüzdanadresiniziyazın kısmına kendi adresinizi yazın.
```
curl -X POST -H 'Content-Type:application/json' --data '{"jsonrpc":"2.0","method":"eth_getBalance","params":["0xE860DD0F14e7a52Fa3012BfA00f4793edCe87EBe","pending"],"id":1}' http://127.0.0.1:8545
```

# <h1 align="center">Sıfırdan Kuracaklar İçin</h1>
```
sudo apt-get update && apt-get upgrade -y
```
```
cd /root
```
```
sudo apt install docker.io
```
```
sudo systemctl enable --now docker
```
```
wget -O erbie_install.sh https://docker.erbie.io/erbie_install.sh && sudo bash erbie_install.sh
```

### Sizden Kurulum sırasında private key isteyecek, peki bu keye nasıl ulaşabilirsiniz.

### Şu işarete basalım.
![Ekran görüntüsü 2022-09-30 202147](https://user-images.githubusercontent.com/107190154/193323716-ecd5d453-f3f1-49cd-931a-cc151b63d15b.png)

### Settings Kısmına girelim.
![image](https://user-images.githubusercontent.com/107190154/193324401-133be871-43b4-4ac5-8d9e-c0768f28f2c1.png)

### İşaretlediğim kısma tıklayın ve cüzdan şifrenizi yazın.
![Ekran görüntüsü 2022-09-30 202801](https://user-images.githubusercontent.com/107190154/193324554-fe77ddc7-17ea-4fa3-8e65-39d81b5e93ca.png)

### Karşınıza çıkan sizin private keyiniz.
![Ekran görüntüsü 2022-09-30 203010](https://user-images.githubusercontent.com/107190154/193324930-e56d9ccb-b5b4-4c87-8499-38982dbe81ac.png)


## Bazı Komutlar

### Log Kontrol Komutu
```
wget -O monitor.sh https://raw.githubusercontent.com/mesahin001/wormholes/master/monitor.sh && chmod +x monitor.sh && ./monitor.sh
```

### Bağlantı Durumu İçin
```
curl -X POST -H 'Content-Type:application/json' --data '{"jsonrpc":"2.0","method":"net_peerCount","id":1}' http://127.0.0.1:8545
```

### Blok Kontrol İçin
```
curl -X POST -H 'Content-Type:application/json' --data '{"jsonrpc":"2.0","method":"eth_blockNumber","id":1}' http://127.0.0.1:8545
```

### Bakiye Durumu Öğrenme
> cüzdanadresiniziyazın kısmına kendi adresinizi yazın.
```
curl -X POST -H 'Content-Type:application/json' --data '{"jsonrpc":"2.0","method":"eth_getBalance","params":["cüzdanadresiniziyazın","pending"],"id":1}' http://127.0.0.1:8545
```

## Node Kurduk şimdi şu adrese gidelim stake işlemini yapalım: https://www.limino.com/#/wallet

### Şu işarete basalım.
![Ekran görüntüsü 2022-09-30 202147](https://user-images.githubusercontent.com/107190154/193323716-ecd5d453-f3f1-49cd-931a-cc151b63d15b.png)

### `become a validator` kısmına girelim.

![Ekran görüntüsü 2022-09-30 202320](https://user-images.githubusercontent.com/107190154/193323898-b09a073f-8ff3-4a0b-a991-f63086818616.png)

### Stake işlemini Gerçekleştirelim.
> Minimum 70000 erb stake etmelisiniz.
![image](https://user-images.githubusercontent.com/107190154/193324020-c5330cd3-00ba-4fc6-884c-3f8b9195fc6f.png)

## [Explorer](https://www.wormholesscan.com/#/)

### Örneğin benim cüzdanım:

![image](https://user-images.githubusercontent.com/107190154/195496521-7c9560d2-acdc-483f-a87d-5414a4711877.png)

### Şu an yani 13.10.2022 - saat 07.05 itibarıyla bulunan validator sayısı --->> 446

![image](https://user-images.githubusercontent.com/107190154/195496443-f9a8f5ce-18fe-4df6-adcd-a426990c3fe7.png)

# Açıklama (0x konusu hakkında)

**0.9.0 olan sürümde 0x'le yazdığınızda size farklı bir key oluşturuyordu.Bunu ekibe geri bildirimde bulunmuştum. Ekip 0x'i kaldırarak yaz diye bizzat söyledi ancak bu durumun hata olduğunun farkına bile varamayan bazı fenomen arkadaşlar yanlış yönlendirme yaptığımızı düşünerek hakkımda dezenformasyonda bulundular, şimdi aşağıya ekibin yazdığı yazıyı ispat olarak bırakıyorum. Lütfen, her duyduğunuza ya da her gördüğünüze koşulsuz itimat etmeyin. Hepinize kolaylıklar dilerim.**
> 0.9.1 sürümüyle bu sorunu ekip düzeltti.

**Ekibin ifadesi:**
**In version 0.9.1, the problem of the private key with the prefix 0x has been automatically removed. By default, the private key does not have 0x.**

![image](https://user-images.githubusercontent.com/107190154/193506206-da791f04-e234-43f0-a4d7-29aa04e5fe6e.png)

### Hata ya da eksik varsa PR atabilirsiniz...

## Sorularınız için: https://t.me/NotitiaGroup
