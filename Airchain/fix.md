# Rollback (Script)

Sunucunuzda bir rollback işlemi gerçekleştirmek için aşağıdaki adımları izleyin. Bu rehberde gerekli scripti oluşturacak ve çalıştıracaksınız.

## 1. Sunucunuza Bağlanın ve Gerekli Dizine Geçin

Öncelikle, terminale bağlanın ve gerekli dizine gidin. Bu işlem için aşağıdaki komutları kullanın:

**Not: Scripti `tracks` dizini altında kaydedin ve orada çalıştırın.**

```bash
screen -S fix
cd tracks
```

## 2. Script Dosyasını Oluşturun

Script dosyasını oluşturmak için aşağıdaki komutu çalıştırarak gerekli dosyayı indirin:

```bash
wget -q -O /root/tracks/fix.sh https://raw.githubusercontent.com/blackowltr/Testnetler-ve-Rehberler/main/Airchain/fix.sh  
```

## 3. Dosyayı Kaydedin ve Kapayın

Dosyayı kaydetmek ve editörden çıkmak için sırasıyla `CTRL + X`, `Y` ve `Enter` tuşlarına basın.

## 4. Scripti Çalıştırın

Son olarak, scripti çalıştırmak için aşağıdaki komutları uygulayın:

```bash
chmod +x fix.sh && ./fix.sh
```

Scriptin çalışmaya başlaması için yukarıdaki komutları çalıştırın. `screen` oturumundan ayrılmak istediğinizde `CTRL + A + D` tuşlarına basarak çıkabilirsiniz.

Sorularınız veya geri bildirimleriniz için bana [X'te](https://x.com/brsbtc) ulaşabilirsiniz.
