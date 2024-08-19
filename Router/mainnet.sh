#!/bin/bash

# Constants
GO_VERSION="1.21.0"
WASMVM_VERSION="v1.5.2"
ROUTERD_VERSION="v2.1.6"
COSMOVISOR_VERSION="v1.5.0"
CHAIN_ID="router_9600-1"
SNAPSHOT_DATE="2024-08-14"
SNAPSHOT_HEIGHT="8781099"
SNAPSHOT_FILE="${SNAPSHOT_DATE}_router_${SNAPSHOT_HEIGHT}.tar.lz4"
MONIKER="moniker"

# Global Variables
export MONIKER
export DAEMON_NAME="routerd"
export DAEMON_HOME="$HOME/.routerd"
export DAEMON_RESTART_AFTER_UPGRADE="true"
ROUTERD_HOME="$DAEMON_HOME"

# Function to check and install dependencies
install_dependencies() {
  printf "Installing dependencies...\n"

  # Install Go
  if ! command -v go > /dev/null 2>&1; then
    printf "Installing Go %s...\n" "$GO_VERSION"
    wget -q -O - https://git.io/vQhTU | bash -s -- --version "$GO_VERSION"
    source ~/.bashrc
  else
    printf "Go is already installed.\n"
  fi

  # Install jq
  if ! command -v jq > /dev/null 2>&1; then
    printf "Installing jq...\n"
    sudo apt-get update && sudo apt-get install -y jq
  else
    printf "jq is already installed.\n"
  fi

  # Install Cosmovisor
  printf "Installing Cosmovisor %s...\n" "$COSMOVISOR_VERSION"
  go install cosmossdk.io/tools/cosmovisor/cmd/cosmovisor@"$COSMOVISOR_VERSION"
}

# Function to download and set up Routerd binary
setup_routerd() {
  printf "Setting up Routerd binary...\n"
  local routerd_tar="routerd.tar.gz"

  wget -q "https://raw.githubusercontent.com/router-protocol/router-chain-binary-release/${ROUTERD_VERSION}/linux/${routerd_tar}"
  tar -xvf "$routerd_tar" -C .
  chmod +x routerd
  sudo mv routerd /usr/bin

  # Verify installation
  if ! routerd version > /dev/null 2>&1; then
    printf "Error: Routerd installation failed.\n" >&2
    return 1
  fi
}

# Function to configure Routerd
configure_routerd() {
  printf "Configuring Routerd...\n"
  
  # Initialize node
  routerd init "$MONIKER" --chain-id "$CHAIN_ID"

  # Download genesis file
  wget -qO - https://sentry.tm.rpc.routerprotocol.com/genesis | jq '.result.genesis' > "$DAEMON_HOME/config/genesis.json"

  # Add peers
  local peers="ebc272824924ea1a27ea3183dd0b9ba713494f83@router-mainnet-seed.autostake.com:27336,13a59edcee8ede7afa62ae054f266b44701cedc0@213.246.45.16:3656,10fec659763badc3ec55b845c2e6c17a70e77fd5@51.195.104.64:15656,49e4a20d999fe27868a67fc72bc6bf0e1424a610@188.214.133.133:26656,28459bddd2049d31cf642792e6bb87676edaee1e@65.109.61.125:23756,3f2556a0e390fa6f049e85fc0b27064f9ebdb9d7@57.129.28.26:26656,e90a88795977f7cc24982d5684f0f5a4581cd672@185.8.104.157:26656,fbb30fa866f318e9e1c48188711526fc69f66d18@188.214.133.174:26656"
  sed -i "s|^persistent_peers *=.*|persistent_peers = \"$peers\"|" "$DAEMON_HOME/config/config.toml"
}

# Function to download and extract snapshot
download_snapshot() {
  printf "Downloading and extracting snapshot...\n"
  
  cd "$DAEMON_HOME" || return 1
  wget "https://ss.router.nodestake.org/${SNAPSHOT_FILE}"
  
  if ! lz4 -d "$SNAPSHOT_FILE" | tar -xvf -; then
    printf "Error: Failed to extract snapshot.\n" >&2
    return 1
  fi
}

# Function to set up and start the node using Cosmovisor
start_node() {
  printf "Setting up and starting the node with Cosmovisor...\n"

  cosmovisor init "$(which routerd)"
  cosmovisor add-upgrade "2.1.1-nitro-to-${ROUTERD_VERSION}" "$(which routerd)" --upgrade-height 7673000

  cosmovisor run start \
    --log_level "error" \
    --json-rpc.api eth,txpool,personal,net,debug,web3,miner \
    --api.enable start \
    --trace "true" \
    --home "$ROUTERD_HOME"
}

# Function to create a systemd service for the node
create_systemd_service() {
  printf "Creating systemd service...\n"

  local service_file="/etc/systemd/system/routerd.service"
  
  sudo tee "$service_file" > /dev/null <<EOL
[Unit]
Description=Cosmovisor Daemon for Routerd
After=network-online.target

[Service]
User=$(whoami)
Environment="DAEMON_NAME=routerd"
Environment="DAEMON_HOME=$DAEMON_HOME"
Environment="DAEMON_RESTART_AFTER_UPGRADE=true"
Environment="DAEMON_ALLOW_DOWNLOAD_BINARIES=false"
Environment="DAEMON_LOG_BUFFER_SIZE=512"
Environment="UNSAFE_SKIP_BACKUP=true"
ExecStart=$(which cosmovisor) run start \\
          --log_level "info" \\
          --json-rpc.api eth,txpool,personal,net,debug,web3,miner \\
          --api.enable start \\
          --trace "true" \\
          --home $DAEMON_HOME
Restart=always
RestartSec=3
LimitNOFILE=infinity
LimitNPROC=infinity

[Install]
WantedBy=multi-user.target
EOL

  sudo systemctl daemon-reload
  sudo systemctl enable routerd.service
  sudo systemctl start routerd.service
}

main() {
  install_dependencies || { printf "Failed to install dependencies.\n" >&2; exit 1; }
  setup_routerd || { printf "Failed to set up Routerd.\n" >&2; exit 1; }
  configure_routerd || { printf "Failed to configure Routerd.\n" >&2; exit 1; }
  download_snapshot || { printf "Failed to download snapshot.\n" >&2; exit 1; }
  start_node || { printf "Failed to start node.\n" >&2; exit 1; }
  create_systemd_service || { printf "Failed to create systemd service.\n" >&2; exit 1; }

  printf "Node setup complete. The node is running as a systemd service.\n"
}

main "$@"
