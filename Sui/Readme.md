# Sui-Devnet-Node-Kurulumu

## Gereksinimler (minimum)

|CPU | RAM  | Disk  | 
|----|------|----------|
|   2| 8GB  | 50GB    |

Node kurduktan sonra sonda söyleyeceğim işlemleri yapmayı unutmayın!!

## Bir screen oluşturalım:
```
screen -S sui
```

## Full nodeumuzu yükleyelim

```
wget -O sui.sh https://raw.githubusercontent.com/brsbrc/Testnetler-ve-Rehberler/main/Sui/sui.sh && chmod +x sui.sh && ./sui.sh
```

## Güncelleme için

```
wget -O sui.guncelleme.sh https://raw.githubusercontent.com/brsbrc/Testnetler-ve-Rehberler/main/Sui/sui-guncelleme.sh && chmod +x sui.guncelleme.sh && ./sui.guncelleme.sh
```

## Logları kontrol:
```
journalctl -u suid -f -o cat
```

Daha sonra discorda giriyoruz ve mesaj atıyoruz #node-ip-application kanalına: https://discord.gg/JAMG9Q4U

Not: #pick-a-role role kanalından da rol alabilirsiniz isterseniz emojilere tıklayarak.

Nodeunuzu kontrol etmek için: https://node.sui.zvalid.com/

## Yararlı Komutlar 

Node silmek için:
```
sudo systemctl stop suid
sudo systemctl disable suid
sudo rm -rf ~/sui /var/sui/
sudo rm /etc/systemd/system/suid.service
```

Node durumunu kontrol:
```
service suid status
```

Node reset atma:
```
sudo systemctl restart suid
```

Node durdurma: 
```
sudo systemctl stop suid
```

Hepinize kolay gelsin, arkadaşlar..

