#!/bin/bash

# Router Orchestrator Interactive Installation Script

# Set global variables
HOME_DIR="$HOME"
CONFIG_DIR="$HOME_DIR/.router-orchestrator"
SERVICE_FILE="/etc/systemd/system/router-orchestrator.service"
ORCHESTRATOR_BINARY_URL="https://github.com/router-protocol/router-orchestrator-binary-release/raw/main/linux/router-orchestrator.tar.gz"

# Function to update and install dependencies
install_dependencies() {
    sudo apt update && sudo apt upgrade -y
    sudo apt install git wget gzip -y
}

# Function to install Orchestrator
install_orchestrator() {
    mkdir -p "$HOME_DIR/go/bin"
    if ! wget -qO- "$ORCHESTRATOR_BINARY_URL" | tar -C "$HOME_DIR/go/bin" -xz; then
        printf "Error: Failed to download or extract the Orchestrator binary.\n" >&2
        return 1
    fi
}

# Function to prompt user for configuration details
prompt_config_values() {
    read -p "Enter Router Chain TmRpc (e.g., http://1.2.3.4:26657): " router_chain_tm_rpc
    read -p "Enter Router Chain GRpc (e.g., tcp://1.2.3.4:9090): " router_chain_grpc
    read -p "Enter Cosmos Address (e.g., router5678abcd): " cosmos_address
    read -p "Enter Cosmos Private Key: " cosmos_private_key
    read -p "Enter EVM Address (e.g., 0x1234abcd): " evm_address
    read -p "Enter ETH Private Key: " eth_private_key
}

# Function to create and configure config.json
create_config() {
    mkdir -p "$CONFIG_DIR"
    local config_file="$CONFIG_DIR/config.json"

    cat > "$config_file" <<EOF
{
   "chains": [],
   "globalConfig": {
      "logLevel": "debug",
      "networkType": "mainnet",
      "networkId": "router_9600-1",
      "dbPath": "orchestrator.db",
      "batchSize": 25,
      "batchWaitTime": 4,
      "_routerChainTmRpc": "$router_chain_tm_rpc",
      "_routerChainGRpc": "$router_chain_grpc",
      "evmAddress": "$evm_address",
      "cosmosAddress": "$cosmos_address",
      "ethPrivateKey": "$eth_private_key",
      "cosmosPrivateKey": "$cosmos_private_key"
   }
}
EOF
    printf "Configuration file created at: %s\n" "$config_file"
}

# Function to create the systemd service file
setup_service() {
    sudo tee "$SERVICE_FILE" > /dev/null <<EOF
[Unit]
Description="Router Orchestrator Service"
After=network-online.target

[Service]
User=$USER
Type=simple
ExecStart=$(which router-orchestrator) start --config $HOME_DIR/.router-orchestrator/config.json
Restart=always
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
}

# Function to start the Orchestrator service
start_service() {
    sudo systemctl daemon-reload
    sudo systemctl enable router-orchestrator
    if ! sudo systemctl start router-orchestrator; then
        printf "Error: Failed to start Router Orchestrator service.\n" >&2
        return 1
    fi
    printf "Router Orchestrator service started successfully.\n"
}

# Function to monitor the Orchestrator logs
monitor_logs() {
    printf "Monitoring Router Orchestrator logs...\n"
    journalctl -fu router-orchestrator -o cat
}

# Main function
main() {
    install_dependencies || return 1
    install_orchestrator || return 1
    prompt_config_values
    create_config
    setup_service
    start_service || return 1
    monitor_logs
}

# Execute the main function
main "$@"
