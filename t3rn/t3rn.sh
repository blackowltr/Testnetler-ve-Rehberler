#!/bin/bash

# Kullanıcıdan Private Key'i al
read -p "Lütfen private key'inizi girin: " PRIVATE_KEY_LOCAL

# Sistemi güncelleyin ve gerekli paketleri yükleyin
sudo apt update && sudo apt upgrade -y
sudo apt install curl git wget htop tmux build-essential jq make lz4 gcc unzip -y

# Executor binary'sini indirin ve çıkarın
wget https://github.com/t3rn/executor-release/releases/download/v0.21.7/executor-linux-v0.21.7.tar.gz
tar -xvzf executor-linux-v0.21.7.tar.gz
cd /root/executor/executor/bin

# Testnet ayarları
export NODE_ENV=testnet

# Log seviyeleri ve format tercihleri
export LOG_LEVEL=debug
export LOG_PRETTY=false

# Order ve claim işleme seçenekleri
export EXECUTOR_PROCESS_ORDERS=true
export EXECUTOR_PROCESS_CLAIMS=true

# Kullanıcının girdiği private key'i ayarlayın
export PRIVATE_KEY_LOCAL=$PRIVATE_KEY_LOCAL

# Desteklenen ağları etkinleştirin
export ENABLED_NETWORKS='arbitrum-sepolia,base-sepolia,optimism-sepolia,l1rn'

# Executor'ü çalıştırın
./executor
