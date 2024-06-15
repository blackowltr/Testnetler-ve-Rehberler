#!/bin/bash

set -e  # Hata alındığında script'i durdur

# CMAKE yükle
echo "CMAKE yükleniyor..."
sudo apt install cmake -y
sleep 1.5

# Build Essential paketi yükle
echo "Build Essential paketi yükleniyor..."
sudo apt update
sudo apt install build-essential -y
sleep 1.5

# Rust ve Nexus zkVM yükle
echo "Rust ve Nexus zkVM yükleniyor..."

# Rust yükle
if ! command -v rustup &> /dev/null; then
    echo "Rust yüklü değil. Rust yükleniyor..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
else
    echo "Rust zaten yüklü. Atlanıyor..."
    source "$HOME/.cargo/env"
fi
sleep 1.5

# RISC-V hedefini ekle
if ! rustup target list | grep -q 'riscv32i-unknown-none-elf (installed)'; then
    rustup target add riscv32i-unknown-none-elf
else
    echo "RISC-V hedefi zaten eklenmiş. Atlanıyor..."
fi
sleep 1.5

# Nexus zkVM yükle
if ! cargo install --list | grep -q 'nexus-tools'; then
    cargo install --git https://github.com/nexus-xyz/nexus-zkvm nexus-tools --tag 'v1.0.0'
else
    echo "Nexus zkVM zaten yüklü. Atlanıyor..."
fi
sleep 1.5

# Yeni Nexus projesi oluştur
echo "Yeni Nexus projesi oluşturuluyor..."
cargo nexus new nexus-project
sleep 1.5

# Proje dizinine gidip main.rs dosyasını düzenle
echo "Proje dizinine gidiliyor ve main.rs dosyası düzenleniyor..."
cd nexus-project/src

# main.rs dosyasını düzenle
cat << EOF > main.rs
#![no_std]
#![no_main]

fn fib(n: u32) -> u32 {
    match n {
        0 => 0,
        1 => 1,
        _ => fib(n - 1) + fib(n - 2),
    }
}

#[nexus_rt::main]
fn main() {
    let n = 7;
    let result = fib(n);
    assert_eq!(result, 13);
}
EOF

# Programı çalıştır
echo "Nexus Programı çalıştırılıyor..."
cd ..
cargo nexus run
sleep 1.5

# Program için proof oluştur
echo "Nexus Programı için proof oluşturuluyor..."
cargo nexus prove
sleep 1.5

# Proof'u doğrula
echo "Proof doğrulanıyor..."
cargo nexus verify
sleep 1.5

# Son mesaj
echo "Script başarıyla tamamlandı."
echo "Beni X'te takip etmeyi unutma: https://x.com/brsbtc"
