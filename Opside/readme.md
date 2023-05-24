# Opside Pre-Alpha Testnet Rehberi

![Kurulum 6](https://github.com/brsbrc/Testnetler-ve-Rehberler/assets/107190154/49bb837e-8367-4f74-85b6-e2af63cefd4e)

## Kurulum
```
sudo apt update && sudo apt upgrade -y && sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential bsdmainutils git make ncdu gcc git jq chrony liblz4-tool -y
```
```
wget -c https://pre-alpha-download.opside.network/testnet-auto-install-v2.tar.gz 
tar -C ./ -xzf testnet-auto-install-v2.tar.gz
chmod +x -R ./testnet-auto-install-v2
cd ./testnet-auto-install-v2
```
```
./install-ubuntu-en-1.0.sh
```
### 1- Bu komuttan sonra sizden cüzdan adresi girmenizi isteyecek. Cüzdan adresinizi yazın.

### 2- Bir şifre oluşturun.

### 3- Tekrar cüzdana adresinizi yazın.

### 4- Tekrar az önce oluşturduğunuz şifreyi yazın.

### 5- Mnemonic verecek size, bunu kenara not etmeyi unutmayın. Sonra sizden bu kelimeleri yazmanızı isteyecek.
### Peki nasıl yazacağız?

### Örnek: 
### -Verilen kelimelerin böyle olduğunu varsayalım.
```
tree green red buzz load upload read brown white camera clean mouse
```
### -Bu kelimeleri şöyle düzeltip terminale girin.
```
tree gree red buzz load uplo read brow whit came clea mous
```
### Şimdi node kurduk ve seknronize olmasını beklemeliyiz. Senkronizasyon çok uzun sürmemekte. Explorerdan da güncel blok sayısını kontrol etmeyi unutmayın.

**Explorer:** 

https://pre-alpha.opside.info/ 

https://pre-alpha-beacon.opside.info/

### Senkronize durumunu kontrol etme komutu
```
opside-chain/show-geth-log.sh
```
### Örnek Log kaydı

<img width="1114" alt="image" src="https://github.com/brsbrc/Testnetler-ve-Rehberler/assets/107190154/2734496b-3daf-4d1f-ab6c-6114dcf750c8">

### Bazı arkadaşlar sunucuyu kapatıp açtıktan sonra log komutunu kullanınca çalışmıyor falan diye yazmışlar.

### Bu durumda şunu yapabilirsiniz:
```
cd testnet-auto-install-v2
opside-chain/show-geth-log.sh
```

Devamını tekrar müsait olunca yazarım, şimdilik bu kadar..










