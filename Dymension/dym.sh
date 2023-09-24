#!/bin/bash

# Kullanıcıdan Dymension node adı
```
read -p "Lütfen Dymension node adını girin: " NODE_ADI
```

# Ana dizine git, eğer varsa önceki Dymension dizinini sil daha sonra Dymension kaynak kodunu GitHub'dan klonla ve gerekli dosyaları yükle
```
cd || return
rm -rf dymension
git clone https://github.com/dymensionxyz/dymension.git
Dymension dizinine git
cd dymension || return
git checkout v1.0.2-beta
make install
```
sleep 2

# Dymension konfigürasyonunu ayarla
```
dymd config keyring-backend test
dymd config chain-id froopyland_100-1
```

# Dymension node'u başlat
```
dymd init "$NODE_ADI" --chain-id froopyland_100-1
```
sleep 2

# Genesis ve addrbook yani adres defterini indir
```
curl -s https://raw.githubusercontent.com/dymensionxyz/testnets/main/dymension-hub/froopyland/genesis.json > $HOME/.dymension/config/genesis.json
curl -s https://snapshots-testnet.nodejumper.io/dymension-testnet/addrbook.json > $HOME/.dymension/config/addrbook.json
```
sleep 2

# Seeds ve Peers ayarlarını güncelle
```
SEEDS="ade4d8bc8cbe014af6ebdf3cb7b1e9ad36f412c0@testnet-seeds.polkachu.com:20556,92308bad858b8886e102009bbb45994d57af44e7@rpc-t.dymension.nodestake.top:666,284313184f63d9f06b218a67a0e2de126b64258d@seeds.silknodes.io:26157"
PEERS=""
sed -i 's|^seeds *=.*|seeds = "'$SEEDS'"|; s|^persistent_peers *=.*|persistent_peers = "'$PEERS'"|' $HOME/.dymension/config/config.toml
```
sleep 2

# Uygulama ayarlarını güncelle
```
sed -i 's|^pruning *=.*|pruning = "custom"|g' $HOME/.dymension/config/app.toml
sed -i 's|^pruning-keep-recent  *=.*|pruning-keep-recent = "100"|g' $HOME/.dymension/config/app.toml
sed -i 's|^pruning-interval *=.*|pruning-interval = "10"|g' $HOME/.dymension/config/app.toml
sed -i 's|^snapshot-interval *=.*|snapshot-interval = 0|g' $HOME/.dymension/config/app.toml
```
sleep 2

# Minimum gas fiyatlarını ayarla ve Prometheus'u etkinleştir
```
sed -i 's|^minimum-gas-prices *=.*|minimum-gas-prices = "0.0001udym"|g' $HOME/.dymension/config/app.toml
sed -i 's|^prometheus *=.*|prometheus = true|' $HOME/.dymension/config/config.toml
```
sleep 2

# Dymension node'u systemd ile yapılandır
```
sudo tee /etc/systemd/system/dymd.service > /dev/null << EOF
[Unit]
Description=Dymension testnet Node
After=network-online.target
[Service]
User=$USER
ExecStart=$(which dymd) start
Restart=on-failure
RestartSec=10
LimitNOFILE=10000
[Install]
WantedBy=multi-user.target
EOF
```
sleep 2

# Dymension node'u yeniden başlat (önyükleme)
```
dymd tendermint unsafe-reset-all --home $HOME/.dymension --keep-addr-book
```
sleep 2

# Dymension snapshot indir ve bu snapshot'ı çıkar
```
SNAP_NAME=$(curl -s https://snapshots-testnet.nodejumper.io/dymension-testnet/info.json | jq -r .fileName)
curl "https://snapshots-testnet.nodejumper.io/dymension-testnet/${SNAP_NAME}" | lz4 -dc - | tar -xf - -C "$HOME/.dymension"
```
sleep 2

# systemd'yi yeniden yükle ve Dymension node'u başlat
```
sudo systemctl daemon-reload
sudo systemctl enable dymd
sudo systemctl start dymd
```

echo "Dymension Node'unuz Başarıyla Kuruldu!"
echo "Dymension ile ilgili güncellemeleri ve daha fazlasını öğrenmek için beni X'te (Twitter) takip edebilirsiniz: https://twitter.com/brsbtc"
