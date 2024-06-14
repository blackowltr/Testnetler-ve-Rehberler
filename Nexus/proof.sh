#!/bin/bash

# Source Rust environment variables
source "$HOME/.cargo/env"

# Step 1: Install CMAKE
echo "Installing CMAKE..."
sudo apt install cmake -y
sleep 1.5  # Wait for 1.5 seconds

# Step 2: Install Build Essential Package
echo "Installing Build Essential Package..."
sudo apt update
sudo apt install build-essential -y
sleep 1.5  # Wait for 1.5 seconds

# Step 3: Install Nexus zkVM
echo "Installing Nexus zkVM..."

# Add RISC-V target
rustup target add riscv32i-unknown-none-elf
sleep 1.5  # Wait for 1.5 seconds

# Install Nexus zkVM
cargo install --git https://github.com/nexus-xyz/nexus-zkvm nexus-tools --tag 'v1.0.0'
sleep 1.5  # Wait for 1.5 seconds

# Verify installation
echo "Verifying Nexus zkVM installation..."
cargo nexus --help
sleep 1.5  # Wait for 1.5 seconds

# Step 4: Create a New Nexus Project
echo "Creating a new Nexus Project..."
cargo nexus new nexus-project
sleep 1.5  # Wait for 1.5 seconds

# Step 5: Navigate to the Project Directory and Edit Files
echo "Navigating to the project directory and editing main.rs..."

# Navigate to the project directory
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

echo "Proof completed successfully."
echo "Don't forget to follow me on X: https://x.com/brsbtc"
