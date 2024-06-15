# Guide to Easily Create Nexus zkVM Proof

### Nexus Proof with one command!

```
curl -sSL https://raw.githubusercontent.com/blackowltr/Testnetler-ve-Rehberler/main/Nexus/proof.sh | bash
```

## Easy Installation and Execution Guide for Nexus zkVM Proof Using Bash Script

This guide will help you set up and run the Nexus zkVM project using the provided Bash script. The script installs necessary tools, creates a new Nexus project, and runs a sample program.

## Prerequisites
- A machine running a Debian-based Linux distribution (e.g., Ubuntu).
- Basic knowledge of the command line interface.

## Script Overview

The script performs the following tasks:
1. Installs CMake.
2. Installs Build Essential packages.
3. Installs Rust and adds the RISC-V target.
4. Installs Nexus zkVM.
5. Creates a new Nexus project.
6. Modifies the `main.rs` file with a sample Fibonacci function.
7. Runs the Nexus program.
8. Generates and verifies a proof for the Nexus program.

## Steps to Use the Script

1. **Download the Script**
   Save the script to a file, e.g., `proof.sh`.

2. **Make the Script Executable**
   Open a terminal and navigate to the directory where you saved the script. Run the following command to make the script executable:
   ```bash
   chmod +x proof.sh
   ```

3. **Run the Script**
   Execute the script with root privileges:
   ```bash
   sudo ./proof.sh
   ```

   The script will automatically install all necessary components, create a Nexus project, and run the provided sample program.

## Script Breakdown

- **CMake Installation:**
  ```bash
  sudo apt install cmake -y
  ```

- **Build Essential Package Installation:**
  ```bash
  sudo apt update
  sudo apt install build-essential -y
  ```

- **Rust Installation:**
  The script checks if Rust is already installed. If not, it installs Rust and adds the RISC-V target.
  ```bash
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  rustup target add riscv32i-unknown-none-elf
  ```

- **Nexus zkVM Installation:**
  ```bash
  cargo install --git https://github.com/nexus-xyz/nexus-zkvm nexus-tools --tag 'v1.0.0'
  ```

- **Creating and Modifying the Nexus Project:**
  ```bash
  cargo nexus new nexus-project
  cd nexus-project/src
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
  ```

- **Running the Nexus Program:**
  ```bash
  cargo nexus run
  ```

- **Generating and Verifying Proof:**
  ```bash
  cargo nexus prove
  cargo nexus verify
  ```

After successfully running the script, you will see the message "Proof completed successfully." 

Don't forget to follow me on X: [https://x.com/brsbtc](https://x.com/brsbtc)
