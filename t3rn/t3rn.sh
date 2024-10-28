#!/bin/bash

# Kullanıcıdan Private Key'i al, girilen karakterleri gizle
read -s -p "Lütfen private key'inizi girin: " PRIVATE_KEY_LOCAL
echo  # Satır başına geçiş için eklenmiştir.

# Sistemi güncelleyin ve gerekli paketleri yükleyin
sudo apt update && sudo apt upgrade -y
sudo apt install curl git wget htop tmux build-essential jq make lz4 gcc unzip -y

# Executor binary'sini indirin ve çıkarın
wget https://github.com/t3rn/executor-release/releases/download/v0.21.10/executor-linux-v0.21.10.tar.gz
tar -xvzf executor-linux-v0.21.10.tar.gz
cd /root/executor/executor/bin

# Testnet ayarları
export NODE_ENV=testnet

# Log seviyeleri ve format tercihleri
export LOG_LEVEL=debug
export LOG_PRETTY=false

# Order ve claim işleme seçenekleri
export EXECUTOR_PROCESS_ORDERS=false
export EXECUTOR_PROCESS_CLAIMS=true

# Kullanıcının girdiği private key'i ayarlayın
export PRIVATE_KEY_LOCAL=$PRIVATE_KEY_LOCAL

# Arbitrum Sepolia için RPC endpointleri
export RPC_ENDPOINTS_ARBT='https://api.zan.top/arb-sepolia'

# Base Sepolia için RPC endpointleri
export RPC_ENDPOINTS_BSSP='https://base-sepolia.blockpi.network/v1/rpc/public'

# Blast Sepolia için RPC endpointleri
export RPC_ENDPOINTS_BLSS='https://endpoints.omniatech.io/v1/blast/sepolia/public'

# Optimism Sepolia için RPC endpointleri
export RPC_ENDPOINTS_OPSP='https://endpoints.omniatech.io/v1/op/sepolia/public'

# RPC ile sipariş kabul etme
export EXECUTOR_PROCESS_PENDING_ORDERS_FROM_API=false

# Executor'ü çalıştırın
./executor
