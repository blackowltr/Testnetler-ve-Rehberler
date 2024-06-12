#!/bin/bash

# Step 1: Download and Install Slinky
echo "Step 1: Downloading and Installing Slinky..."
cd "$HOME" || exit
git clone https://github.com/skip-mev/slinky.git 
cd slinky || exit
git checkout v0.4.3 
make build 
sudo ln -s "$HOME/slinky/build/slinky" "/usr/bin/slinky"

# Step 2: Update app.toml
echo "Step 2: Updating app.toml configuration..."
sed -i '0,/^enabled *=/{//!b};:a;n;/^enabled *=/!ba;s|^enabled *=.*|enabled = "true"|' "$HOME"/.initia/config/app.toml
sed -i -e 's|^oracle_address *=.*|oracle_address = "127.0.0.1:8080"|' "$HOME"/.initia/config/app.toml
sed -i -e 's|^client_timeout *=.*|client_timeout = "500ms"|' "$HOME"/.initia/config/app.toml

# Step 3: Create Oracle Service and Define PORT
echo "Step 3: Creating Oracle service..."
PORT=$(curl -s ifconfig.me)$(grep -A 6 "\[grpc\]" ~/.initia/config/app.toml | sed -n 's/.*:\([0-9]\+\).*/\1/p')

sudo tee /etc/systemd/system/oracle.service > /dev/null <<EOF
[Unit]
Description=oracle

[Service]
Type=simple
User=$USER
ExecStart=/usr/bin/slinky --oracle-config-path "$HOME/slinky/config/core/oracle.json" --market-map-endpoint 0.0.0.0:$PORT
Restart=on-abort
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=oracle
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF

sudo sed -i "s|--market-map-endpoint [^ ]*|--market-map-endpoint 0.0.0.0:$PORT|" /etc/systemd/system/oracle.service

# Step 4: Launch Oracle and Restart Node
echo "Step 4: Launching Oracle service and restarting Initiad..."
sudo systemctl daemon-reload
sudo systemctl enable oracle.service
sudo systemctl start oracle.service
sudo systemctl restart initia.service
sudo journalctl -u oracle.service -f -o cat

echo "Follow my account X: https://x.com/brsbtc"
