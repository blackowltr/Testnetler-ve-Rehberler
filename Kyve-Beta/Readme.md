# KYVE Beta Test

### Binary Dosyası
```
wget https://nc2.breithecker.de/s/BY4Lzj8TAQzgJZm/download/chain_linux_amd64.tar.gz
tar -xvzf chain_linux_amd64.tar.gz
```
```
> isim kısmına kendi isminizi yazın.
./chaind init [isim] --chain-id kyve-beta
```

### Genesis Dosyası
```
wget https://kyve-beta.s3.eu-central-1.amazonaws.com/genesis/genesis-v0.7.0-beta.json
# move to the chain-node directory
mv genesis-v0.7.0-beta.json ~/.kyve/config/genesis.json
```

### Başlatalım
./chaind start --p2p.persistent_peers="410bf0cb2cdb9a6e159c14b9d01531b9ecb1edd4@3.70.26.46:26656"

### KYSOR Binary Dosyası
```
wget https://kyve-beta.s3.eu-central-1.amazonaws.com/kysor/kysor-linux-x64.zip
unzip kysor-linux-x64.zip
mv kysor-linux-x64 kysor
chmod +x kysor
```

### Valaccount Oluşturma
```
./kysor valaccounts create \
--name moonbeam \
--pool 0 \
--storage-priv "$(cat path/to/arweave.json)" \
--network beta \
--verbose \
--metrics \
--metrics-port 1234
```

### Mevcut bir hesabınız varsa ve bunu kullancaksanız
```
./kysor valaccounts create \
--name moonbeam \
--pool 0 \
--storage-priv "$(cat path/to/arweave.json)" \
--network beta \
--verbose \
--metrics \
--metrics-port 1234
--recover
```

### Kysor Çalıştırma
```
./kysor start --valaccount moonbeam
```

```
mv kyve-upgrade-binary $HOME/.kysor/upgrades/@kyve/$RUNTIME/$VERSION/
```

```
mv kyve-upgrade-binary $HOME/.kysor/upgrades/@kyve/evm/1.9.0/
```

### Servis Dosyası
```
tee <<EOF > /dev/null /etc/systemd/system/moonbeamd.service
[Unit]
Description=KYVE Protocol-Node moonbeam daemon
After=network-online.target

[Service]
User=$USER
ExecStart=/home/$USER/kysor start --valaccount moonbeam --auto-download-binaries
Restart=on-failure
RestartSec=3
LimitNOFILE=infinity
EOF
```

```
sudo systemctl enable moonbeamd
sudo systemctl start moonbeamd
```

### Durdurmak için
```
sudo systemctl stop moonbeamd
```

### Log Kontrol
```
sudo journalctl -u moonbeamd -f
```

## Explorer ---------> https://explorer.kyve.network/korellia
## Explorer ---------> https://kyve.explorers.guru/

### Hepinize Kolay Gelsin.

### Sorunuz olursa: https://t.me/NotitiaGroup ve https://t.me/NotitiaChannel beklerim.
