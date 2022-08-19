# Stride Testneti Kurulum Rehberi

<img width="431" alt="stride111" src="https://user-images.githubusercontent.com/107190154/184557695-bc92418f-1eb8-4514-ae06-d89802efda9a.png">


Sistem Gereksinimleri 

```
4 CPU
8 RAM
250 GB SSD
```

> Not: Şu an kurduğumuz direkt chain-4 olan arkadaşlar.

Makinemizi kuruyoruz.

```
apt update && apt upgrade -y 
```

```
apt install build-essential git curl gcc make jq -y
```

Kuruluma başlayalım.

```
wget -O stride.sh https://raw.githubusercontent.com/brsbrc/Testnetler-ve-Rehberler/main/Stride/stride.sh && chmod +x stride.sh && ./stride.sh
```

Sync Durumunuzu öğrenmek için;

```
strided status 2>&1 | jq .SyncInfo
```

Faucet için; Discorda katılmayı unutmayın. ( https://discord.gg/rDZPaqYd )

Validator Olmak İçin;

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

Explorer

```
https://stride.explorers.guru/
```

Discorddan Role-Request Odasına Explorerdan validator linkinizi atıp rol almayı unutmayın.

## Stride Önemli Komutlar

Cüzdandan cüzdana token transfer

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

