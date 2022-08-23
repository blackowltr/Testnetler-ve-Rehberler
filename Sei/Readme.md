# Sei Network Atlantic-1 Kurulum Rehberi

![seiaaa](https://user-images.githubusercontent.com/107190154/184557653-f4a3a698-020c-4197-ab14-ec30fef8d8e1.png)

## Sistem Gereksinimleri (Minimum)

|CPU | RAM  | Disk  | 
|----|------|----------|
|   4| 16GB  | 500GB    |


## Kurulumu başlatalım

```
wget -q -O sei.sh https://raw.githubusercontent.com/brsbrc/Testnetler-ve-Rehberler/main/Sei/sei.sh && chmod +x sei.sh && sudo /bin/bash sei.sh
```

Hızlı Kurulum için [Sei-Snapshot](https://github.com/brsbrc/Testnetler-ve-Rehberler/blob/main/Sei/Snapshot/snapshot-statesync.md)

## Cüzdan oluşturmak için şu komutu kullanalım, cüzdanismi yerine isim koyalım.
```
seid keys add cüzdanismi
```
## Cüzdan recover için 

```
seid keys add cüzdanismi --recover
```

## Cüzdanımızı oluşturduktan sonra faucetten token alalım.  

!faucet + adres komutu ile (https://discord.gg/qFvWGv5k)

## Sync Durumu Kontrol İçin;

```
seid status 2>&1 | jq .SyncInfo
```

## Validator oluşturma, Moniker ve From gibi kısımları kendinize göre uyarlayın:

```
seid tx staking create-validator \
--moniker=Nodeisminiziyazın \
--amount=950000usei \
--pubkey=$(seid tendermint show-validator) \
--chain-id=atlantic-1 \
--commission-max-change-rate=0.01 \
--commission-max-rate=0.20 \
--commission-rate=0.10 \
--min-self-delegation=1 \
--from=cüzdanisminiziyazın \
--yes
```

### Kolay gelsin.

