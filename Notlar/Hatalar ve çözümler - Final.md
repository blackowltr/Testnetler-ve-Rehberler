# Node Kurulumunda Sık Karşılaşılan Hatalar ve Çözümleri

## Başlıklar

1. **Hata 1: Error: invalid character 'o' looking for beginning of value**
2. **Hata 2: command not found**
3. **Hata 3: Make: *** [Makefile:101: install] Error 127**
4. **Hata 4: Exit code**
5. **Hata 5: address already in use (os error 98)**
6. **Hata 6: No journal files were found**
7. **Hata 7: signature verification failed; please verify account number (1930) and chain-id (chainid): unauthorized**

## Hata 1: Error: invalid character 'o' looking for beginning of value

Bu hatayı aldığınızda şu komutu girerek çözebilirsiniz:

```sh
sudo su
```

![Error: invalid character 'o' looking for beginning of value](https://user-images.githubusercontent.com/107190154/190086640-f2fdb058-fd76-4428-bbbe-5f0db01c7eeb.jpg)

## Hata 2: command not found

Bu hatayı genellikle komutun yanlış yazılması veya gerekli dosyanın bulunamaması durumunda alırsınız. Örneğin aşağıdaki görselde 'command not found' hatası mevcuttur:

![command not found](https://user-images.githubusercontent.com/107190154/190076572-773b742e-a002-4dc2-ae5e-4aad8504b6ff.jpg)

Bu hatayı çözmek için `cp` komutunu kullanarak dosyayı doğru dizine kopyalayın ve hizmeti yeniden başlatın:

```sh
cp /root/go/bin/nodeismid /usr/local/bin
systemctl restart nodeismid
```

Burada `nodeismid` yerine kurduğunuz node'un ismini yazmalısınız. Örneğin:

```sh
cp /root/go/bin/rebusd /usr/local/bin
systemctl restart rebusd
```

## Hata 3: Make: *** [Makefile:101: install] Error 127

Bu hatayı genellikle bir güncelleme yaparken alırsınız. Çözüm için `go` kurulumunu yeniden yapmanız gerekmektedir:

![Make Error 127](https://user-images.githubusercontent.com/107190154/190076838-d83cbe45-dfdb-42df-a738-9fd96041f3c3.jpg)

### Go Kurulum Komutları:

```sh
cd $HOME
wget -O go1.18.2.linux-amd64.tar.gz https://go.dev/dl/go1.18.2.linux-amd64.tar.gz
rm -rf /usr/local/go && tar -C /usr/local -xzf go1.18.2.linux-amd64.tar.gz && rm go1.18.2.linux-amd64.tar.gz
echo 'export GOROOT=/usr/local/go' >> $HOME/.bashrc
echo 'export GOPATH=$HOME/go' >> $HOME/.bashrc
echo 'export GO111MODULE=on' >> $HOME/.bashrc
echo 'export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin' >> $HOME/.bashrc && . $HOME/.bashrc
go version
```

Bu komutları girdikten sonra yeniden güncelleme komutlarını girebilirsiniz.

## Hata 4: Exit code

Bu hata sık karşılaşılan ve sinir bozucu bir hatadır. Çözümü ise hatanın sebebini bulmaktan geçer. Hatanın sebebini bulmak için şu komutu kullanabilirsiniz:

```sh
systemctl stop nodeismid 
nodeismid start 
```

Burada `nodeismid` yerine kurduğunuz node'un ismini yazmalısınız. Örneğin:

```sh
systemctl stop rebusd 
rebusd start 
```

Bu komutları girdikten sonra çıktının ilk satırında hatanın sebebini belirten bir ifade göreceksiniz. Buna göre çözüm üretebilirsiniz.

### Exit Code Hatasına Sebep Olan Durumlar:

- Güncellemeleri zamanında yapmamak.
- Config dosyasında hatalar.
- Yanlış veya eksik peer eklemeleri.
- Servis dosyası hataları.
- Güncellemeleri belirtilen blok sayısına gelmeden yapmak.
- Aynı portu kullanan birden fazla node kurmaya çalışmak.
- Sunucu disk doluluğu.

## Hata 5: address already in use (os error 98)

Bu hata, aynı portu kullanan birden fazla node kurmaya çalıştığınızda ortaya çıkar. Port çakışmasını önlemek için şu adımları izleyin:

![address already in use](https://user-images.githubusercontent.com/107190154/190077343-a505fd8d-b8e4-4f73-b1e6-295c6b1ed6ea.jpg)

Bu hata hakkında daha fazla bilgi için [Sunucularda Port Nasıl Açılır?](eklenecek) yazısına bakabilirsiniz.

## Hata 6: No journal files were found

Bu hatayı aldığınızda şu komutu girerek çözebilirsiniz:

```sh
systemctl restart systemd-journald
```

Bu komut herhangi bir çıktı vermeyecektir, ancak log kontrolü yaptığınızda hatanın düzeldiğini göreceksiniz.

![No journal files were found](https://user-images.githubusercontent.com/107190154/190077589-1c00d619-a907-41fb-9263-dfefab58280e.jpg)

## Hata 7: signature verification failed; please verify account number (1930) and chain-id (chainid): unauthorized

Bu hata, genellikle `chain-id` kısmını eksik veya hatalı yazdığınızda ortaya çıkar. `chain-id` kısmını doğru yazdığınızdan emin olun. Örneğin:

```sh
--chain-id STRIDE-TESTNET-4
```

### Örnek Komutlar:

Stride için:
```sh
--chain-id STRIDE-TESTNET-4
```

Sei için:
```sh
--chain-id atlantic-1
```

Rebus için:
```sh
--chain-id reb_3333-1
```

Hepinize kolaylıklar dilerim. Umarım bu rehber faydalı olmuştur.
