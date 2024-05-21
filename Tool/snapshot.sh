#!/bin/bash

# initiad'i durdur
sudo systemctl stop initiad
sleep 5

# Priv_validator_state.json dosyasının yedek kopyasını al
cp $HOME/.initia/data/priv_validator_state.json $HOME/.initia/priv_validator_state.json.backup
sleep 5

# Tendermint'i sıfırla
initiad tendermint unsafe-reset-all --home $HOME/.initia --keep-addr-book
sleep 5

# Yedekten geri yükle ve kurulum yap
(curl -L https://snapshots.kjnodes.com/initia-testnet/snapshot_latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.initia) &
wait
sleep 5

# Önceki durumu geri yükle
mv $HOME/.initia/priv_validator_state.json.backup $HOME/.initia/data/priv_validator_state.json
sleep 5

# initiad'i yeniden başlat
sudo systemctl restart initiad
sleep 5

# Logları izle
sudo journalctl -u initiad -f --no-hostname -o cat
