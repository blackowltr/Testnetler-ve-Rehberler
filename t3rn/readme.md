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

2. **Servisi oluşturun:**

   Aşağıdaki komutu çalıştırarak `executor.service` dosyasını oluşturun:

   ```bash
   sudo tee /etc/systemd/system/executor.service > /dev/null <<EOF
   [Unit]
   Description=Executor Service
   After=network-online.target
   
   [Service]
   User=$USER
   WorkingDirectory=$HOME/executor/executor/bin
   ExecStart=$HOME/executor/executor/bin/executor
   Environment="NODE_ENV=testnet"
   Environment="LOG_LEVEL=debug"
   Environment="LOG_PRETTY=false"
   Environment="EXECUTOR_PROCESS_ORDERS=true"
   Environment="EXECUTOR_PROCESS_CLAIMS=true"
   Environment="PRIVATE_KEY_LOCAL=buraya"  # Kendi private key'inizi buraya ekleyin
   Environment="ENABLED_NETWORKS=arbitrum-sepolia,base-sepolia,optimism-sepolia,l1rn"
   Restart=on-failure
   RestartSec=5
   LimitNOFILE=65535
   
   [Install]
   WantedBy=multi-user.target
   EOF
   ```

   **Not:** `PRIVATE_KEY_LOCAL` kısmına *mutlaka kendi private key'inizi eklemeyi unutmayın*. Bu adım çok kritik!

3. **Servisi Başlatın:**

   Servisi aktif hale getirip başlatmak için şu adımları izleyin:

   ```bash
   sudo systemctl daemon-reload
   sudo systemctl enable executor
   sudo systemctl start executor
   ```

4. **Durumu Kontrol Edin:**

   Executor servisi doğru bir şekilde çalışıyor mu görmek için log kontrol edin:

   ```bash
   sudo journalctl -u executor.service
   ```

### Ek Bilgi:
Test token'ları almak için [Faucet](https://faucet.brn.t3rn.io/) kullanabilirsiniz.

Ayrıca beni X'te [takip edebilirsiniz](https://x.com/brsbtc)!
