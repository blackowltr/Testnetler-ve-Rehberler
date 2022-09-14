<h1 align="center">Merhabalar, bir node kurdunuz ancak sunucunuzda o portun kapalı olduğundan dolayı hata almanız halinde nasıl o portu açabilirsiniz ondan bahsedeceğim.</h1>

**Örneğin; sui devnet kurmuştuk, çoğu arkadaşımızın da 9000 ve 9184 portları kapalıydı bu sebeple explorerda bilgileri görüntüleyemiyordu. İşte bu sorunları çözmek için ne yapacağız onu yazacağım.**
**Sunucumuza bağlanacağız. Ardından şu komutlarla portu açaçağız.
Hangi portu açacaksak komutta XXXX kısmına onu yazalım.
9000 port açılacaksa sudo ufw allow 9000 şeklinde olmalı.**
```
sudo ufw enable
sudo ufw allow XXXX
```

**Ya da portların tamamnını açmak isterseniz;**
```
sudo ufw allow all
```

Örneğin, sui devnette (9000,9184,8080) portlarını açmak için komut şöyle olmalı.
```
sudo ufw enable
sudo ufw allow 9000
sudo ufw allow 9184
sudo ufw allow 8080
```
> Komut çıktısı şu şekilde görünecektir;

![sui2](https://user-images.githubusercontent.com/107190154/190216242-68366456-a253-44a5-8901-fd95416b9eb6.png)

**Portları açtıktan sonra şu komutlarla bi restart atalım.**
```
sudo systemctl daemon-reload
sudo systemctl enable nodeismid
sudo systemctl restart nodeismid
```
### Portları kontrol etmek için şu komutu kullanabilirsiniz.
```
lsof -i -P -n | grep LISTEN
```

### Cosmos Projelerinde Port Numaraları

26656,26657,26658,26660,9090,6060
