# <h1 align="center">Newrl</h1>

![BlackOwl1Q](https://user-images.githubusercontent.com/107190154/195502504-e60ef767-7a90-49d1-93fb-d9e401b9bb7f.gif)

### Kaynak döküman : [Link](https://www.publish0x.com/pramonoutomo/newrl-nodes-installation-xxzvrdp)
### Kaynak video : [Link](https://www.youtube.com/watch?v=1MfI3_shvsg)
### Kaynak Türkçe video : [Link](https://youtu.be/Zxpiv0YQoJA)

# Linkler
> ## [Discord](https://discord.gg/3jzzVSZA)
> ## [Newrl website](https://newrl.net/)

## Sistem güncellemesi yapıyoruz
```
apt-get install update && apt-get upgrade -y
```

## Gerekli kütüphanelerin kurulumunu yapıyoruz.
```
sudo apt install -y build-essential libssl-dev libffi-dev git curl screen
```

## Python kurulumu yapıyoruz.
```
sudo apt install python3.9
```

## pip ve python3 venv kurulumu yapıyoruz.
```
curl -sSL https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python3 get-pip.py
sudo apt install python3.9-venv
sudo mkdir newrl-venv
cd newrl-venv
python3.9 -m venv newrl-venv
```

## Değişkenleri yeniliyoruz.
```
source newrl-venv/bin/activate
```

## Binary kurulumu yapıyoruz.
```
cd
git clone https://github.com/newrlfoundation/newrl.git
cd newrl
scripts/install.sh testnet
```

## Cüzdan oluşturuyoruz. {} arasında oluşan public,private,adress bilgilerinin tamamını kaydedin.
* Enter enviroment kısmında testnet giriyoruz.
* Y diyerek onaylıyoruz.

```
python3 scripts/show_wallet.py
```
![image](https://user-images.githubusercontent.com/73015593/194652222-59d6e443-8999-4da1-98c2-c5b2ec5aa059.png)

## Cüzdan sitesine gidiyoruz [Link](https://wallet.newrl.net/) 
* Private key'i giriyoruz.
* Ardından Kaydettiğimiz `{"public": "PublicKey", "private": "Private", "address": "Address"}` Formatındaki bilgiyi siteye giriyoruz.
* KYC kısmına rastgele bir bilgi girebiliriz. Buranın bir önemi yok, şimdilik.

![image](https://user-images.githubusercontent.com/73015593/194652521-a1fe4c3d-6a1d-4b31-8b9e-5403c95cac7b.png)

## Faucet'e giderek token talep ediyoruz. [Link](https://wallet.newrl.net/faucet/)
![image](https://user-images.githubusercontent.com/73015593/194663384-0f689051-c24b-44e9-828b-89936c3fc658.png)

## newrl isimli bir screen oluşturarak node'u başlatıyoruz.
```
screen -S newrl
scripts/start.sh testnet
```

## [Cüzdanımıza](https://wallet.newrl.net/) gidiyoruz. Sol üst taraftan `run a node` kısmını seçiyoruz.
![image](https://user-images.githubusercontent.com/73015593/194664089-4f3ad456-6d80-4bc7-a192-0bbc2baf046d.png)

## Gerekli bilgilerimizi girdikten sonra stake işlemi yapıyoruz.
![image](https://user-images.githubusercontent.com/73015593/194664743-a562f3c6-3a0c-44db-ba78-7a5cb394fbbe.png)

## Son olarak kendiniz kontrol etmek için : (Success çıktısı almanız lazım)
**cüzdan adresi kısmına kendi cüzdan adresinizi girin**
```
http://archive1-testnet1.newrl.net:8421/sc-state?table_name=stake_ledger&contract_address=ct1111111111111111111111111111111111111115&unique_column=wallet_address&unique_value=cüzdanadresi
```
![image](https://user-images.githubusercontent.com/73015593/194668205-6203c110-f2a3-4094-829c-e5268b887af8.png)
