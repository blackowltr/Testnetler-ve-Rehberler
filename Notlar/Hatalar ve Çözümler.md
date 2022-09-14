<h1 align="center">Herkese selamlar. Sizlere bugün node kurarken sıklıkla karşılaştığımız bazı hataların çözümünden bahsedeceğim.</h1>

### Başlıklar

**Hata 1: Error: invalid character 'o' looking for beginning of value**

**Hata 2: command not found**

**Hata 3: Make: *** [Makefile:101: install] Error 127**

**Hata 4: Exit code**

**Hata 5: address already in use (os error 98)**

**Hata 6: No journal files were found**

**Hata 7:  signature verification failed; please verify account number (1930) and chain-id (chainid): unauthorized**

<h1 align="center">Hata 1: Error: invalid character 'o' looking for beginning of value</h1>

Bu hatayı aldığınızda çözüm olarak şu komutu girmelisiniz.

```
sudo su
```

![g1](https://user-images.githubusercontent.com/107190154/190076472-2fef0fb4-f7b9-4752-a658-98726cfedb33.jpg)

<h1 align="center">Hata 2: command not found</h1> 

Örneğin bu görselde command not found hatası mevcut.

![g21](https://user-images.githubusercontent.com/107190154/190076572-773b742e-a002-4dc2-ae5e-4aad8504b6ff.jpg)

> Linux’ta dosya veya dizin kopyalamak için cp komutunu kullanılırız. Kopyalama işlemi için cp komutundan sonra kaynak dizin/dosya ve hedef dizin/dosya belirtiriz.

Bu komutla şunu yapmış oluyoruz. ---> cp [kaynak dizin] [hedef dizin] 
```
cp /root/go/bin/nodeismid /usr/local/bin
systemctl restart nodeismid
```

nodeismid yazan yere şöyle yazacağız. (Yani kurduğumuz node isminin sonuna d harfi ekleyeceğiz.)

örn: rebus içinse rebusd, stride içinse strided, stafihub içinse stafihubd, teritori içinse teritorid

Örneğin; Rebus node için yukarıdaki görselde bulunan hatayı şu komutla düzeltebiliriz;
```
cp /root/go/bin/rebusd /usr/local/bin
systemctl restart rebusd
```

<h1 align="center">Hata 3: Make: *** [Makefile:101: install] Error 127</h1>

Bu hata ile genellikle bir güncelleme yaparken karşılaşırız. Çözümü de oldukça basit, go kurulumunu yeniden yapacağız.

![g3](https://user-images.githubusercontent.com/107190154/190076838-d83cbe45-dfdb-42df-a738-9fd96041f3c3.jpg)

**Go kurulum komutları;**
```
cd $HOME
wget -O go1.18.2.linux-amd64.tar.gz https://go.dev/dl/go1.18.2.linux-amd64.tar.gz
rm -rf /usr/local/go && tar -C /usr/local -xzf go1.18.2.linux-amd64.tar.gz && rm go1.18.2.linux-amd64.tar.gz
echo 'export GOROOT=/usr/local/go' >> $HOME/.bashrc
echo 'export GOPATH=$HOME/go' >> $HOME/.bashrc
echo 'export GO111MODULE=on' >> $HOME/.bashrc
echo 'export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin' >> $HOME/.bashrc && . $HOME/.bashrc
go version
```
**Bu komutları yazıktan sonra yeninden güncelleme komutalarını girebilirsiniz.**

<h1 align="center">Hata 4: Exit code</h1> 

Bu başlığı okurken sinirlenebilirsiniz. Haklısınız çünkü bu hata hepimizin başının belası oluyor çoğu zaman. :D

Ancak bu exit code hatasının belirli bir çözümü yok yani birden fazla çözümü mevcut. Burada bize gerekli olan şey hataya sebep olan şeyin ne olduğunu bulmak/bilmek, onun için şu komutu kullanacağız.
```
systemctl stop nodeismid 
nodeismid start 
```
nodeismid yazan yere şöyle yazacağız. (Yani kurduğumuz node isminin sonuna d harfi ekleyeceğiz.)

örn: rebus içinse rebusd, stride içinse strided, stafihub içinse stafihubd, teritori içinse teritorid

Bu komutu girdikten sonra çıktının ilk satırında bize hatanın neden kaynaklandığını belirten bir ifade çıkacak, orada yazan hataya göre node üzerinde işlem yapıp exit code denen baş belasından kurtulmuş olacağız.

Yani bu exit code hatasını gruplarda sorarken sizden ricam bu dediğim işlemi yapıp komuttan sonra gelen çıktının ilk satırını atmanız. Direkt exit code hatası alıyorum dedğinizde bunun bir tane çözümü olmadığı için direkt şunu yapacaksın diyemeyiz.

<h1 align="center">Exit code hatasına sebep olan şeyler; (Aklıma gelenleri yazıyorum.)</h1>

- Bir node için güncelleme gelmiştir ama siz onu yapmadıysanız exit code hatası alırsınız.

- Config dosyanızda oluşan hatalardan dolayı olabilir, peer bizim gruplarda oldukça konuşulan ve sıkça istenilen bir şey ancak arkadaşlar her peeri eklemek size fayda sağlamıyor hatta eklediğinizde exit code hatası aldırıyor çünkü içinde hatalı peer var, yanlış peer var, eksik olan var bunlar size hata aldırıyor.  Bazı eklediğiniz peerler çalışmıyor bile onun için fazla fazla peer eklemek size katkı sağlamıyor esasen. Her gördüğümüz peeri girmeyelim, dikkat edelim.

- Servis dosyası hataları da exit code hatası verdirir.

- Bir node için güncelleme geldiğinde hep bir blok sayısı belirtilir, örneğin 2000.blokta güncelleme geleceği söylenir ama siz gidip bu güncellemeyi erkenden 1850. blokta yaparsanız yine exit code hatası alırsınız. Hiçbir güncellemeyi belirtilen blok sayısı gelmeden yapmayın arkadaşlar. Bakmanız gereken blok sayısı explorerda yazan blok sayısı değil, sizin node'unuzun log ya sync kontrol komutuyla kontrol ettğinizde yazan blok sayısıdır.

- Bir sunucuya birden fazla aynı portu kullanan node kurmaya çalışırsanız portlar çakışır ve address already in use (os error 98) hatası alır ve exit code hatası ile baş başa kalırsınız.

- Sunucu diskiniz tamamen dolduysa da exit code hatası alabilirsiniz.

<h1 align="center">Hata 5: address already in use (os error 98)</h1> 

Bir sunucuya birden fazla aynı portu kullanan node kurmaya çalışırsanız portlarınız çakışır ve node çalışmaz bu durumda da address already in use (os error 98) hatası ile karşılaşırsınız.

![g41](https://user-images.githubusercontent.com/107190154/190077343-a505fd8d-b8e4-4f73-b1e6-295c6b1ed6ea.jpg)

Bu hata ile ilgili şu yazıma bakmalısınız; [Sunucularda Port Nasıl Açılır?](eklenecek)

<h1 align="center">Hata 6: account sequence mismatch, expected X, got X: incorrect account sequence </h1> 

Bu hatayı aldığınızda girmiş olduğunuz komutun sonuna --sequence X komutunu ekleyin.

( X yazan kısma sayı ekleyin ama kafadan bir sayı değil tabii ki, örneğin görselde expected yazan yerde kaç yazıyorsa onu gireceğiz. )

Aşağıdaki görselde expected 12 yazıyor, yani komut şöyle oluyor, --sequence 12 komutunu girmek istediğiniz komutun sonuna ekleyin.

![g5](https://user-images.githubusercontent.com/107190154/190077510-673047a4-afc9-4713-8f93-8f32a5884dc0.jpg)

Örnek Komut;

```
PUBKEY=$(seid tendermint show-validator)
seid tx staking create-validator \
--amount=980000usei \
--fees=5000usei \
--gas=300000 \
--pubkey=$PUBKEY \
--moniker=nodeismi \
--chain-id=atlantic-1 \
--from=cüzdanismi \
--commission-rate="0.10" \
--commission-max-rate="0.20" \
--commission-max-change-rate="0.01" \
--min-self-delegation="1"
--yes
--sequence=12
```

<h1 align="center">Hata 7: No journal files were found</h1>

Bu hatayı aldığınızda ise çözümü şöyle;

![g6](https://user-images.githubusercontent.com/107190154/190077589-1c00d619-a907-41fb-9263-dfefab58280e.jpg)

Ctrl + C yaptıktan sonra şu komutu girelim;
```
systemctl restart systemd-journald
```

Bu komut size herhangi bir çıktı vermeyecek, çıktı vermediği için komut olmadı diye düşünmeyin. Bu komutu girdikten sonra yeniden log konrol yapın.

<h1 align="center">Hata 8:  signature verification failed; please verify account number (1930) and chain-id (chainid): unauthorized</h1> 

Bu hata genelde chain-id kısmını eksik ya da hatalı yazdığınız için oluyor. Örneğin, stride için chain-id STRIDE-TESTNET-2 olacakken siz bunu STRIDE-TESTNET2 şeklinde yazarsanız size bu hatayı verecektir.

![g7](https://user-images.githubusercontent.com/107190154/190077676-d4f0f507-2953-4d24-9a8b-d3db3d422a49.jpg)

Yani komutta chain-id kısmını doğru yazdığınızdan emin olmalısınız.

Stride için örnek verecek olursak
```
--chain-id STRIDE-TESTNET-4
```

Sei  için örnek verecek olursak
```
--chain-id atlantic-1
```

Rebus  için örnek verecek olursak
```
--chain-id reb_3333-1
```

Bu hatayı almamak için chain-id kısımlarına dikkat etmeliyiz, doğru yazdığımızdan emin olmalıyız.

**Hepinize kolaylıklar dilerim, umarım istifade ettiğiniz bir yazı olmuştur. Aklıma gelen hatalar ve çözümleri dilim döndüğünce anlatmaya çalıştım. Eksiğim ya da hatam varsa affola.**
