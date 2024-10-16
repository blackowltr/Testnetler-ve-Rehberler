# Kurulum 

1. İlk olarak, executor binary'sini indirip çıkarın:
   ```bash
   wget https://github.com/t3rn/executor-release/releases/download/v0.21.7/executor-linux-v0.21.7.tar.gz
   tar -xvzf executor-linux-v0.21.7.tar.gz
   cd /root/executor/executor/bin
   ```

2. Ortamı testnet olarak ayarlayın:
   ```bash
   export NODE_ENV=testnet
   ```

3. Log seviyelerini ve format tercihlerini ayarlayın:
   ```bash
   export LOG_LEVEL=debug
   export LOG_PRETTY=false
   ```

4. Order ve claim işleme seçeneklerini aktif edin:
   ```bash
   export EXECUTOR_PROCESS_ORDERS=true
   export EXECUTOR_PROCESS_CLAIMS=true
   ```

5. Özel anahtarını ayarlayın (buraya kendi private key'inizi yazın):
   ```bash
   export PRIVATE_KEY_LOCAL=buraya
   ```

6. Desteklenen ağları etkinleştirin:
   ```bash
   export ENABLED_NETWORKS='arbitrum-sepolia,base-sepolia,optimism-sepolia,l1rn'
   ```

7. Son olarak, executor'ü çalıştırın:
   ```bash
   ./executor
   ```

Test token için [Faucet](https://link_to_faucet) kullanabilirsiniz.
