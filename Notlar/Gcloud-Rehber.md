![image](https://user-images.githubusercontent.com/107190154/193458132-88a76ae9-9281-4d96-b35f-2ccce4bb1889.png)


### Arkadaşlar, Google Cloud üzerinden temin edilen sunucularda burada anlattığım yöntemle (yani termius/putty vs. kullanarak) bağlanma durumunda farklı işlemlerin yapılması gerektiği için bazı arkadaşlarımızın bağlantıda sorun yaşadığını gördüm.

Önemli; Bu yazıdaki 12. adımdan itibaren anlattığım işlemleri AWS, Azure sunucularında da yaparak Putty, Termius, PowerShell bağlantınızı sağlayabilirsiniz.

Şimdi nasıl yapılacağı hakkında sunucu kuruluşu ve sunucuyu termius'a bağlamak için yapılacaklar için bilgi vereceğim.

1) İlk olarak telefonumuzla sunucumuzu temin edeceğiz. Telefonumuzun tarayıcısından Google Cloud girelim. Daha sonra hesap açarak ilerleyelim.

Not: Hesap açma kısmını ben burada yazmıyorum ancak şu yazıyı mutlaka okumalısınız; Google Cloud Sunucu Kurma Rehberi

2) Hesabı kurduktan sonra açılan sayfada sol üstteki kısma dokunun.

![image](https://user-images.githubusercontent.com/107190154/193458147-d13def07-36ed-447c-8975-a8517d3b9694.png)

3) Açılan pencereden Compute Engine kısmına girelim.

![image](https://user-images.githubusercontent.com/107190154/193458152-946e6224-c36c-4ff8-b8a2-8d6cd4fa47f2.png)

4) Yine açılan pencereden VM Instances kısmına girelim.

![image](https://user-images.githubusercontent.com/107190154/193458156-49d7e5aa-2a84-4838-9dc2-4e5a072ad50c.png)

5) Gelen sayfada sağda bulunan üç noktaya dokunalım.

6) Açılan pencerede Create Instance kısmını seçiyoruz. Açılan kısımda sunucumuzun hangi özellikte olacağı vs. konusunda özelleştirmeler yapacağız. Bu kısmı anlatmayacağım ancak nasıl olacak bilmiyorsanız, bakınız; Google Cloud Sunucu Kurma Rehberi

![image](https://user-images.githubusercontent.com/107190154/193458163-128963d1-a220-410f-8c44-cc11b85df212.png)

7) Telefonumuzun tarayıcısından google cloud'a girip sunucumuzu temin ettik.  Şimdi Google Cloud uygulamasına gireceğiz, telefonumuzda yüklü değilse Buradan Yükleyelim.

8) Programa girelim. Açılan ekrandan aşağıda bulunan Resources kısmına dokunuyoruz.

![image](https://user-images.githubusercontent.com/107190154/193458168-993d0d72-1e7e-4ce2-b9ec-fc991602c5b9.png)

9) Şimdi de VM Instances kısmına dokunuyoruz.

![image](https://user-images.githubusercontent.com/107190154/193458172-d7642e12-0b76-4fda-b9c1-c4f493433452.png)

10) Az önce telefonumuzun tarayıcısından kurmuş olduğumuz sunucu burada gözükecektir. Buradan sunucumuzun üzerine dokunuyoruz. Ardından açılan sayfadan da sağ üstteki üç noktaya dokunuyoruz.

![image](https://user-images.githubusercontent.com/107190154/193458174-247f575d-b056-49fe-84e2-437a375afaf8.png)

11) Karşımıza aşağıdaki pencere çıkacak, bu pencereden de Connect via SSH kısmını seçiyoruz.

![image](https://user-images.githubusercontent.com/107190154/193458184-2420170c-c38a-466a-bb9d-94e249e788ae.png)

12) Şimdi terminal ekranına bağlanacaksınız. Terminal ekranı geldiğinde ilk olarak birkaç ayar yapmamız gerekiyor. Terminal ekranımız açıldığında aşağıdaki komutu giriyoruz.

```
sudo nano /etc/ssh/sshd_config
```

Karşımıza bu ekran açılıyor. Yön tuşlarıyla aşağıya inip ilgili kısmı bulup görseldeki gibi olacak şekilde düzeltin.

![image](https://user-images.githubusercontent.com/107190154/193458195-b27d6f63-f724-4b08-a327-e9d69aa11ee7.png)

13) Gelen ekrandan yukarıdaki işaretli kısımlar gibi düzeltin, kendi ayarlarınızı.
```
#PermitRootLogin prohibit-password  kısmını  PermitRootLogin yes olarak değiştiriyoruz.

PasswordAuthentication no kısmını PasswordAuthentication yes olarak değiştiriyoruz.
```

**Değişiklikleri yaptıktan sonra CTRL + X ardından sadece Y tuşuna basıyoruz ve enter yapıp komut satırına geri dönüyoruz. Şu kodu yazıyoruz.**

```
sudo systemctl restart ssh
```

14) Sunucumuza termius, putty, cmd tarzında programlarla bağlanmak için root hesabımızın şifresini oluşturacağız. Bunun için sırası ile şu kodları giriyoruz.

```
sudo su
```
```
passwd
```

Şimdi şifremizi oluşturuyoruz. İşlem buraya kadar arkadaşlar.

15) Termius'u açıyoruz ve Host sekmesine gelip bağlantımızı kolaylıkla yapıyoruz ve sunucumuza erişimimizi sağlamış oluyoruz, arkadaşlar.

Not: IP kısmına, Google cloud sunucumuzun External IP denen adresini yazıyoruz.

Kısaca böyle arkadaşlar.

Herkes için kolay ve yapılabilir olsun diye bu yazıyı yazmaya çalıştım.

Faydalı olmasını temenni ediyorum.

Herhangi bir eksik ya da kusur varsa affola.

Her birinize kolay gelsin, şimdiden.
