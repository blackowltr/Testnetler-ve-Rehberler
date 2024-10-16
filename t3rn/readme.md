# Executor Kurulum Rehberi

## Oto Kurulum

Aşağıdaki komut ile kurulum işlemlerini hızlıca gerçekleştirebilirsiniz. Bu komut, scripti indirip çalıştırır ve gerekli adımları sizin için otomatik olarak yapar.
> Private key'inizi girerken güvenlik amacıyla yazdığınız karakterler görünmeyecektir. Bu durum normaldir; bir sorun olduğunu düşünmeyin, girişiniz kaydediliyor.
```shell
bash <(curl -s https://raw.githubusercontent.com/blackowltr/Testnetler-ve-Rehberler/refs/heads/main/t3rn/t3rn.sh)
```

---

## Manuel Kurulum 

1. İlk olarak, executor binary'sini indirip çıkarın:
   ```bash
   wget https://github.com/t3rn/executor-release/releases/download/v0.21.7/executor-linux-v0.21.7.tar.gz
   tar -xvzf executor-linux-v0.21.7.tar.gz
   cd /root/executor/executor/bin
   ```

2. Testnet olarak ayarlayın:
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

5. Buraya kendi private key'inizi yazın:
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

Beni X'te [takip etmeyi](https://x.com/brsbtc) unutmayın!
