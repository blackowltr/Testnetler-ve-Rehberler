# Initia Oracle Setup Guide

#### Step 1: Download and Install Slinky
First, download and install the Slinky software, which is necessary for the Oracle.

```bash
cd "$HOME"
git clone https://github.com/skip-mev/slinky.git
cd slinky
git checkout v0.4.3
make build
ln -s "$HOME/slinky/build/slinky" "/usr/bin/"
```

#### Step 2: Update app.toml
Next, update the `app.toml` configuration file for Initia.

```bash
sed -i '0,/^enabled *=/{//!b};:a;n;/^enabled *=/!ba;s|^enabled *=.*|enabled = "true"|' $HOME/.initia/config/app.toml
sed -i -e 's|^oracle_address *=.*|oracle_address = "127.0.0.1:8080"|' $HOME/.initia/config/app.toml
sed -i -e 's|^client_timeout *=.*|client_timeout = "500ms"|' $HOME/.initia/config/app.toml
```

#### Step 3: Create Oracle Service
Create a systemd service to manage the Oracle.

# Determine your GRPC port
```bash
PORT=$(echo "$(curl -s ifconfig.me)$(grep -A 6 "\[grpc\]" $HOME/.initia/config/app.toml | egrep -o ":[0-9]+")")
```

# Create the systemd service file
```bash
sudo tee /etc/systemd/system/oracle.service > /dev/null <<EOF
[Unit]
Description=Oracle

[Service]
Type=simple
User=$USER
ExecStart=/usr/bin/slinky --oracle-config-path "$HOME/slinky/config/core/oracle.json" --market-map-endpoint 127.0.0.1:$PORT
Restart=on-abort
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=oracle
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
```

#### Step 4: Launch Oracle and Restart Node
Finally, start the Oracle service and restart the Initia node.

```bash
sudo systemctl daemon-reload
sudo systemctl enable oracle.service
sudo systemctl start oracle.service
sudo systemctl restart initiad
sudo journalctl -u oracle.service -f -o cat
```

### Uninstalling Oracle
If you want to provide instructions for uninstallation:

# Stop and disable Oracle service
```bash
sudo systemctl stop oracle.service
sudo systemctl disable oracle.service
sudo rm /etc/systemd/system/oracle.service
rm -rf $HOME/slinky
sudo rm /usr/bin/slinky
```
