## Quicksilver - İnnuendo-1 Kurulum Rehberi

## Kurulum için
```
wget -O innuendo-1.sh https://raw.githubusercontent.com/brsbrc/Testnetler-ve-Rehberler/main/Quicksilver/Innuendo-1/innuendo-1.sh && chmod +x innuendo-1.sh && ./innuendo-1.sh
```

### Sync Kontrol Komutu
```
quicksilverd status 2>&1 | jq .SyncInfo
```

### Cüzdan Oluşturma
```
quicksilverd keys add $WALLET
```

### Recover Komutu
```
quicksilverd keys add cüzdanadresiniz --recover
```

### Bakiye Kontrol Komutu
```
quicksilverd query bank balances cüzdanadresiniz
```

### Validator OLuşturma Komutu
```
quicksilverd tx staking create-validator \
  --amount 1000000uqck \
  --from cüzdanisminiz \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(quicksilverd tendermint show-validator) \
  --moniker nodeisminiz \
  --chain-id innuendo-1
```

### Log Kontrol Komutu
```
journalctl -fu quicksilverd -o cat
```

Başlatma Komutu
```
sudo systemctl start quicksilverd
```

Durdurma Komutu
```
sudo systemctl stop quicksilverd
```

Restart Komutu
```
sudo systemctl restart quicksilverd
```

### Cüzdan Listeleme Komutu
```
quicksilverd keys list
```

### Recover Cüzdan
```
quicksilverd keys add $WALLET --recover
```

### Cüzdan Silme
```
quicksilverd keys delete cüzdanismi
```

### Token Bakiye Öğrenme
```
quicksilverd query bank balances cüzdanadresi
```

### Token Transfer Komutu
```
quicksilverd tx bank send gönderencüzdanadresi alıcıcüzdanadresi 10000000uqck
```

### Oy Komutu
```
quicksilverd tx gov vote 1 yes --from cüzdanisminiz --chain-id=innuendo-1
```

### Kendi Validatorumuze Delege Komutu
```
quicksilverd tx staking delegate $QUICKSILVER_VALOPER_ADDRESS 10000000uqck --from=$WALLET --chain-id=innuendo-1 --gas=auto
```

### Redelege Komutu
```
quicksilverd tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000uqck --from=$WALLET --chain-id=innuendo-1 --gas=auto
```

### Validator Editleme Komutu
```
quicksilverd tx staking edit-validator \
  --moniker=nodeisminiz \
  --identity=<keybase_id_numaranız> \
  --website="<website>" \
  --details="<açıklama>" \
  --chain-id=innuendo-1 \
  --from=Cüzdanismi
```

### Unjail Komutu
```
quicksilverd tx slashing unjail \
  --broadcast-mode=block \
  --from=Cüzdanismi \
  --chain-id=innuendo-1 \
  --gas=auto
```

### Node Silme Komutu
```
sudo systemctl stop quicksilverd
sudo systemctl disable quicksilverd
sudo rm /etc/systemd/system/quicksilver* -rf
sudo rm $(which quicksilverd) -rf
sudo rm $HOME/.quicksilver* -rf
sudo rm $HOME/quicksilver -rf
```

