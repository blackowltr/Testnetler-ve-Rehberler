#!/bin/bash
# Bu script, initia-testnet için snapshot alır ve yerel makinede kurar.

# Herhangi bir hata durumunda betiği durdur
set -e

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
(curl -o initia-testnet_latest.tar.lz4 https://snapshots-testnet.nodejumper.io/initia-testnet/initia-testnet_latest.tar.lz4 && \
lz4 -dc initia-testnet_latest.tar.lz4 | tar -xf - -C $HOME/.initia) &
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
