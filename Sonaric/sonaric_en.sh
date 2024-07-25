#!/bin/bash

# Günlük dosyası oluşturma
LOGFILE="/tmp/sonaric_install.log"
exec > >(tee -i $LOGFILE)
exec 2>&1

# açılış
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

echo -e '\e[33mWelcome to the Sonaric Node Installation Guide!\e[0m'
echo -e '\e[0m'

# Sistem Gereksinimleri
echo -e '\e[34mRequired System Hardware\e[0m'
echo -e '\e[34m| Components   | Minimum Requirements |\e[0m'
echo -e '\e[34m|--------------|-----------------------|\e[0m'
echo -e '\e[34m| CPU          | 2+                    |\e[0m'
echo -e '\e[34m| RAM          | 4+ GB                 |\e[0m'
echo -e '\e[34m| Storage      | 20 GB SSD             |\e[0m'
echo -e '\e[34m| Operating System | Ubuntu 22            |\e[0m'
echo -e '\e[0m'

# Sistem güncellemesi ve gerekli paketlerin kurulumu
echo -e '\e[34mSystem Update and Package Installation\e[0m'
sudo apt update && sudo apt upgrade -y
if [ $? -ne 0 ]; then
    echo -e '\e[31mSystem update failed. Please try again.\e[0m'
    exit 1
fi
echo -e '\e[32mSystem update completed successfully.\e[0m'

sudo apt install curl git jq build-essential gcc unzip wget lz4 -y
if [ $? -ne 0 ]; then
    echo -e '\e[31mRequired package installation failed. Please try again.\e[0m'
    exit 1
fi
echo -e '\e[32mRequired packages installed successfully.\e[0m'

# Sonaric kurulum scriptini indirme ve çalıştırma
echo -e '\e[34mDownloading and Running Sonaric Installation Script\e[0m'
wget https://raw.githubusercontent.com/Testnetnodes/Sonaric-Network/main/sonaric.sh && chmod +x sonaric.sh && ./sonaric.sh
if [ $? -ne 0 ]; then
    echo -e '\e[31mSonaric installation script execution failed. Please try again.\e[0m'
    exit 1
fi
echo -e '\e[32mSonaric installation script executed successfully.\e[0m'

# Node'un başarıyla kurulduğunu kontrol etme
echo -e '\e[34mChecking Node Installation\e[0m'
sonaric node-info
if [ $? -ne 0 ]; then
    echo -e '\e[31mNode installation check failed. Please try again.\e[0m'
    exit 1
fi
echo -e '\e[32mNode installation checked successfully.\e[0m'

# GUI çalıştırma
echo -e '\e[34mRunning the GUI\e[0m'
IP=$(wget -qO- eth0.me)
echo -e '\e[33mPlease enter your server password to proceed.\e[0m'
ssh -L 127.0.0.1:44003:127.0.0.1:44003 -L 127.0.0.1:44004:127.0.0.1:44004 -L 127.0.0.1:44005:127.0.0.1:44005 -L 127.0.0.1:44006:127.0.0.1:44006 root@$IP
if [ $? -ne 0 ]; then
    echo -e '\e[31mRunning the GUI failed. Please try again.\e[0m'
    exit 1
fi
echo -e '\e[32mGUI ran successfully.\e[0m'

# Sunucu bilgilerini yedekleme
echo -e '\e[34mBacking Up Server Information\e[0m'
sonaric identity-export -o mysonaric.identity
if [ $? -ne 0 ]; then
    echo -e '\e[31mBacking up server information failed. Please try again.\e[0m'
    exit 1
fi
echo -e '\e[32mServer information backed up successfully.\e[0m'

# Kullanıcıya Moniker ismini değiştirmek isteyip istemediğini sorma
echo -e '\e[34mDo you want to change the Moniker name? (y/n)\e[0m'
read -p "Your answer: " change_moniker

if [ "$change_moniker" == "y" ]; then
    sonaric node-rename
    if [ $? -ne 0 ]; then
        echo -e '\e[31mChanging the Moniker name failed. Please try again.\e[0m'
        exit 1
    fi
    echo -e '\e[32mMoniker name changed successfully.\e[0m'
fi

# Kapanış mesajı
echo -e '\e[32mIf you encounter any issues, please contact me for support and don\'t forget to follow me on X: https://x.com/brsbtc\e[0m'
