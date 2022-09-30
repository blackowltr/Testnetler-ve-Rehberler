# Wormholes Testnet Rehberi

![Wormholes - Testnet](https://user-images.githubusercontent.com/107190154/193325968-3f3954f0-e736-423e-9153-7f3aff500868.gif)

### Sistem Gereksinimleri (Minimum)

![image](https://user-images.githubusercontent.com/107190154/193319079-00dd8efb-61ed-4dd7-8d74-f7713cccad12.png)

Kurulum için 
```
wget -O wormholmes.sh https://raw.githubusercontent.com/brsbrc/Testnetler-ve-Rehberler/main/Wormholes/wormholmes.sh && chmod +x wormholmes.sh && ./wormholmes.sh
```

Sizden Kurulum sırasında private key isteyecek, peki bu keye nasıl ulaşabilirsiniz.

### Şu işarete basalım.
![Ekran görüntüsü 2022-09-30 202147](https://user-images.githubusercontent.com/107190154/193323716-ecd5d453-f3f1-49cd-931a-cc151b63d15b.png)


### Settings Kısmına girelim.
![image](https://user-images.githubusercontent.com/107190154/193324401-133be871-43b4-4ac5-8d9e-c0768f28f2c1.png)

### İşaretlediğim kısma tıklayın ve cüzdan şifrenizi yazın.
![Ekran görüntüsü 2022-09-30 202801](https://user-images.githubusercontent.com/107190154/193324554-fe77ddc7-17ea-4fa3-8e65-39d81b5e93ca.png)

### Karşınıza çıkan sizin private keyiniz.
![Ekran görüntüsü 2022-09-30 203010](https://user-images.githubusercontent.com/107190154/193324930-e56d9ccb-b5b4-4c87-8499-38982dbe81ac.png)


## Bazı Komutlar

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
curl -X POST -H 'Content-Type:application/json' --data '{"jsonrpc":"2.0","method":"eth_getBalance","params":["0x40F01a072167F2665078d20D6a12a210Af08c436","pending"],"id":1}' http://127.0.0.1:8545
```

## Node Kurduk şimdi şu adrese gidelim stake işlemini yapalım: https://www.limino.com/#/wallet

### Şu işarete basalım.
![Ekran görüntüsü 2022-09-30 202147](https://user-images.githubusercontent.com/107190154/193323716-ecd5d453-f3f1-49cd-931a-cc151b63d15b.png)

### `become a validator` kısmına girelim.

![Ekran görüntüsü 2022-09-30 202320](https://user-images.githubusercontent.com/107190154/193323898-b09a073f-8ff3-4a0b-a991-f63086818616.png)

### Stake işlemini Gerçekleştirelim.
> Minimum 7000 erb stake etmelisiniz.
![image](https://user-images.githubusercontent.com/107190154/193324020-c5330cd3-00ba-4fc6-884c-3f8b9195fc6f.png)

## [Explorer](https://www.wormholesscan.com/#/)

### Örneğin benim cüzdanım:

![image](https://user-images.githubusercontent.com/107190154/193322107-7716c1c4-fbce-47fa-b805-54119d9db9fd.png)

