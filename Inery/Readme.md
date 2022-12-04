# Inery Türkçe Node Kurulum Rehberi

![image](https://user-images.githubusercontent.com/102043225/200167049-56aedb9d-cb67-4535-87a5-4f72ea1a64ab.png)

## [Mehmet Koltigin'den](https://github.com/koltigin/Inery-Node-Kurulum-Rehberi) hiçbir değişiklik yapılmadan alıntılanmıştır.

## Gereksinimler 
| Bileşenler | Minimum Gereksinimler | **Tavsiye Edilen Gereksinimler** | 
| ------------ | ------------ | ------------ |
| CPU |	Intel Core i3 or i5 | Intel Core i7-8700 Hexa-Core |
| RAM	| 4 GB DDR4 RAM | 64 GB DDR4 RAM |
| Storage	| 500 GB HDD | 2 x 1 TB NVMe SSD |
| Connection | 100 Mbit/s port | 1 Gbit/s port |
| OS | Ubuntu 16.04 | Ubuntu 18.04 or higher |

Gerekli Kütüphaneler | Clang | CMake | Boost | OpenSSL | LLVM | 
| ------------ | ------------ | ------------ | ------------ | ------------ | ------------ |

## Inery Hesabı Açma ve IP Kaydetme

[Inery Paneline](https://testnet.inery.io/) `Sign Up` butonuna tıklıyoruz ve karşımıza aşağıdaki gibi bir ekran geliyor.

![image](https://user-images.githubusercontent.com/102043225/200168356-5f75c087-77d0-424e-b47f-c52002223fa4.png)

Bu ekranda `Server Name` bölümüne kullandığımız server DNS adresini yazıyoruz. Aşağıda contabo için örneğini göreceksiniz. Burada `Reverse DNS Management` sayfasında `PTR Record` bölümünde `vmXXXXXXX.contaboserver.net` şeklinde yazan yeri bu bölüme yazacaksınız.

![Github Resim-1](https://user-images.githubusercontent.com/102043225/200168887-8b2ca92e-25bf-4021-b8f1-5e308eac088f.JPG)

`IP Address` bölümüne sunucumuzun IP adresini yazıyoruz. `Account Name` bölümüne de hesap adımızı en fazla 12 karakterden oluşabilecek şekilde sadece küçük karekter kullanarak yazıyoruz.

## Cüzdan Oluşturma
Yukarıdaki adımlardan sonra karşınıza aşağıdaki resimdeki gibi mnemonic kelimeleri içeren bir ekran gelecek, bunları kaydetmeyi unutmayınız.

![Ekran Alıntısı1](https://user-images.githubusercontent.com/102043225/200177000-0d25d6a4-339c-4ba0-830f-ee9ce5aac4f6.JPG)

Sonraki ekranda aşağıda görüldüğü gibi kelimeleri sizden seçerek yazmanızı isteyecek. Bu ekrandan sonra kullanıcı paneline gireceğiz.

![Ekran Alıntısı2](https://user-images.githubusercontent.com/102043225/200177022-239611db-29ce-496e-874e-0ab6cafef524.JPG)

Sonraki adımda ise son ekranımız gelecek vu burada `Done` butonuna tıklayarak panelimize erişiyoruz.

![Ekran Alıntısı3](https://user-images.githubusercontent.com/102043225/200177086-2042000d-97a4-4c1a-9cb0-545d6fae8832.JPG)

## Kullanıcı Paneline Giriş

🔴 **Panelin sol sutununda `Public Key` ve `Private Key` başlıkları altında anahtarlarınızı göreceksiniz. Bunlar bize lazım olacak.

![Ekran Alıntısı5-1](https://user-images.githubusercontent.com/102043225/200177472-dc9b7973-a28d-4db3-b794-242dabb13c5f.JPG)

🔴 **Hesabınıza giriş yaptığınız ekranda aşağıdaki resimde görüldüğü gibi `50000 INR` token istiyoruz.**

![Ekran Alıntısı4](https://user-images.githubusercontent.com/102043225/200176984-8fe6e6ce-0b20-4f8a-94d6-d93230122952.JPG)

## Root Yetkisi Alma
```
sudo su
cd
```

## Sistemi Güncelleme
```
sudo apt-get update && sudo apt install git && sudo apt install screen
```

## Gerekli Kütüphanelerin Kurulması
```
sudo apt-get install -y make bzip2 automake libbz2-dev libssl-dev doxygen graphviz libgmp3-dev \
autotools-dev libicu-dev python2.7 python2.7-dev python3 python3-dev \
autoconf libtool curl zlib1g-dev sudo ruby libusb-1.0-0-dev \
libcurl4-gnutls-dev pkg-config patch llvm-7-dev clang-7 vim-common jq libncurses5
```

## Firewall Ayarlarının Yapılması (**OPSİYONEL**)
Eğer sıkıntı yaşıyorsanız aşağıdaki kodları kullanabilirsiniz. Contabo sunucularda bunlara gerek yoktur.

```
sudo apt-get install firewalld 
sudo systemctl start firewalld 
sudo systemctl enable firewalld 
sudo firewall-cmd --set-default-zone=public 
sudo firewall-cmd --zone=public --add-port=22/tcp --permanent 
sudo firewall-cmd --zone=public --add-port=8888/tcp --permanent 
sudo firewall-cmd --zone=public --add-port=9010/tcp --permanent 
sudo firewall-cmd --reload 
sudo systemctl restart firewalld
```

## Inery Dosyalarının İndirilmesi ve Kurulması

```
git clone https://github.com/inery-blockchain/inery-node
cd inery-node/inery.setup
chmod +x ine.py
./ine.py --export
cd; source .bashrc; cd -
```

## Config Dosyasını Düzenleme
`inery-node/inery.setup/tools/` dizininde yer alan `config.json` dosyasını isterseniz winscp gibi bir programla ya da aşağıdaki kodla terminal üzerinden düzenleyebilirsiniz.

```
sudo nano tools/config.json
```

Açılan dosyada aşağıdaki yerleri kendinize göre dolduruyorusunuz.
  * `AccountName` hesap adınız
  * `PublicKey` Inery kullanıcı panelinizde sol blokta yer alan kod
  * `PrivateKey` yine Inery kullanıcı panelinizde sol blokta yer alan kod
  * `IP` ip adresiniz

```
"MASTER_ACCOUNT": {     
"NAME": "AccountName",     
"PUBLIC_KEY": "PublicKey",     
"PRIVATE_KEY": "PrivateKey",     
"PEER_ADDRESS": "IP:9010",     
"HTTP_ADDRESS": "0.0.0.0:8888",     
"HOST_ADDRESS": "0.0.0.0:9010" }
```
🔴 **Dosyamızı `ctrl x y enter` diyerek kaydediyoruz.**

## Node'u Başlatma
Iner adında bir screen açıyoruz ve master komutu ile node'u başlatıyoruz.
```
screen -S inery
./ine.py --master
```
Loglara bakıyoruz.
```
cd master.node/blockchain
tail -f nodine.log
```
🔴 **Yukarıdaki ekrandan çıkarken `ctrl a d` tuşluyoruz. Bu ekranı arada bir kontrol ediyoruz. Çıktığınız ekrana yeniden girmek için bu sefer `screen -r inery` yazıyoruz.**


🔴 **Bloklar eşitlenmeden diğer adımlara geçmiyoruz**

## **Görev 1:** Master Node Kaydetme

### Cüzdan Şifresi Oluşturma
`CUZDAN_ADINIZ` yazan yere Inery kullanıcı adımızı yazıyoruz. root dizininde oluşan bu dosya içerisinde cüzdan şifreniz oluşacak. 
```
cd;  cline wallet create --file CUZDAN_ADINIZ.txt
```
🔴 **Cüdan Adını Değiştiriyoruz.**
```
cd $HOME/inery-wallet
mv default.wallet CUZDAN_ADINIZ.wallet
```

### Cüzdan Kilidini Açma
Aşağıdaki koddan sonra size şifrenizi soracak. Sifreniz yukarıda oluşturduğumuz dosyanın içerisinde yer alıyor. Şifrenizi yazdığınızda gözükmez.
```
cline wallet unlock -n CUZDAN_ADINIZ
```

### Cüzdanımızı Import Ediyoruz
`ACCOUNT_PRIVATE_KEY` bölümüne panelimizde bulunan keyi yazıyoruz.
```
cline wallet import --private-key ACCOUNT_PRIVATE_KEY
```

### Hesap Kaydını Yapma
`ACCOUNT_NAME` hesap adınız.
`ACCOUNT_PUBLIC_KEY` kullanıcı panelinizde bulunuyor.
```
cline system regproducer ACCOUNT_NAME ACCOUNT_PUBLIC_KEY 0.0.0.0:9010
```

### Hesap Onaylama
`ACCOUNT_NAME` hesap adınız.
```
cline system makeprod approve ACCOUNT_NAME ACCOUNT_NAME
```

### Master Node'unuzu Kontrol Etme
[Buradaki](https://explorer.inery.io/) adresten adınızı aratınız. 
🔴 **Adınızı gördükten sonra kullanıcı panelinize giderek `Master Approval` başlıklı birinci görevi onaylayınız.**

# Notlar

## Cüzdan Kilidini Açma
Serverınıza bağlandığınızda herhangi bir işlem yapmadan önce aşağıdaki kodları kullanarak önce değişkenleri yükleyiniz yoksa cline not found uyarısı alır işlemlerinizi yapamazsınız sonrasında ise cüzdanınızın kilidini açınız. 
```
source .bashrcd
```
```
cline wallet unlock -n CUZDAN_ADINIZ
```

## Bakiye Kontrol Etme
`ACCOUNT_NAME` hesap adınız.
```
cline get currency balance inery.token ACCOUNT_NAME
```

## Node'u Silme
```
cd inery-node/inery.setup/master.node
./stop.sh
cd
rm inery-node -rf
rm inery-wallet -rf
pkill nodine
```
