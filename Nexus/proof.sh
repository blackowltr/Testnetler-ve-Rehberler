#!/bin/bash

set -e  # Hata alındığında script'i durdur

# Fonksiyonlar
print_green() {
    printf "\e[32m%s\e[0m\n" "$1"
}

print_yellow() {
    printf "\e[33m%s\e[0m\n" "$1"
}

print_cyan() {
    printf "\e[36m%s\e[0m\n" "$1"
}

# CMAKE yükle
print_cyan "CMAKE yükleniyor..."
sudo apt install cmake -y
sleep 1.5

# Build Essential paketi yükle
print_cyan "Build Essential paketi yükleniyor..."
sudo apt update
sudo apt install build-essential -y
sleep 1.5

# Rust ve Nexus zkVM yükle
print_cyan "Rust ve Nexus zkVM yükleniyor..."

# Rust yükle
if ! command -v rustup &> /dev/null; then
    print_yellow "Rust yüklü değil. Rust yükleniyor..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
else
    print_yellow "Rust zaten yüklü. Atlanıyor..."
    source "$HOME/.cargo/env"
fi
sleep 1.5

# RISC-V hedefini ekle
if ! rustup target list | grep -q 'riscv32i-unknown-none-elf (installed)'; then
    print_yellow "RISC-V hedefi ekleniyor..."
    rustup target add riscv32i-unknown-none-elf
else
    print_yellow "RISC-V hedefi zaten eklenmiş. Atlanıyor..."
fi
sleep 1.5

# Nexus zkVM yükle
if ! cargo install --list | grep -q 'nexus-tools'; then
    print_yellow "Nexus zkVM yükleniyor..."
    cargo install --git https://github.com/nexus-xyz/nexus-zkvm nexus-tools --tag 'v1.0.0'
else
    print_yellow "Nexus zkVM zaten yüklü. Atlanıyor..."
fi
sleep 1.5

# Yeni Nexus projesi oluştur
print_cyan "Yeni Nexus projesi oluşturuluyor..."
cargo nexus new nexus-project
sleep 1.5

# Proje dizinine gidip main.rs dosyasını düzenle
print_cyan "Proje dizinine gidiliyor ve main.rs dosyası düzenleniyor..."
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
print_cyan "Nexus Programı çalıştırılıyor..."
cd ..
cargo nexus run
sleep 1.5

# Proof oluştur
print_cyan "Nexus Programı için proof oluşturuluyor..."
cargo nexus prove
sleep 1.5

# Proof'u doğrula
print_cyan "Proof doğrulanıyor..."
cargo nexus verify
sleep 1.5

# Sonuç bildiren uyarı
print_green "Proof başarıyla tamamlandı."
print_yellow "Beni X'te takip etmeyi unutmayın: https://x.com/brsbtc"
