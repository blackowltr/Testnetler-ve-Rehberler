#!/bin/bash

set -e  # Exit script on any error

# Step 1: Install CMAKE
echo "Installing CMAKE..."
sudo apt install cmake -y
sleep 1.5  # Wait for 1.5 seconds

# Step 2: Install Build Essential Package
echo "Installing Build Essential Package..."
sudo apt update
sudo apt install build-essential -y
sleep 1.5  # Wait for 1.5 seconds

# Step 3: Install Rust and Nexus zkVM
echo "Installing Rust and Nexus zkVM..."

# Install Rust
if ! command -v rustup &> /dev/null; then
    echo "Rust is not installed. Installing Rust..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
else
    echo "Rust is already installed. Skipping installation."
    source "$HOME/.cargo/env"
fi
sleep 1.5  # Wait for 1.5 seconds

# Add RISC-V target
if ! rustup target list | grep -q 'riscv32i-unknown-none-elf'; then
    rustup target add riscv32i-unknown-none-elf
else
    echo "RISC-V target already added. Skipping."
fi
sleep 1.5  # Wait for 1.5 seconds

# Install Nexus zkVM
if ! cargo install --list | grep -q 'nexus-tools'; then
    cargo install --git https://github.com/nexus-xyz/nexus-zkvm nexus-tools --tag 'v1.0.0'
else
    echo "Nexus zkVM already installed. Skipping installation."
fi
sleep 1.5  # Wait for 1.5 seconds

# Verify installation
echo "Verifying Nexus zkVM installation..."
cargo nexus --help
sleep 1.5  # Wait for 1.5 seconds

# Step 4: Create a new Nexus Project
echo "Creating a new Nexus Project..."
cargo nexus new nexus-project
sleep 1.5  # Wait for 1.5 seconds

# Step 5: Navigate to Project Directory and Edit Files
echo "Navigating to project directory and editing main.rs..."

# Navigate to project directory
cd nexus-project/src
sleep 1.5  # Wait for 1.5 seconds

# Edit main.rs file
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

# Step 6: Run Your Program
echo "Running the Nexus Program..."
cargo nexus run
sleep 1.5  # Wait for 1.5 seconds

# Step 7: Prove Your Program
echo "Generating proof for the Nexus Program..."
cargo nexus prove
sleep 1.5  # Wait for 1.5 seconds

# Step 8: Verify Your Proof
echo "Verifying the proof..."
cargo nexus verify
sleep 1.5  # Wait for 1.5 seconds

# Final message
echo "Proof completed successfully."
echo "Don't forget to follow me on X: https://x.com/brsbtc"
