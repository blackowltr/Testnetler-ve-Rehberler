#Silme Komutları

## Stride Node Silme Komutu
```
sudo systemctl stop strided
sudo systemctl disable strided
sudo rm /etc/systemd/system/stride* -rf
sudo rm $(which strided) -rf
sudo rm $HOME/.stride* -rf
sudo rm $HOME/stride -rf
sed -i '/STRIDE_/d' ~/.bash_profile
```

## Hermes Silme Komutu
```
sudo systemctl stop hermesd
sudo systemctl disable hermesd
sudo rm /etc/systemd/system/hermesd* -rf
sudo rm $(which hermes) -rf
sudo rm -rf $HOME/.hermes
sudo rm -rf $HOME/hermes*
```

## Relayer Silme Komutu
```
sudo systemctl stop relayerd
sudo systemctl disable relayerd
sudo rm /etc/systemd/system/relayerd* -rf
sudo rm $(which rly) -rf
sudo rm -rf $HOME/.relayer
sudo rm -rf $HOME/relayer
```

## Icq Silme Komutları
```
sudo systemctl stop icqd
sudo systemctl disable icqd
sudo rm /etc/systemd/system/icqd* -rf
sudo rm $(which icq) -rf
sudo rm -rf $HOME/.icq
sudo rm -rf $HOME/interchain-queries
```

## Herkese Kolay Gelsin..
