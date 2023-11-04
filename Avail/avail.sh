#!/bin/bash

echo -e ''
echo -e '\e[40m\e[92m'
echo ' ██████╗ ██╗      █████╗  ██████╗██╗  ██╗ ██████╗ ██╗    ██╗██╗'     
echo ' ██╔══██╗██║     ██╔══██╗██╔════╝██║ ██╔╝██╔═══██╗██║    ██║██║'
echo ' ██████╔╝██║     ███████║██║     █████╔╝ ██║   ██║██║ █╗ ██║██║'    
echo ' ██╔══██╗██║     ██╔══██║██║     ██╔═██╗ ██║   ██║██║███╗██║██║'
echo ' ██████╔╝███████╗██║  ██║╚██████╗██║  ██╗╚██████╔╝╚███╔███╔╝███████╗'
echo ' ╚═════╝ ╚══════╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝ ╚═════╝  ╚══╝╚══╝ ╚══════╝'
echo -e '\e[0m'
echo ''

# Sistem güncelleme 
sudo apt update
sudo apt upgrade -y
sleep 2

# Gerekli kütüphaneler
sudo apt install -y make clang pkg-config libssl-dev build-essential git screen protobuf-compiler
sleep 2

# Rust
curl https://sh.rustup.rs -sSf | sh
sleep 2

# Rust ortam değişkeni ekleme
source $HOME/.cargo/env
sleep 2

# Rust güncelleme
rustup update
sleep 2

# Rust target ekleme
rustup target add wasm32-unknown-unknown --toolchain nightly
sleep 2

# Avail repo klonlama
git clone https://github.com/availproject/avail.git
sleep 2

# Avail klasörüne girme
cd avail
sleep 2

# Derleme
cargo build --release
sleep 2

# Yeni dizin
mkdir -p output
sleep 2

# Git checkout
git checkout v1.7.2
sleep 2

# Cargo aracı ile Rust uygulamasını çalıştırma
cargo run --locked --release -- --chain kate -d ./output
sleep 2

echo "Kurulum başarıyla tamamlandı. Servis oluşturma adımından devam edin."
