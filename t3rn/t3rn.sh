#!/bin/bash

# Kullanıcıdan özel anahtarı al (gizli olarak)
read -s -p "Lütfen özel anahtarınızı girin: " PRIVATE_KEY
echo  # Satır sonu ekle

# Executor binary'sini indirin ve çıkarın
wget https://github.com/t3rn/executor-release/releases/download/v0.21.8/executor-linux-v0.21.8.tar.gz
tar -xvzf executor-linux-v0.21.8.tar.gz

# Çalışma dizinine git
cd /root/executor/executor/bin || exit

# Service dosyasını oluşturun
sudo tee /etc/systemd/system/executor.service > /dev/null <<EOF
[Unit]
Description=Executor Service
After=network-online.target

[Service]
User=$USER
WorkingDirectory=$HOME/executor/executor/bin
ExecStart=$HOME/executor/executor/bin/executor
Environment="NODE_ENV=testnet"
Environment="LOG_LEVEL=debug"
Environment="LOG_PRETTY=false"
Environment="EXECUTOR_PROCESS_ORDERS=true"
Environment="EXECUTOR_PROCESS_CLAIMS=true"
Environment="PRIVATE_KEY_LOCAL=${PRIVATE_KEY}"  # Kullanıcıdan alınan özel anahtar
Environment="ENABLED_NETWORKS=arbitrum-sepolia,base-sepolia,optimism-sepolia,l1rn"
Restart=on-failure
RestartSec=5
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF

# Servisi başlat
sudo systemctl daemon-reload
sudo systemctl enable executor
sudo systemctl start executor

# Durumu kontrol et
echo "Executor servisi başlatıldı. Durumu kontrol etmek için logları inceleyin:"
sudo journalctl -u executor.service
