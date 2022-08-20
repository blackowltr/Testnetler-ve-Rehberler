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
wget -O teritori.sh https://raw.githubusercontent.com/brsbrc/Testnetler-ve-Rehberler/main/Teritori/teritori.sh && chmod +x teritori.sh && ./teritori.sh
```

## State Sync (Şart Değil)

```
SNAP_RPC="http://teritori.stake-take.com:26657"
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 1000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)
sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"| ; \
s|^(seeds[[:space:]]+=[[:space:]]+).*$|\1\"\"|" $HOME/.teritorid/config/config.toml
teritorid tendermint unsafe-reset-all --home $HOME/.teritorid
sudo systemctl restart teritorid && journalctl -fu teritorid -o cat
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
