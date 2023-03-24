# Goracle Node Kurulum Rehberi
![giffo](https://user-images.githubusercontent.com/107190154/227453326-28cfa00b-0735-4ca5-9173-220725dd5b7a.gif)

## Sistem Gereksinimleri
|CPU | RAM  | Disk  | 
|----|------|----------|
|   1-2| 4GB  | 10GB    |

### Pera Wallet : https://perawallet.app/
### Faucet : https://bank.testnet.algorand.network/

## Kurulumu başlatalım
```
sudo wget -qP /usr/bin/ https://staging.dev.goracle.io/downloads/latest-staging/goracle && sudo chmod u+x /usr/bin/goracle
```
<img width="866" alt="image" src="https://user-images.githubusercontent.com/107190154/227453855-af03e5f3-ecb5-4fe9-9623-d8dab70f5375.png">

## Goracle Başlatma
```
sudo goracle init
```
## Komutu çalıştırdıktan gelen 2 soruya da "Y" deyin enterlayın.
<img width="892" alt="image" src="https://user-images.githubusercontent.com/107190154/227454143-55d0fa71-8abd-4740-a1eb-8c28d78253a9.png">

## Son soruya da direkt enter deyin ve geçin.
<img width="878" alt="image" src="https://user-images.githubusercontent.com/107190154/227454251-a215f3af-8165-43da-acab-7c3181b66b81.png">

## Bu sefer ise Algorand cüzdan adresimizi yazacağız. Adresinize şuradan erişebilirsiniz. (https://testnet-app.goracle.io/nodes/optin)
<img width="873" alt="image" src="https://user-images.githubusercontent.com/107190154/227454571-aa9ac58b-e6d3-486f-98ca-8cebc4c4ea03.png">

## Kırmızı yerde bulunan bağlantıyı açın. Sizi Websitesine götürecek. Cüzdanınızın bağlantısı yoksa cüzdanınızı bağlayın.
<img width="853" alt="fasfasfafa" src="https://user-images.githubusercontent.com/107190154/227455012-87cf7ae9-78d6-4ce4-a944-0536834a298c.png">

## Karşımıza çıkan kısımda aşağıda bulunan "Register" butonuna basalım.
<img width="1259" alt="Adsızrtyuıuytr" src="https://user-images.githubusercontent.com/107190154/227455484-9275ec6a-0d34-4e82-b4e0-48b8bf6bb517.png">

## Cüzdandan işlemi onaylayalım.
<img width="1071" alt="image" src="https://user-images.githubusercontent.com/107190154/227455604-7ec04b86-2f08-4aa1-83cc-5fa7b343009d.png">

## Karşımıza aşağıdaki ekran gelecek.
<img width="1260" alt="image" src="https://user-images.githubusercontent.com/107190154/227456653-5342967a-8355-417c-91a1-8a63f210def0.png">

## Sağ taraftaki "Get a test Gora" butonuna basalım.
<img width="1071" alt="345tf" src="https://user-images.githubusercontent.com/107190154/227456928-8d07d768-e5db-4d48-aef3-099aae598004.png">

## Erişim koudunuzu yazıp onaylayın. Erişim kodu olmayanlar Gora test token alamıyor.
<img width="422" alt="image" src="https://user-images.githubusercontent.com/107190154/227458195-f244053c-f58f-4137-b029-ad73407e0d5b.png">

## Add Stake butonuna basıp tokenleri stake edelim.
<img width="345" alt="Adsızsafafa" src="https://user-images.githubusercontent.com/107190154/227458406-7c695c1e-3f7c-4c69-aa88-b37135238d25.png">

## Şimdi Docker Kuralım.
```
bash <(wget -qO- https://raw.githubusercontent.com/ttimmatti/dependencies/main/docker.sh)
```
## Node'u başlatalım.
```
sudo goracle docker-start --background
```
## Log Kontrol
```
docker logs -f goracle-nr
```
<img width="755" alt="image" src="https://user-images.githubusercontent.com/107190154/227458977-98f2fca9-83b0-4c36-99f7-f3ca3ed03469.png">

### Artık Goracle Node Başarıyla Kurulmuş Oldu. Kolay Gelsin..


