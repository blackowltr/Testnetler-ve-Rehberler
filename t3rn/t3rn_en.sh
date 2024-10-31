#!/bin/bash

# Get the private key from the user, hide the entered characters
read -s -p "Please enter your private key: " PRIVATE_KEY_LOCAL
echo  # Added for line break.

# Update the system and install necessary packages
sudo apt update && sudo apt upgrade -y
sudo apt install curl git wget htop tmux build-essential jq make lz4 gcc unzip -y

# Download and extract the executor binary
wget https://github.com/t3rn/executor-release/releases/download/v0.21.10/executor-linux-v0.21.10.tar.gz
tar -xvzf executor-linux-v0.21.10.tar.gz
cd executor/executor/bin  # Update the directory path

# Testnet settings
export NODE_ENV=testnet

# Log levels and format preferences
export LOG_LEVEL=debug
export LOG_PRETTY=false

# Order and claim processing options
export EXECUTOR_PROCESS_ORDERS=false
export EXECUTOR_PROCESS_CLAIMS=true

# Set the user's entered private key
export PRIVATE_KEY_LOCAL=$PRIVATE_KEY_LOCAL

# Enable networks
export ENABLED_NETWORKS='arbitrum-sepolia,base-sepolia,blast-sepolia,optimism-sepolia'

# Set RPC endpoints
export RPC_ENDPOINTS_ARBT='https://api.zan.top/arb-sepolia'
export RPC_ENDPOINTS_BSSP='https://base-sepolia.blockpi.network/v1/rpc/public'
export RPC_ENDPOINTS_BLSS='https://endpoints.omniatech.io/v1/blast/sepolia/public'
export RPC_ENDPOINTS_OPSP='https://endpoints.omniatech.io/v1/op/sepolia/public'

# Accept pending orders via RPC
export EXECUTOR_PROCESS_PENDING_ORDERS_FROM_API=false

# Run the executor
./executor
