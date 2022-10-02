Node Kurarken Nelere Dikkat Etmeliyiz?



Arkadaşlar, node testlerinde neleri nasıl yapmalıyız, neler önemli bunlara dair bilgilendirmelerde bulunacağım. Unuttuğum ya da sizlerin merak ettiği kısımlar olursa güncelleme yaparım, yazıya. Yorumlarda belirtirseniz sevinirim. Şimdilik sadece aklıma gelenleri yazdım ancak bu yazının daha detaylanması için sizlerin yorumuna ihtiyacım var, lütfen unutmayalım. Umarım istifade edersiniz.



1. Dikkat Edilmesi Gerekenler



1.1 Root yetkisi almadan kurulum yapmaya çalışmak



Root yetkiniz yoksa kurulumda size hata verecektir arkadaşlar, özellikle google sunucularda site üzerindeki terminalden bağlantı sağlayan ve direkt kurulum komutlarıyla işe başlayan arkadaşlar hata alıyorlar. Bu hatayı almamamız için şu komutu kuruluma geçmeden önce terminale yazıp enter'a basın;



sudo su



Şunu merak eden arkadaşlarımız da olabilir, iyi ama ben başka bir sunucu kullanıyorum root yetkim olup olmadığını anlamam için ne yapmam gerekiyor?

Cevap şu görsellerde arkadaşlarım;



![image](https://user-images.githubusercontent.com/107190154/193458348-468ca111-3445-493b-be3a-05268db6e12a.png)



1.2 Cüzdan bilgileri nelerdir, nasıl ve neleri yedeklememiz gerekiyor?



Aşağıdaki görselde gördüğünüz gibi örnek olması açısından teritori üzerinde bir cüzdan oluşturdum.



1-Numaralı kısım, cüzdan isminiz cüzdan isminize istediğiniz ismi koyabilirsiniz, Türkçe karakter kullanmayın sadece.



> Ek olarak node isminizle cüzdan isminiz aynı da olabilir bunlar sorun oluşturmaz.

> Cüzdan isminiz bağlayıcı değildir yani cüzdanı recover ederken farklı isim kullanabilirsiniz ya da aynı ismi koyabilirsiniz.



2-Numaralı kısım, sizin oluşturduğunuz cüzdanın adresidir.



3-Numaralı kısım, sizin cüzdanınızın kurtarma kelimeleridir. Bu kısım önemli arkadaşlar, cüzdan oluşturduğunuzda mutlaka ama mutlaka kurtarma kelimelerinizin yedeğini alın, not defterine kaydedin. Aynı zamanda bu kelimeleri kimseyle paylaşmamalısınız. Bu kelimeleri kaybederseniz cüzdanınıza erişemezsiniz yani cüzdanınızı kurtaramazsınız.


![image](https://user-images.githubusercontent.com/107190154/193458371-1729e696-c455-4c23-b64a-5b2e933b7b7d.png)



> Cüzdan bilgilerinizi şu şekilde not defterinize not etmeyi unutmayın;



![image](https://user-images.githubusercontent.com/107190154/193458375-ad9b7317-62ed-4bff-9b3b-c5ef9dc66a0e.png)



> Cüzdan ismimizi nerede nasıl kullanıyoruz?



Cüzdan isminizi node testinde validator olurken from kısmına yazıyoruz arkadaşlar. From=Cüzdan isminiz.

İsminizi eksik ya da hatalı veya büyük küçük harfe dikkat etmeden yazarsanız xxxx.key not found hatası alırsınız. Validator olurken ya da içinde from yazan bir komut kullanırken cüzdan isminizi doğru yazdığınızdan emin olun.



Örneğin şöyle;



strided tx staking create-validator \

--amount=9900000ustrd \

--pubkey=$(strided tendermint show-validator) \

--moniker=BlackOwl \

--chain-id=STRIDE-TESTNET-2 \

--commission-rate="0.10" \

--commission-max-rate="0.20" \

--commission-max-change-rate="0.1" \

--min-self-delegation="1" \

--fees=250ustrd \

--gas=200000 \

--from=örnekcüzdan \

-y



1.3 Moniker ismi nedir ya da moniker ismimi unuttum?



Moniker dediğimiz sizlerin node ismidir, arkadaşlar. Genelde kurulum yaparken sizlere node isminizi girin diye bir ifade çıkar, oraya girdiğiniz isim sizin moniker/node isminizdir.



Örneğin, sei kurmak isteyen birisi scripti yazıp çalıştırdığında hemen bizden node ismimizi yazmamızı ister. İstediğimiz ismi verebiliriz. Türkçe karakter kullanmayalım, sadece.



moniker.png



> Peki, ben moniker/node ismimi unuttum nereden bulacağım? (2 Şekilde anlatacağım bu kısmı.)



Bunun için arkadaşlar, node'un config.toml dosyasına girip kontrol edebilirsiniz. Hem bu sayede config dosyasına terminalden nasıl girilir onu da öğrenmiş oldunuz.



Şu aşağıdaki komutta bulunan .nodeismi kısmına hangi node testi için işlem yapacaksanız onun ismini yazacaksanız.

örneğin; nano /root/.stride/config/config.toml gibi olacak.

sei için,  nano /root/.sei/config/config.toml

stafihub için,  nano /root/.stafihub/config/config.toml

teritori için,  nano /root/.teritori/config/config.toml



nano /root/.nodeismi/config/config.toml



Kodu düzenleyip enter dedikten sonra karşınıza şu ekran çıkacak işaretli yerde moniker/node isminiz yazıyor.



![image](https://user-images.githubusercontent.com/107190154/193458387-39715750-96e9-4bf1-a01e-171a7ee7346d.png)



> Bu ekrandan çıkmak için CTRL+X sonra Y ardından Enter yapıp çıkıyoruz.



Moniker ismimizi terminal ekranında komutla nasıl öğrenebiliriz?



Şu komutla öğrenebilirsiniz. (nodeismid yazan yere node ismini yazıp sonuna d ekliyoruz.) --> (Örn: seid, rebusd, strided)

Cüzdanİsminiz kısmına cüzdan adınızı yazın.

Aynı zamanda validator adresinizi de bu şekilde görebilirsiniz, görselde kırmızı ile işaretledim.



nodeismid q staking validator $(nodeismid keys show Cüzdanİsminiz --bech val -a)



Komutu şöyle ayarlayacaksınız;



Stafi içinse,

stafihud q staking validator $(stafihubd keys show Cüzdanİsminiz --bech val -a)



Stride içinse;



strided q staking validator $(strided keys show Cüzdanİsminiz --bech val -a)



Rebus içinse;



rebusd q staking validator $(rebusd keys show Cüzdanİsminiz --bech val -a)



Teritori içinse;



teritorid q staking validator $(teritorid keys show Cüzdanİsminiz --bech val -a)



Sei içinse;



seid q staking validator $(seid keys show Cüzdanİsminiz --bech val -a)



![image](https://user-images.githubusercontent.com/107190154/193458394-11a42b21-1617-4a7a-99af-774678156843.png)





> Moniker ismimizi nerede nasıl kullanıyoruz?



Moniker ismimizi biz bir node testinde validator olurken validator komutlarındaki moniker kısmına yazıyoruz arkadaşlar. Moniker=Node isminiz



Örneğin şöyle;



strided tx staking create-validator \

--amount=9900000ustrd \

--pubkey=$(strided tendermint show-validator) \

--moniker=BlackOwl \

--chain-id=STRIDE-TESTNET-2 \

--commission-rate="0.10" \

--commission-max-rate="0.20" \

--commission-max-change-rate="0.1" \

--min-self-delegation="1" \

--fees=250ustrd \

--gas=200000 \

--from=örnekcüzdan \

-y



1.4 Node kurdum ama yedekleme işlemi yapmak istiyorum nasıl yapabilirm ya da hangi dosyayı yedekleyeceğim?



Arkadaşlar, çoğunlukla cosmos projelerine katılıyoruz ve bu projelerde node taşıma nedir, nasıl yapılır anlatmıştık, forumda.

Dilerseniz node taşıma ile ilgili rehberlere şuradan bakabilirsiniz; Yazılı Rehber - Video Rehber



Wincp,Termius ya da türev uygulamalarla sunucu dosyalarımıza erişeceğiz.



Yedeklememiz gereken dosya; priv.validator.key adlı dosyadır. Bu dosya node'un ismiyle aynı olan klasörün altındaki config klasöründe bulunur.



Görseldeki dosya, yedeklenmei gereken dosyadır. Ben sei node üzerinde örnek göstereceğim. Winscp adlı programı kullanıyorum, genelde. İndirmek için

Dosyalar siz ilk girdiğinizde görseldeki gibi gözükmüyorsa CTRL+ALT+H ile gizli klasörleri görüntüleyebilirsiniz.



1- .sei klasörüne giriyorum.



![image](https://user-images.githubusercontent.com/107190154/193458399-1128f73b-f1c6-4faf-91bd-f6bacf93ef47.png)





2- Şimdi de config klasörüne giriyorum.



![image](https://user-images.githubusercontent.com/107190154/193458402-ab3ee50f-1c6a-40da-8c5e-b38e14b9bb96.png)



3- Arından kırmızı ile çizdiğim dosyayı alıp kendi bilgisayarınızda masaüstüne atın, böylelikle yedeğinizi almış olacaksınız.



![image](https://user-images.githubusercontent.com/107190154/193458408-c6acbd75-26b6-4987-8fb0-e26f9b9bf0ac.png)



Bu yazıda aklıma gelen şeyleri izah etmeye çalıştım, sizlerden gelen geribildirimlere göre yeniden revize edeceğim. Ya da 2-3 bölüm halinde hazırlayacağım, bu yazıyı. Mümkün olduğu kadar yorum bırakmayı ihmal etmeyelim arkadaşlar. Hepinize teşekkürler. Yorumlarda görüşmek üzere.
