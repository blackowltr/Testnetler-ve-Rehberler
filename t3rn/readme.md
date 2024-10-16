# Executor Kurulum Rehberi (t3rn)

![image](https://github.com/user-attachments/assets/373769eb-4416-44bd-9d6a-9d9fcb4363e7)

## Oto Kurulum

Aşağıdaki komut ile kurulum işlemlerini hızlıca gerçekleştirebilirsiniz.

> **Not:** Private key'inizi girerken güvenlik amacıyla yazdığınız karakterler görünmeyecektir. Bu durum normaldir; bir sorun olduğunu düşünmeyin, girişiniz kaydediliyor.

```shell
screen -S executor
```

Eğer yukarıdaki komutu çalıştırırken hata alırsanız, `screen` paketinin kurulu olup olmadığını kontrol edin. Aşağıdaki komutu kullanarak `screen` paketini yükleyebilirsiniz:
```shell
sudo apt install screen
```

Daha sonra, tekrar `screen -S executor` komutunu girin ve devam edin:

```shell
bash <(curl -s https://raw.githubusercontent.com/blackowltr/Testnetler-ve-Rehberler/refs/heads/main/t3rn/t3rn.sh)
```

### Önemli Uyarılar
- **Executor'ı çalıştırdıktan sonra sunucudan ayrılmak isterseniz, `Ctrl + A` tuşlarına basın, ardından `D` tuşuna basarak ayrılabilirsiniz.**
- **Tekrar `screen` oturumuna dönmek istediğinizde, aşağıdaki komutu kullanın:**
```shell
screen -r executor
```
---

## Manuel Kurulum 

1. **Executor binary'sini indirin ve çıkarın:**

   ```bash
   wget https://github.com/t3rn/executor-release/releases/download/v0.21.8/executor-linux-v0.21.8.tar.gz
   tar -xvzf executor-linux-v0.21.8.tar.gz
   cd /root/executor/executor/bin
   ```

2. **Ortamı testnet olarak ayarlayın:**
   ```bash
   export NODE_ENV=testnet
   ```

3. **Log seviyelerini ve format tercihlerinizi ayarlayın:**
   ```bash
   export LOG_LEVEL=debug
   export LOG_PRETTY=false
   ```

4. **Order ve claim işleme seçeneklerini aktif hale getirin:**
   ```bash
   export EXECUTOR_PROCESS_ORDERS=true
   export EXECUTOR_PROCESS_CLAIMS=true
   ```

5. **Private keyinizi yazın (buraya yazan kısma kendi private key'inizi yazın):**
   ```bash
   export PRIVATE_KEY_LOCAL=buraya
   ```

6. **Desteklenen ağları etkinleştirin:**
   ```bash
   export ENABLED_NETWORKS='arbitrum-sepolia,base-sepolia,optimism-sepolia,l1rn'
   ```

7. **Son olarak, executor'ü çalıştırın:**
   ```bash
   ./executor
   ```

### Ek Bilgi:
Test token'ları almak için [Faucet](https://faucet.brn.t3rn.io/) kullanabilirsiniz.

Ayrıca beni X'te [takip edebilirsiniz](https://x.com/brsbtc)!
