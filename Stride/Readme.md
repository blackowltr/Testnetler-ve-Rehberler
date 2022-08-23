# Stride Testneti Kurulum Rehberi

<img width="431" alt="stride111" src="https://user-images.githubusercontent.com/107190154/184557695-bc92418f-1eb8-4514-ae06-d89802efda9a.png">

> Not: Şu an kurduğumuz direkt chain-4 olan arkadaşlar.

> [Snapshotla ya da state sync ile kurmak için](https://github.com/brsbrc/Testnetler-ve-Rehberler/blob/main/Stride/Snapshot/snapshot-statesync.md)

> Halihazırda stride kuruluysa sunucunuzda [buradaki](https://github.com/brsbrc/Testnetler-ve-Rehberler/blob/main/Stride/Y%C3%BCkseltmeler/Stride-Testnet-4.md) adımları takip ederek yeni chaine yani chain-4'e geçebilirsiniz.

> Stride Testneti hakkında yazmış olduğum [şu yazıya da](https://forum.rues.info/index.php?threads/stride-testnet.2314/) bakabilirsiniz.


### Sistem Gereksinimleri 

|CPU | RAM  | Disk  | 
|----|------|----------|
|   4| 8GB  | 400GB    |

### Kuruluma başlayalım.

```
wget -O stride.sh https://raw.githubusercontent.com/brsbrc/Testnetler-ve-Rehberler/main/Stride/stride.sh && chmod +x stride.sh && ./stride.sh
```

### Log kontrol komutundan sonra log komutu tepki vermiyorsa şu komutu girip ardından yeniden log kontrol yapın.

```
systemctl restart systemd-journald
```

### Sync Durumunuzu öğrenmek için;

```
strided status 2>&1 | jq .SyncInfo
```

### Faucet için; Discorda katılmayı unutmayın. ( https://discord.gg/rDZPaqYd )

### Validator Olmak İçin;

```
strided tx staking create-validator \
  --amount 9900000ustrd \
  --from cüzdanisminiz \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(strided tendermint show-validator) \
  --moniker nodeisminiz \
  --chain-id=STRIDE-TESTNET-4 
```

### Explorer

```
Ping Pub - https://poolparty.stride.zone
NodesGuru - https://stride.explorers.guru
Cosmostation - https://testnet.mintscan.io/stride-testnet
```

### Discorddan Role-Request Odasına Explorerdan validator linkinizi atıp rol almayı unutmayın.

## Stride Önemli Komutlar

### Cüzdandan cüzdana token transfer

```
strided tx bank send gönderencüzdanadresi alıcıcüzdanadresi 1000000ustrd --chain-id=STRIDE-TESTNET-4 --from cüzdanisminiz --fees=250ustrd -y
```

### Kendi validatorumuze delege etme

```
strided tx staking delegate validatorAddress 10000000ustrd --from=WalletName --chain-id=STRIDE-TESTNET-4 --gas=auto
```

### Redelege yapma

```
strided tx staking redelegate gönderenvalidatoradres alıcıvalidatoradres 1000000ustrd --chain-id=STRIDE-TESTNET-4 --from cüzdan --gas=250000 --fees=500ustrd -y
```

### Log kontrol

```
journalctl -u strided -f -o cat
```

### Sync durumu

```
curl -s localhost:16657/status | jq .result.sync_info
```

### Unjail komutu

```
strided tx slashing unjail --from=Cüzdanismi --chain-id=STRIDE-TESTNET-4 --gas-prices=0.025ustrd
```

### Node'u silmek için gerekli komut

```
sudo systemctl stop strided
sudo systemctl disable strided
sudo rm /etc/systemd/system/stride* -rf
sudo rm $(which strided) -rf
sudo rm $HOME/.stride* -rf
sudo rm $HOME/stride -rf
sed -i '/STRIDE_/d' ~/.bash_profile
```

### Kolay Gelsin..

