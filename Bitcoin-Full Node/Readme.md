# Bitcoin-Full-Node-Kurulum

<img src="https://learn.eqonex.com/storage/app/uploads/public/989/76b/635/thumb__853_0_0_0_crop.webp" width="853" height="479">

## Alttaki komutu çalıştırarak full node'unuzu kurabilirsiniz.

```
wget -O kurulum.sh https://raw.githubusercontent.com/brsbrc/Bitcoin-Full-Node-Kurulum/main/kurulum.sh && chmod +x kurulum.sh && ./kurulum.sh
```

## Log kontrol için

```
tail -f /root/bitcoin-core/.bitcoin/debug.log
```
## Durdurmak için:
```
cd /root/bitcoin-core/bin && ./stop.sh
```
## Kaldırmak için:
```
./install-full-node.sh -u
```
### Hepinize Kolay Gelsin..

