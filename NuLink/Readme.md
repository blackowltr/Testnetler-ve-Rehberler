# NuLink Testnet Katılım Rehberi

![NULINK](https://user-images.githubusercontent.com/107190154/190568136-14f5a7d8-5b15-46fb-8132-4d38a0779171.gif)

**Merhaba, arkadaşar. NuLink testneti için bir rehber hazırladım. Bu rehberle tüm nulink test sürecinde yapmanız gerekenleri yapmış olacaksınız.**

**Lütfen yazılanları dikkatle okuyunuz. Atladığınız bir komut size hata aldıracaktır.**

**En hata ya da hiç hatasız kurmak istiyorsanız, her adımı dikkatle yapın.**

### NOT: Feedback vermeniz isteniyor ancak node kurduğunuz andan hemen sonra feedback vermek zorunda değilsiniz. İlla bir hata yazmak zorunda da değilsiniz, tutarlı ve projeye katkı sağlayacak bir öneri de olabilir. Test bir müddet devam edecek ve çeşitli güncellemeler alacak, acele ile form doldurmak ya da `very nice project` yazmanız size hiçbir fayda sağlamaz.

**Hepinize kolay gelsin..**

### Kurulum sırasında oluşturduğunuz şifrelerin hepsini aynı yapın.

### [Video Rehber için](https://youtu.be/LOgLKYvJQgM)

<h1 align="center">Kurulum</h1>

### Minimum Gereksinimler

|      CPU        |   RAM    |  Disk    | 
|-----------------|----------|----------|
|2-4 CPU|   4GB    | 30GB    |

**Öncelikle bize lazım olan 9151 portumuzu açalım.**
```
sudo su
sudo ufw allow 9151
```

## Scriptle Kurulum için
> Scriptteki yardımları için [@HOdyseus](https://twitter.com/HOdyseus?t=oQJbCGmYzRVhDDfUhH1F3g&s=09) teşekkürler...
```
wget -O nulink-tr.sh https://raw.githubusercontent.com/brsbrc/Testnetler-ve-Rehberler/main/NuLink/nulink-tr.sh && chmod +x nulink-tr.sh && ./nulink-tr.sh
```

<h1 align="center">Manuel Kurulum</h1>

## Linux sistem güncellemesi yapıyoruz.

```
sudo apt-get update && apt-get upgrade -y
```

## Kütüphane kurulumunu yapıyoruz
```
sudo apt-get -y install libssl-dev && apt-get -y install cmake build-essential git wget jq make gcc
```

Bize gerekli olan dosyayı indiriyoruz ve ayarları yapıp bir worker hesabı oluşturuyoruz.
```
wget https://gethstore.blob.core.windows.net/builds/geth-linux-amd64-1.10.24-972007a5.tar.gz
```
```
tar -xvzf geth-linux-amd64-1.10.24-972007a5.tar.gz
```
```
cd geth-linux-amd64-1.10.24-972007a5/
```
```
./geth account new --keystore ./keystore
```
Şifre oluşturuyoruz. Bu kısımda şifreyi yazdıktan sonra bir kez daha aynı şifreyi yazıyorsunuz ve şifre oluşturuluyor.
> Çıktı şöyle görünecek burada size bir key verecek, onu not etmeyi unutmayın. 
> 
![nununu](https://user-images.githubusercontent.com/107190154/190369550-1ef68ab9-33d3-49ec-954e-0dd4b50173fe.png)

### Şimdi devam edelim, kuruluma
```
cd /root
```
>Docker'ı Yüklüyoruz.
```
sudo apt install docker.io
```
>Docker'ı başlatalım.
```
sudo systemctl enable --now docker
```
NuLink İmage dosyasını çekelim.
>İndirme işlemi yapacağı için biraz bekleyelim
```
docker pull nulink/nulink:latest
```
### nulink adında bir dosya oluşturuyoruz
```
cd /root
mkdir nulink
```

**Burada `Path of the secret key file` yazan kısımda gördüğünüz kısmı alıp `cp` den sonraki kısma yapıştırıyorsunuz ve sonuna `/root/nulink` ekliyorsunuz. Aşağıda örnek şeklini gösterdim.**
```
 cp burayapathofthesecretkeyfileyazın /root/nulink
```
### Bu Komutu yazmayı unutmayın. Unutursanız hata alırsınız.
 ```
 chmod -R 777 /root/nulink
```
![nunaa](https://user-images.githubusercontent.com/107190154/190372480-43c054fc-433d-47b7-bbb0-b53fca52da3f.png)

<h1 align="center">Bu girmeniz gereken bir komut değildir, örnektir</h1> 

```
 cp /root/geth-linux-amd64-1.10.23-d901d853/keystore/UTC--2022-09-13T01-14-32.465358210Z--8b1819341bec211a45a2186c4d0030681ccce0ee /root/nulink
 ```

### Değişkenleri ayarlayacağız
> Burada en az 8 karakterli bir şifre seçebilirsiniz.
```
export NULINK_KEYSTORE_PASSWORD=şifreniz

export NULINK_OPERATOR_ETH_PASSWORD=şifreniz
```

### Bu adım, NuLink çalışan node yapılandırmasını depolar ve yalnızca bir kez çalıştırılması gerekir.
> Düzenlememiz gereken yerler var. Aşağıda nasıl dolduracağınıza dair örnekleri yazdım.
```
docker run -it --rm \
-p 9151:9151 \
-v /root/nulink:/code \
-v /root/nulink:/home/circleci/.local/share/nulink \
-e NULINK_KEYSTORE_PASSWORD \
nulink/nulink nulink ursula init \
--signer keystore:///code/Path of the secret key file \
--eth-provider https://data-seed-prebsc-2-s2.binance.org:8545  \
--network horus \
--payment-provider https://data-seed-prebsc-2-s2.binance.org:8545 \
--payment-network bsc_testnet \
--operator-address publicadresiniziyazın \
--max-gas-price 100
```
**signer keystore:, `///code/.......` bu kısma az evvel yukarıda da kullandığımız `Path of the secret key file` kısmında yazan yeri kopyalayacağız ancak `UTC` yazan yerden itibaren kopyalayacağız. Ve boşluk olmayacak şekilde yapıştıracağız**

**Komutta şöyle görünecek;**

Örneğin;--signer keystore:///code/UTC--2022-09-13T01-14-32.465358210Z--8b18193XXXXXXXXXXXXXXXXXXXXXXXXXe\

**`operator-address` yazan yere az evvel worker hesabı oluşturduğumuzda karşımıza çıkan `public address'i` yazıyoruz.**
**Örneğin; 0x8b18193XXXXXXXXXXXXXXXXXXXXXXXXXe**
>Sarı ile işaretli yerdeki adres `operator-address` olan yere yazacağız.
![nununu](https://user-images.githubusercontent.com/107190154/190402707-09fb815c-2021-42af-ad5b-a13ec90dbc60.png)

### Komutu düzenleyip girdikten sonra karşınıza şu şeklide bir ekran çıkacak.

![gitnulink](https://user-images.githubusercontent.com/107190154/190388655-5c68865f-cfda-4dde-885f-56bf72b6d2f8.png)

### Örnek Çıktı;

**y/N kısmına y yazıp enter diyoruz.**

**Ardından 8 karakterli bir şifre oluşturuyoruz. Bu şifreleri bir yere not edin kaybolmasın.**

**Şimdi karşımıza kelimelerimiz çıkacak, mavi renktedirler. Mutlaka bir yer yedekleyin. Tekrar kelimeleri görmen şansınız yok.**

**Ardından yine y/N sorusune y yazıp enter yapalım.**

**Açılan sayfaya az önce gelen kelimelerimizi yapıştıralım ve enter diyelim.**

**Arından Public Key ve keystore dosya dizinin yolunu gösteren bir çıktı alacağız.** 
```
# step 1
 Detected IPv4 address (123.45.678.9) - Is this the public-facing address of Ursula? [y/N]: y
 
 Please provide a password to lock Operator keys.
 Do not forget this password, and ideally store it using a password manager.
 
 # step 2
 Enter nulink keystore password (8 character minimum): xxxxxx
 Repeat for confirmation: xxxxxx
 
 Backup your seed words, you will not be able to view them again.
 
 xxxxxxxxxxxxxxxxxxxxxxxx
 
 # step 3
 Have you backed up your seed phrase? [y/N]: y
 
 # step 4
 Confirm seed words: xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
 
Public Key:   02bb2067d21a67XXXXXXXXXXXXXXXXXX
Path to Keystore: /home/circleci/.local/share/nulink/keystore

- You can share your public key with anyone. Others need it to interact with you.
- Never share secret keys with anyone! 
- Backup your keystore! Character keys are required to interact with the protocol!
- Remember your password! Without the password, it's impossible to decrypt the key!

Generated configuration file at default filepath /home/circleci/.local/share/nulink/ursula.json

* Review configuration  -> nulink ursula config
* Start working         -> nulink ursula run
```

![finalnu](https://user-images.githubusercontent.com/107190154/190388608-029e9da9-d664-4a0c-9c85-a149e32bfd7f.png)

### Aşağıdaki komutla node'u başlatıyoruz
> Direkt Girebilirsiniz. Size bir tx verecektir, tx verdiyse işlem başarılıdır.
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
![txnuu](https://user-images.githubusercontent.com/107190154/190388569-c7cc262a-b3c5-4003-9b00-bb828bf6d4fd.png)

### Log kontrol sağlayalım, sürekli log bakmak için komut yazmak yerine screen açalım.
```
apt install screen -y
```
```
screen -S log
```
```
docker logs -f ursula
```
![image](https://user-images.githubusercontent.com/107190154/190395106-60cea495-64fc-47fa-b078-03248ae71e47.png)

## Silme Komutları
```
docker kill ursula
```
```
docker rm ursula
```
```
rm -r nulink
```
```
rm -r geth-linux-amd64-1.10.24-972007a5
```
```
rm -r geth-linux-amd64-1.10.24-972007a5.tar.gz
```
### Artık Node'umuz çalışıyor. Ancak işlemler daha bitmedi. Birkaç adım daha var.

### Metamask'a girelim ve şu siteye gidelim; https://test-staking.nulink.org/faucet
**Dilerseniz cüzdanınızı metamask'a kurulum esnasında aldığımız kelimelerle import edin, ya da herhangi bir cüzdanla işleme devam edebilirsiniz.**
### Metamaskta BSC test ağına geçelim. (Siteye bağlanmaya çalıştığınızda kendi geçiş yapıyor yapmazsa şuradan bsc [test](https://academy.binance.com/tr/articles/connecting-metamask-to-binance-smart-chain) ağını ekleyebilirsin.

### Ardından BSC test ağına test token alalım ve bsc test token geldikten sonra nlk token da alalım faucetten.

![image](https://user-images.githubusercontent.com/107190154/190427147-1447808c-0518-4880-8467-ce5da67b5e0e.png)

### Şimdi `Staking` kısmına gelelim. Şimdi aldığımız nlk tokenleri stake edeceğiz.

![image](https://user-images.githubusercontent.com/107190154/190427972-b6543a26-662e-4833-b48d-16132ec17a45.png)

### Nlk tokenleri stake edelim.

![image](https://user-images.githubusercontent.com/107190154/190428750-73b8c80b-891e-4db7-bbff-f3d0a9f8c946.png)

### `Confirm` diyelim.

![image](https://user-images.githubusercontent.com/107190154/190429119-fa098247-ca9d-421e-8168-76529b3cdeec.png)

### Tokenlerimizi stake ettikten sonra şimdi `bond` işlemi yapacağız. `Bond Worker` butonuna basalım.

![image](https://user-images.githubusercontent.com/107190154/190430550-6c5daa38-6601-47b9-8bcd-e6935b387093.png)

### Şimdi karşımıza gelen ekranda doldurmamız gereken yerler var.

### Worker adres az önce node kurarken oluşan public adresimiz, worker adres kısmına onu yazıyoruz.

### Node Url kısmına da şu şekilde yazacağız. **https://sunucuip:9151**
### örneğin: https://123.45.678:9151

### Sonra confirm butonuna basıp cüzdanımıza gelen işlemi onaylayalım.

![image](https://user-images.githubusercontent.com/107190154/190434229-ab890d36-4444-4d7b-8bec-a6abe1f66a0c.png)

### Bu işlemi yaptıktan sonra artık `online` şekilde gözükecektir, node'unuz.

![fnfnfn](https://user-images.githubusercontent.com/107190154/190434841-27277e1a-7c24-4941-953e-92a83f83ee6f.png)

### Not: Sitede node online olup sonradan offline gözükürse endişelenmeyin, siteden kaynaklı bir durum.

### İşlemler bu kadardı, yapılması gereken her şeyi yaptık. Hepinize kolay gelsin.

### Herhangi bir sorun ya da hata alırsanız bana telegramdan ya da discorddan ulabilirsiniz.

## [Nulink Türkiye Telegram Kanalı](https://t.me/NuLink_Turkey)
## [Nulink Discord Kanalı](https://discord.gg/wGvjRWtw)

### [Resmi Doküman için](https://docs.nulink.org/products/testnet)
### [Feedback Formu](https://forms.gle/EeSxZBZToB74scru7)
