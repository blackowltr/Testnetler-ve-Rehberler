#!/bin/bash

# Günlük dosyası oluşturma
LOGFILE="/tmp/sonaric_install.log"
exec > >(tee -i $LOGFILE)
exec 2>&1

# Seçim ekranı
echo -e "\e[34mSonaric Node Kurulum Rehberi'ne Hoş Geldiniz!\e[0m"
echo -e "\e[34mLütfen bir seçenek seçin:\e[0m"
echo -e "\e[34m1) Kurulum\e[0m"
echo -e "\e[34m2) Kurulum Sonrası Yedekleme\e[0m"
read -p "Seçiminiz (1/2): " user_choice

if [ "$user_choice" == "1" ]; then
    # Kurulum
    echo -e ""
    echo -e "\e[40m\e[92m"
    echo ' ██████╗ ██╗      █████╗  ██████╗██╗  ██╗ ██████╗ ██╗    ██╗██╗'     
    echo ' ██╔══██╗██║     ██╔══██╗██╔════╝██║ ██╔╝██╔═══██╗██║    ██║██║'
    echo ' ██████╔╝██║     ███████║██║     █████╔╝ ██║   ██║██║ █╗ ██║██║'    
    echo ' ██╔══██╗██║     ██╔══██║██║     ██╔═██╗ ██║   ██║██║███╗██║██║'
    echo ' ██████╔╝███████╗██║  ██║╚██████╗██║  ██╗╚██████╔╝╚███╔███╔╝███████╗'
    echo ' ╚═════╝ ╚══════╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝ ╚═════╝  ╚══╝╚══╝ ╚══════╝'
    echo -e "\e[0m"
    echo ""

    echo -e "\e[33mSonaric Node Kurulum Rehberi'ne Hoş Geldiniz!\e[0m"
    echo -e "\e[0m"

    # Sistem Gereksinimleri
    echo -e "\e[34mGerekli Sistem Donanımı\e[0m"
    echo -e "\e[34m| Bileşenler   | Minimum Gereksinimler |\e[0m"
    echo -e "\e[34m|--------------|-----------------------|\e[0m"
    echo -e "\e[34m| CPU          | 2+                    |\e[0m"
    echo -e "\e[34m| RAM          | 4+ GB                 |\e[0m"
    echo -e "\e[34m| Depolama     | 20 GB SSD             |\e[0m"
    echo -e "\e[34m| İşletim Sistemi | Ubuntu 22            |\e[0m"
    echo -e "\e[0m"

    # Sistem güncellemesi ve gerekli paketlerin kurulumu
    echo -e "\e[34mSistem Güncellemesi ve Paket Kurulumu\e[0m"
    sudo apt update && sudo apt upgrade -y
    if [ $? -ne 0 ]; then
        echo -e "\e[31mSistem güncellemesi başarısız oldu. Lütfen tekrar deneyin.\e[0m"
        exit 1
    fi
    echo -e "\e[32mSistem güncellemesi başarıyla tamamlandı.\e[0m"

    sudo apt install curl git jq build-essential gcc unzip wget lz4 -y
    if [ $? -ne 0 ]; then
        echo -e "\e[31mGerekli paketlerin kurulumu başarısız oldu. Lütfen tekrar deneyin.\e[0m"
        exit 1
    fi
    echo -e "\e[32mGerekli paketler başarıyla kuruldu.\e[0m"

    # Sonaric kurulum scriptini indirme ve çalıştırma
    echo -e "\e[34mSonaric Kurulum Scriptini İndirme ve Çalıştırma\e[0m"
    wget https://raw.githubusercontent.com/Testnetnodes/Sonaric-Network/main/sonaric.sh && chmod +x sonaric.sh && ./sonaric.sh
    if [ $? -ne 0 ]; then
        echo -e "\e[31mSonaric kurulum scripti çalıştırılamadı. Lütfen tekrar deneyin.\e[0m"
        exit 1
    fi
    echo -e "\e[32mSonaric kurulum scripti başarıyla çalıştırıldı.\e[0m"

    # Node'un başarıyla kurulduğunu kontrol etme
    echo -e "\e[34mNode Kurulumunu Kontrol Etme\e[0m"
    sonaric node-info
    if [ $? -ne 0 ];then
        echo -e "\e[31mNode kurulumu kontrolü başarısız oldu. Lütfen tekrar deneyin.\e[0m"
        exit 1
    fi
    echo -e "\e[32mNode kurulumu başarıyla kontrol edildi.\e[0m"

    # GUI çalıştırma
    echo -e "\e[34mGUI'yi Çalıştırma\e[0m"
    IP=$(wget -qO- eth0.me)
    echo -e "\e[33mDevam etmek için lütfen sunucu şifrenizi girin.\e[0m"
    ssh -L 127.0.0.1:44003:127.0.0.1:44003 -L 127.0.0.1:44004:127.0.0.1:44004 -L 127.0.0.1:44005:127.0.0.1:44005 -L 127.0.0.1:44006:127.0.0.1:44006 root@$IP
    if [ $? -ne 0 ]; then
        echo -e "\e[31mGUI çalıştırılamadı. Lütfen tekrar deneyin.\e[0m"
        exit 1
    fi
    echo -e "\e[32mGUI başarıyla çalıştırıldı.\e[0m"

    # Sunucu bilgilerini yedekleme
    echo -e "\e[34mSunucu Bilgilerini Yedekleme\e[0m"
    sonaric identity-export -o mysonaric.identity
    if [ $? -ne 0 ]; then
        echo -e "\e[31mSunucu bilgilerini yedekleme başarısız oldu. Lütfen tekrar deneyin.\e[0m"
        exit 1
    fi
    echo -e "\e[32mSunucu bilgileri başarıyla yedeklendi.\e[0m"

    # Kullanıcıya Moniker ismini değiştirmek isteyip istemediğini sorma
    echo -e "\e[34mMoniker ismini değiştirmek ister misiniz? (y/n)\e[0m"
    read -p "Cevabınız: " change_moniker

    if [ "$change_moniker" == "y" ]; then
        sonaric node-rename
        if [ $? -ne 0 ]; then
            echo -e "\e[31mMoniker ismini değiştirme başarısız oldu. Lütfen tekrar deneyin.\e[0m"
            exit 1
        fi
        echo -e "\e[32mMoniker ismi başarıyla değiştirildi.\e[0m"
    fi

    # Kapanış mesajı
    echo -e "\e[32mEğer herhangi bir sorunla karşılaşırsanız, lütfen benimle iletişime geçin ve beni X üzerinde takip etmeyi unutmayın: https://x.com/brsbtc\e[0m"

elif [ "$user_choice" == "2" ]; then
    # Sunucu bilgilerini yedekleme
    echo -e "\e[34mSunucu Bilgilerini Yedekleme\e[0m"
    sonaric identity-export -o mysonaric.identity
    if [ $? -ne 0 ]; then
        echo -e "\e[31mSunucu bilgilerini yedekleme başarısız oldu. Lütfen tekrar deneyin.\e[0m"
        exit 1
    fi
    echo -e "\e[32mSunucu bilgileri başarıyla yedeklendi.\e[0m"

    # Kullanıcıya Moniker ismini değiştirmek isteyip istemediğini sorma
    echo -e "\e[34mMoniker ismini değiştirmek ister misiniz? (y/n)\e[0m"
    read -p "Cevabınız: " change_moniker

    if [ "$change_moniker" == "y" ]; then
        sonaric node-rename
        if [ $? -ne 0 ]; then
            echo -e "\e[31mMoniker ismini değiştirme başarısız oldu. Lütfen tekrar deneyin.\e[0m"
            exit 1
        fi
        echo -e "\e[32mMoniker ismi başarıyla değiştirildi.\e[0m"
    fi
else
    echo -e "\e[31mGeçersiz seçim. Lütfen 1 veya 2 seçin.\e[0m"
    exit 1
fi
