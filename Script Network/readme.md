# Script Network Test Rehberi
>Sistem Gereksinimleri çok düşük. Sıradan bir sunucuya dahi kurabilirsiniz.

![kjıh89uıwo](https://user-images.githubusercontent.com/107190154/227424365-9335dd44-6a8c-41b9-a2bc-5b0153b82cfa.png)

## Discord : https://discord.gg/scriptnetwork

<h1 align="center">Kurulum</h1>

```
sudo apt-get update && sudo apt-get upgrade -y 
```

```
sudo apt-get install build-essential -y 
```

```
sudo apt-get install git
```

```
sudo apt install tmux
```

## Go Kurulumu
```
wget https://go.dev/dl/go1.19.2.linux-amd64.tar.gz 
sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go1.19.2.linux-amd64.tar.gz
```

## Değişken Ekleme
>Bu komutla .profile dosyamıza erişeceğiz.
```
sudo nano .profile
```

## Aşağıdaki komutu .profile dosyamızın en altına kopyalayalım
>Kopyaladıktan sonra ctrl + x ardında y ve enter ile kaydedip çıkalım.
```
export PATH=$PATH:/usr/local/go/bin
```
<img width="393" alt="dsffsdfsdfsd" src="https://user-images.githubusercontent.com/107190154/227425076-104d7239-9466-4199-9039-6f73c6a28a9a.png">

## Bu komutla devam edin.
```
source .profile
```

## Go versiyon kontrol etme
```
go version
```

<h1 align="center">Yükleme Adımları</h1>

## Bu kısımda adım adım gidin. Sırayla komutları çalıştırmanız yeterli.

```
cd /usr/local/go/src/
```

```
sudo mkdir -p github.com/scripttoken
```

```
cd github.com/scripttoken
```

```
sudo git clone https://github.com/scriptnetwork/Node-Network-guide.git  
```

```
sudo mv Node-Network-guide/ script
```

```
cd script/ 
```

```
sudo cp -r ./integration/scriptnet ../scriptnet 
```

```
sudo chmod -R 777 /usr/local/go
```

```
git config --global --add safe.directory /usr/local/go/src/github.com/scripttoken/script
```

```
make install
```

```
tmux new -s node 
```

```
/usr/local/go/bin/script start --config=../scriptnet/node
```
## Burada bir parola oluşturmanız isteniyor. Parolayı yazdıktan sonra tekrar yazmanızı istiyor yazın ve enter'a basın. Artık node başlatılıyor.
<img width="490" alt="image" src="https://user-images.githubusercontent.com/107190154/227420439-59e2eda0-6ae6-456d-88fd-5c24ac95dd6d.png">

## Şimdi tmuxtan çıkalım.
>Tmuxtan çıkmak için CTRL + B VE D

## Yeni bir tmux oturumu açıyoruz.
```
tmux new -s cli 
```

```
/usr/local/go/bin/scriptcli daemon start --port=16889
```
<img width="492" alt="image" src="https://user-images.githubusercontent.com/107190154/227421490-4ca045e2-383d-4b87-b985-6ff7e60579ec.png">

## Tmuxtan çıkalım ve Yeni bir tane oturum oluşturalım.
>Tmuxtan çıkmak için CTRL + B VE D
```
tmux new -s detail
```

```
/usr/local/go/bin/scriptcli query lightning
```

## Burada adres bilgileriniz vesaire yazıyor. Not edebilirsiniz bir kenara.
<img width="494" alt="Ekran görüntüsü 2023-03-24 070526" src="https://user-images.githubusercontent.com/107190154/227421877-a3d735af-f42c-4679-a662-ee6bd6fda4fe.png">

## [Bu adrese](https://wallet.script.tv/create) giderek bir cüzdan oluşturalım.

## Yeni cüzdan oluşturduğunuzda cihazınıza xxxxxxx.keystore uzantılı bir dosya inecek, onu da bir yere yedekleyin.

## Ardından bize kurtarma kelimelerimizi veriyor.
<img width="451" alt="Ekran görüntüsü 2023-03-24 071047" src="https://user-images.githubusercontent.com/107190154/227422541-c89a6d71-20cc-4595-a9c9-f1b72ef645b9.png">

## Dilerseniz "View my Private Key" kısmından private keyinizi de görebilirsiniz.
<img width="472" alt="dffgh" src="https://user-images.githubusercontent.com/107190154/227422832-33b0477b-e114-4f28-b496-ff42c495f660.png">

## Unlock Wallet diyerek devam ediyoruzz.
<img width="438" alt="image" src="https://user-images.githubusercontent.com/107190154/227422904-140fc407-b970-423a-beb1-06579fd96c97.png">

## Az önce cihazımıza inen xxxxxxx.keystore uzantılı dosyayı seçiyoruz ve cüzdana giriş yapıyoruz.
<img width="980" alt="image" src="https://user-images.githubusercontent.com/107190154/227423007-0e1abe26-6894-43ff-98bb-053856b81cba.png">

## Ve artık cüzdanımıza eriştik.
<img width="788" alt="image" src="https://user-images.githubusercontent.com/107190154/227423077-f5ae4d4e-a8fd-4efd-ad27-2b2a0b517920.png">

## Faucet için Receive yazan kısma gidiyoruz ve alttaki faucet butonuna basıyoruz.

<img width="884" alt="fasfasfas" src="https://user-images.githubusercontent.com/107190154/227427238-48186492-8939-4392-8fee-84ff6e6bf2e6.png">
<img width="462" alt="fasfafa" src="https://user-images.githubusercontent.com/107190154/227427252-bed818bb-2046-4204-85c5-9a10f4dd18b3.png">

## Tokenler cüzdanımıza geldi.
<img width="879" alt="image" src="https://user-images.githubusercontent.com/107190154/227428278-b62958b7-d45c-4b1f-96a3-177ec3582489.png">

## Stake kısmına gidiyoruz.
<img width="788" alt="jhgfd" src="https://user-images.githubusercontent.com/107190154/227423359-b2c78bb9-33de-482c-9054-da01fe1fafad.png">

## Deposit Stake'e tıklıyoruz.
<img width="653" alt="sssswe" src="https://user-images.githubusercontent.com/107190154/227423459-e3150501-5bed-42ed-9c21-75f55a72d04a.png">

## Karşımıza çıkan kısımda "Lightning Node" seçeceğiz. Bu rehber Lightning Node kurulumunu anlatıyor çünkü.
<img width="466" alt="jfdgt" src="https://user-images.githubusercontent.com/107190154/227423602-c44c8074-d353-42c2-850b-df96c5a95873.png">

## Burada ise aşağıdaki görselde yazdıklarımı yapın.
<img width="466" alt="Adsızlkjhgfgdf" src="https://user-images.githubusercontent.com/107190154/227423981-1852204f-68dc-4cb2-a5d2-9803b6347096.png">

## Örnek
<img width="465" alt="image" src="https://user-images.githubusercontent.com/107190154/227427152-8b3e3559-aa33-473d-8523-1d517bb0d221.png">

## Ben summary olan kısmı anlamadım, nereden bulurum diyorsanız şunu yapın. `tmux attach -t detail` bu komutu yazın ve açılan yerde sizin summary bilginiz yazmakta. Aşağıya bıraktığım görseli inceleyin.
<img width="1138" alt="76edf" src="https://user-images.githubusercontent.com/107190154/227427727-c30691e1-2868-4491-9075-159c85e68027.png">

## Ardından cüzdan şifrenizi yazın ve işlemi onaylayın.
<img width="409" alt="image" src="https://user-images.githubusercontent.com/107190154/227424127-b726d251-def7-428e-8bd4-b69b7a3f6f9c.png">

##  Her şey bu kadardı..

<h1 align="center">NOT</h1>

### Bir tmux oturumu açmak için `tmux new -s oturum_adı` komutu kullanarak yeni bir oturum açabilirsiniz.

### Bir tmux oturumundan çıkmak için `CTRL + B ve D` tuşlarını kullanarak çıkabilirsiniz.

### Bir tmux oturumundan çıktınız ama geri dönmek istiyorsanız `tmux attach -t oturum-adı veya numarası` komutuyla geri dönüş yapabilirsiniz.

### Bir değil birden fazla tmux oturumu açtınız ve bunları görüntülemek için `tmux ls` komutunu kullanabilirsiniz.

### Dilerseniz beni twitterdan da takip edebilirsiniz. (https://twitter.com/brsbtc)








