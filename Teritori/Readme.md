# Teritori-Testnet

## Sistem gereksinimleri:

|CPU | RAM  | Disk  | 
|----|------|----------|
|   4| 8GB  | 250GB    |


## Makinemizi kuruyoruz:
```
apt update && apt upgrade -y 
```

```
apt install build-essential git curl gcc make jq -y
```

## Node Kurulumuna başlayalım.

```
wget -O teritori.sh https://raw.githubusercontent.com/brsbrc/Teritori-Testnet/main/teritori.sh && chmod +x teritori.sh && ./teritori.sh
```

## Test tokeni için discorda gidelim: https://discord.gg/F7pYBrHE
```
$request Cüzdan adresi
```

## Sync Durumunu Kontrol İçin
```
teritorid status 2>&1 | jq .SyncInfo
```

## Eşleşince Validator oluşturma Moniker (validator ısmı) ve from (cüzdan) kısımlarını düzenleyin:
```
teritorid tx staking create-validator --chain-id teritori-testnet-v2 --commission-rate 0.1 --commission-max-rate 0.1 --commission-max-change-rate 0.1 --min-self-delegation "900000" --amount 900000utori --pubkey $(teritorid tendermint show-validator) --moniker nodeisminiziyazın --from cüzdanisminiziyazın --fees 555utori
```

## Validator oluşturduktan sonra discordda role request kanalından rol alın

[Explorer](https://teritori.explorers.guru/)
