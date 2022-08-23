## 70500. Blokta Yapılacak Olan Güncelleme

### Log kontrolunde şu uyarıyı aldığınızda güncellemelisiniz.
> ERR UPGRADE "xxx" NEEDED at height: 70500

### Güncellemeyi Yapmak İçin Komutlar

```
sudo systemctl stop strided
cd $HOME && rm -rf stride
git clone https://github.com/Stride-Labs/stride.git && cd stride
git checkout 90859d68d39b53333c303809ee0765add2e59dab
make build
sudo mv build/strided $(which strided)
sudo systemctl restart strided && journalctl -fu strided -o cat
```
**Not; 70500. blok gelmeden güncelleme yapmayınız. Erken güncelleme yaparsanız hata alırsınız.**

### Herkese Kolay Gelsin.
