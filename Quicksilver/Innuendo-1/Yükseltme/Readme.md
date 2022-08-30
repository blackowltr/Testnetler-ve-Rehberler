## Yükseltme

**İlgili Bloğa Geldiğnizde Şu Uyarıyı Alacaksınız.** 
> ERR UPGRADE "xxx" NEEDED at height: 136750

```
sudo systemctl stop quicksilverd
cd $HOME && rm quicksilver -rf
git clone https://github.com/ingenuity-build/quicksilver.git --branch innuendo1
cd quicksilver
make build
sudo chmod +x ./build/quicksilverd && sudo mv ./build/quicksilverd /usr/local/bin/quicksilverd
sudo systemctl restart quicksilverd && journalctl -fu quicksilverd -o cat
```

## Hepinize Kolay Gelsin.
