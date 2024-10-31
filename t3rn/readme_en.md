# Executor Installation Guide (t3rn)

![image](https://github.com/user-attachments/assets/373769eb-4416-44bd-9d6a-9d9fcb4363e7)

## Auto Installation

You can quickly perform the installation with the command below.

> **Note:** When entering your private key, the characters you type will not be visible for security reasons. This is normal; please do not think there is an issue; your input is being recorded.

```shell
screen -S executor
```

If you encounter an error while running the above command, check if the `screen` package is installed. You can install the `screen` package using the following command:
```shell
sudo apt install screen
```

Then, enter the `screen -S executor` command again and proceed:

```shell
bash <(curl -s https://raw.githubusercontent.com/blackowltr/Testnetler-ve-Rehberler/refs/heads/main/t3rn/t3rn.sh)
```

### Important Warnings
- **If you want to disconnect from the server after starting the executor, press `Ctrl + A`, then press `D` to disconnect.**
- **If you want to return to the `screen` session, use the following command:**
```shell
screen -r executor
```
---

## Manual Installation 

1. **Download and extract the executor binary:**

   ```bash
   wget https://github.com/t3rn/executor-release/releases/download/v0.21.10/executor-linux-v0.21.10.tar.gz
   tar -xvzf executor-linux-v0.21.10.tar.gz
   cd /root/executor/executor/bin
   ```

2. **Set the environment to testnet:**
   ```bash
   export NODE_ENV=testnet
   ```

3. **Set the log levels and format preferences:**
   ```bash
   export LOG_LEVEL=debug
   export LOG_PRETTY=false
   ```

4. **Enable order and claim processing options:**
   ```bash
   export EXECUTOR_PROCESS_ORDERS=false
   export EXECUTOR_PROCESS_CLAIMS=true
   ```

5. **Enter your private key (replace the placeholder with your own private key):**
   ```bash
   export PRIVATE_KEY_LOCAL=your_private_key_here
   ```

6. **Enable supported networks:**
   ```bash
   export ENABLED_NETWORKS='arbitrum-sepolia,base-sepolia,optimism-sepolia,l1rn'
   ```

7. **Finally, run the executor:**
   ```bash
   ./executor
   ```

### Additional Information:
You can use the [Faucet](https://faucet.brn.t3rn.io/) to obtain test tokens.

Also, you can follow me on X [here](https://x.com/brsbtc)!
