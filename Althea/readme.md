# Althea Node Kurulum Rehberi

```
wget -O althea.sh https://raw.githubusercontent.com/brsbrc/Testnetler-ve-Rehberler/main/Althea/althea.sh && chmod +x althea.sh && ./althea.sh
```

## Validator Oluşturma
```
althea tx staking create-validator \
--amount 1000000ualthea \
--pubkey $(althea tendermint show-validator) \
--moniker "NODEADINIZIYAZIN" \
--chain-id althea_7357-1 \
--commission-rate 0.05 \
--commission-max-rate 0.20 \
--commission-max-change-rate 0.01 \
--min-self-delegation 1 \
--from CUZDANADINIZIYAZIN \
--gas-adjustment 1.4 \
--gas auto \
--gas-prices 0ualthea \
-y
```

## Log kontrol
```
sudo journalctl -u althea -f --no-hostname -o cat
```

## Sync durumu
```
althea status 2>&1 | jq .SyncInfo
```

## Faydalı Komutlar

## Cüzdan Oluşturma
```
althea keys add cuzdanadınızıyazın
```
## Cüzdan Recover
```
althea keys add cuzdanadınızıyazın --recover
```
## Unjail 
```
althea tx slashing unjail --from cuzdanadınızıyazın --chain-id althea_7357-1 --gas-adjustment 1.4 --gas auto --gas-prices 0ualthea -y
```
## Node silme
```
cd $HOME
sudo systemctl stop althea
sudo systemctl disable althea
sudo rm /etc/systemd/system/althea.service
sudo systemctl daemon-reload
rm -f $(which althea)
rm -rf $HOME/.althea
rm -rf $HOME/althea-chain
```
