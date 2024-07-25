#!/bin/bash

# giriş
echo -e ''
echo -e '\e[40m\e[92m'
echo ' ██████╗ ██╗      █████╗  ██████╗██╗  ██╗ ██████╗ ██╗    ██╗██╗'     
echo ' ██╔══██╗██║     ██╔══██╗██╔════╝██║ ██╔╝██╔═══██╗██║    ██║██║'
echo ' ██████╔╝██║     ███████║██║     █████╔╝ ██║   ██║██║ █╗ ██║██║'    
echo ' ██╔══██╗██║     ██╔══██║██║     ██╔═██╗ ██║   ██║██║███╗██║██║'
echo ' ██████╔╝███████╗██║  ██║╚██████╗██║  ██╗╚██████╔╝╚███╔███╔╝███████╗'
echo ' ╚═════╝ ╚══════╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝ ╚═════╝  ╚══╝╚══╝ ╚══════╝'
echo -e '\e[0m'
echo ''

echo -e '\e[33mSonaric Node Kurulum Rehberine Hoş Geldiniz!\e[0m'
echo -e '\e[0m'

# Sistem Gereksinimleri
echo -e '\e[34mGerekli Sistem Donanımı\e[0m'
echo -e '\e[34m| Bileşenler    | Minimum Gereksinimler |\e[0m'
echo -e '\e[34m|--------------|-----------------------|\e[0m'
echo -e '\e[34m| CPU          | 2+                    |\e[0m'
echo -e '\e[34m| RAM          | 4+ GB                 |\e[0m'
echo -e '\e[34m| Depolama     | 20 GB SSD             |\e[0m'
echo -e '\e[34m| İşletim Sistemi | Ubuntu 22            |\e[0m'
echo -e '\e[0m'

# Sistem güncellemeleri ve gerekli paketlerin kurulumu
echo -e '\e[34mSistem Güncelleme ve Paket Kurulumu\e[0m'
sudo apt update && sudo apt upgrade -y
if [ $? -ne 0 ]; then
    echo -e '\e[31mSistem güncellemesi başarısız oldu. Lütfen tekrar deneyin.\e[0m'
    exit 1
fi
echo -e '\e[32mSistem güncellemesi başarıyla tamamlandı.\e[0m'

sudo apt install curl git jq build-essential gcc unzip wget lz4 -y
if [ $? -ne 0 ]; then
    echo -e '\e[31mGerekli paketlerin kurulumu başarısız oldu. Lütfen tekrar deneyin.\e[0m'
    exit 1
fi
echo -e '\e[32mGerekli paketlerin kurulumu başarıyla tamamlandı.\e[0m'

# Gerekli dosyaların yüklenmesi
echo -e '\e[34mGerekli Dosyaların Yüklenmesi\e[0m'
wget https://raw.githubusercontent.com/Testnetnodes/Sonaric-Network/main/sonaric.sh && chmod +x sonaric.sh && ./sonaric.sh
if [ $? -ne 0 ]; then
    echo -e '\e[31mDosyaların yüklenmesi başarısız oldu. Lütfen tekrar deneyin.\e[0m'
    exit 1
fi
echo -e '\e[32mGerekli dosyalar başarıyla yüklendi.\e[0m'

# Nodenin başarıyla kurulup kurulmadığını kontrol etme
echo -e '\e[34mNode Kurulumunun Kontrolü\e[0m'
sonaric node-info
if [ $? -ne 0 ]; then
    echo -e '\e[31mNode kurulumu kontrolü başarısız oldu. Lütfen tekrar deneyin.\e[0m'
    exit 1
fi
echo -e '\e[32mNode kurulumu başarıyla kontrol edildi.\e[0m'

# GUI'yi çalıştırma
echo -e '\e[34mGUI\'yi Çalıştırma\e[0m'
IP=$(wget -qO- eth0.me)
ssh -L 127.0.0.1:44003:127.0.1.1:44003 -L 127.0.0.1:44004:127.0.0.1:44004 -L 127.0.0.1:44005:127.0.0.1:44005 -L 127.0.0.1:44006:127.0.0.1:44006 root@$IP
if [ $? -ne 0 ]; then
    echo -e '\e[31mGUI\'yi çalıştırma başarısız oldu. Lütfen tekrar deneyin.\e[0m'
    exit 1
fi
echo -e '\e[32mGUI başarıyla çalıştırıldı.\e[0m'

# Sunucu bilgilerini yedekleme
echo -e '\e[34mSunucu Bilgilerini Yedekleme\e[0m'
sonaric identity-export -o mysonaric.identity
if [ $? -ne 0 ]; then
    echo -e '\e[31mSunucu bilgilerini yedekleme başarısız oldu. Lütfen tekrar deneyin.\e[0m'
    exit 1
fi
echo -e '\e[32mSunucu bilgileri başarıyla yedeklendi.\e[0m'

# Kullanıcıya Moniker adını değiştirip değiştirmek istemediğini sor
echo -e '\e[34mMoniker Adını Değiştirmek İstiyor Musunuz? (y/n)\e[0m'
read -p "Cevabınız: " change_moniker

if [ "$change_moniker" == "y" ]; then
    sonaric node-rename
    if [ $? -ne 0 ]; then
        echo -e '\e[31mMoniker adını değiştirme başarısız oldu. Lütfen tekrar deneyin.\e[0m'
        exit 1
    fi
    echo -e '\e[32mMoniker adı başarıyla değiştirildi.\e[0m'
fi

# Kapanış
echo -e '\e[32mHerhangi bir sorun yaşarsanız destek için benimle iletişime geçin ve beni X\'te takip etmeyi unutmayın. https://x.com/brsbtc\e[0m'
