# Subspace Gemini-2

![Adsız tasarım](https://user-images.githubusercontent.com/107190154/191179355-ac1b6ff1-095b-4937-8f2c-8578c0774345.gif)

# [Orijinal script kurulum linki](https://github.com/brsbrc/Testnetler-ve-Rehberler/tree/main/Subspace)

## Sistem Gereksinimleri

![image](https://user-images.githubusercontent.com/107190154/191182167-f485e355-6eef-40f6-a442-f1525b51f654.png)

**Node isminizi ve ödüllerin gelmesini istediğiniz cüzdanı yazacaksınız sadece.**

### [Polkadot Cüzdan](https://polkadot.js.org/extension/)

**Ayarlarınız bu şekildeyken çıkan cüzdan adresini kullanacaksınız.**

![image](https://user-images.githubusercontent.com/107190154/191178602-56b0d32d-52cb-4a6e-8ac7-f24a6d5b4761.png)

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



### Hepinize Kolay Gelsin..

