# Gaia Kurulumu

![gaia](https://user-images.githubusercontent.com/107190154/185763121-70192b82-f639-4f90-b2f9-f696d5a0c0d8.png)

### Explorer
> https://poolparty.stride.zone/GAIA

## Kuruluma geçelim.
```
wget -O gaia.sh https://raw.githubusercontent.com/brsbrc/Testnetler-ve-Rehberler/main/Stride/Gaia/gaia.sh && chmod +x gaia.sh && ./gaia.sh
```

## Sync Durumu 
```
gaiad status 2>&1 | jq .SyncInfo
```

## State Sync (Şart Değil, dileyen kullanabilir.)
> Kullanırsanız bir müddet bekleyin. 10-15 dk kadar sürebilir.

```
SNAP_RPC1="https://gaia.poolparty.stridenet.co:445" \
&& SNAP_RPC2="https://gaia.poolparty.stridenet.co:445"
LATEST_HEIGHT=$(curl -s $SNAP_RPC2/block | jq -r .result.block.header.height) \
&& BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)) \
&& TRUST_HASH=$(curl -s "$SNAP_RPC2/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)
sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC1,$SNAP_RPC2\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" $HOME/.gaia/config/config.toml
gaiad tendermint unsafe-reset-all --home $HOME/.gaia
sudo systemctl restart gaiad && journalctl -fu gaiad -o cat
```

## Cüzdan Oluşturma
```
gaiad keys add cüzdanismi
```
## Cüzdan Recover
```
gaiad keys add $WALLET --recover
```
## Validator Oluşturma

```
gaiad tx staking create-validator \
  --amount 1000000uatom \
  --from cüzdanismi \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(gaiad tendermint show-validator) \
  --moniker nodeismi \
  --chain-id GAIA
```

## Bazı Önemli Komutlar

### Log Kontrol
```
journalctl -fu gaiad -o cat
```

### Servisi Başlatma
```
sudo systemctl start gaiad
```

### Servisi Durdurma
```
sudo systemctl stop gaiad
```

### Servisi Yeniden Başlatma
```
sudo systemctl restart gaiad
```

### Sync Durumu
```
gaiad status 2>&1 | jq .SyncInfo
```
### Validator Bilgisi
```
gaiad status 2>&1 | jq .ValidatorInfo
```
### Unjail 
```
gaiad tx slashing unjail \
  --broadcast-mode=block \
  --from=cüzdanismi \
  --chain-id=GAIA \
  --gas=auto
```
### Node Silme
```
sudo systemctl stop gaiad
sudo systemctl disable gaiad
sudo rm /etc/systemd/system/gaia* -rf
sudo rm $(which gaiad) -rf
sudo rm $HOME/.gaia* -rf
sudo rm $HOME/gaia -rf
sed -i '/GAIA_/d' ~/.bash_profile
```

### Herkese Kolay Gelsin..
