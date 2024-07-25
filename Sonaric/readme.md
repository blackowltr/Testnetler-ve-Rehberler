# Sonaric Node Kurulum Rehberi

## Sistem Gereksinimleri

| Bileşen          | Minimum Gereksinimler |
|------------------|------------------------|
| **CPU**          | 2 çekirdekli işlemci    |
| **RAM**          | 4 GB                   |
| **Depolama**     | 20 GB SSD              |
| **İşletim Sistemi** | Ubuntu 22            |

## Kurulum Adımları

1. **Kurulum Script'ini Çalıştırın:**
   ```shell
   wget -qO - https://raw.githubusercontent.com/blackowltr/Testnetler-ve-Rehberler/main/Sonaric/sonaric.sh | bash
   ```

2. **Identity Yedekleyin:**
   ```shell
   sonaric identity-export -o mysonaric.identity
   ```

3. **Puanlarınızı Kontrol Edin:**
   ```shell
   sonaric points
   ```

## Operator Rolü Alma

1. **Discord'a Katılın:**
   [Sonaric Discord Sunucusu](https://discord.gg/Ngn5faGa)

2. **Discord'da Bir Sohbete Gidin -TR chat olabilir- ve `/addnode` Komutunu Yazın ve Enter'a Basın.**

3. **Alınan Kodu Kullanarak Aşağıdaki Komutu Çalıştırın:**
   ```shell
   curl -sSL http://get.sonaric.xyz/scripts/register.sh | bash -s -- KODYAZBURAYA
   ```
