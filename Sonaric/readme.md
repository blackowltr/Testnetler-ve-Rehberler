# Sonaric Node Kurulum Rehberi

## Sistem Gereksinimleri

| Bileşen    | Minimum Gereksinimler |
|------------|------------------------|
| **CPU**    | 2 çekirdekli işlemci    |
| **RAM**    | 4 GB                   |
| **Depolama** | 20 GB SSD             |
| **İşletim Sistemi** | Ubuntu 22        |

### Kurulum
```shell
wget -qO - https://raw.githubusercontent.com/blackowltr/Testnetler-ve-Rehberler/main/Sonaric/sonaric.sh | bash
```

### Yedekleme
```shell
sonaric identity-export -o mysonaric.identity
```

### Puan Kontrol
```shell
sonaric points
```
## Operator Rolü Alma

Discord'a gidin: https://discord.gg/Ngn5faGa

Herhangi bir chatte gelin /addnode yazın ve enter'layın.

Çıkan kodu aşağıdaki komuta yazın.

```shell
 curl -sSL http://get.sonaric.xyz/scripts/register.sh | bash -s -- KODYAZBURAYA 
```
