# Subspace Gemini-2

![Adsız tasarım](https://user-images.githubusercontent.com/107190154/191179355-ac1b6ff1-095b-4937-8f2c-8578c0774345.gif)

**Kurulum oldukça basit, arkadaşlar.**

**Node isminizi ve ödüllerin gelmesini istediğiniz cüzdanı yazacaksınız sadece.**

### Kurulum için
```
wget -O subspace.sh https://raw.githubusercontent.com/brsbrc/Testnetler-ve-Rehberler/main/Subspace/subspace.sh && chmod +x subspace.sh && ./subspace.sh
```

### Log Kontrol
```
journalctl -u subspaced -f -o cat
```
### Sync Kontrol
```
curl -H "Content-Type: application/json" -d '{"id":1, "jsonrpc":"2.0", "method": "system_health", "params":[]}' http://localhost:9933
```

### [Polkadot Cüzdan](https://polkadot.js.org/extension/)

**Ayarlarınız bu şekildeyken çıkan cüzdan adresini kullanacaksınız.**

![image](https://user-images.githubusercontent.com/107190154/191178602-56b0d32d-52cb-4a6e-8ac7-f24a6d5b4761.png)

### Hepinize Kolay Gelsin..

