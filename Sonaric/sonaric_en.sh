#!/bin/bash

# Colorful and highlighted opening message
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

# System Requirements
echo -e '\e[34mRequired System Hardware\e[0m'
echo -e '\e[34m| Components   | Minimum Requirements |\e[0m'
echo -e '\e[34m|--------------|-----------------------|\e[0m'
echo -e '\e[34m| CPU          | 2+                    |\e[0m'
echo -e '\e[34m| RAM          | 4+ GB                 |\e[0m'
echo -e '\e[34m| Storage      | 20 GB SSD             |\e[0m'
echo -e '\e[34m| Operating System | Ubuntu 22            |\e[0m'
echo -e '\e[0m'

# System update and required package installation
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

# Download required files
echo -e '\e[34mDownloading Required Files\e[0m'
wget https://raw.githubusercontent.com/Testnetnodes/Sonaric-Network/main/sonaric.sh && chmod +x sonaric.sh && ./sonaric.sh
if [ $? -ne 0 ]; then
    echo -e '\e[31mFile download failed. Please try again.\e[0m'
    exit 1
fi
echo -e '\e[32mRequired files downloaded successfully.\e[0m'

# Check if the node is successfully installed
echo -e '\e[34mChecking Node Installation\e[0m'
sonaric node-info
if [ $? -ne 0 ]; then
    echo -e '\e[31mNode installation check failed. Please try again.\e[0m'
    exit 1
fi
echo -e '\e[32mNode installation checked successfully.\e[0m'

# Run the GUI
echo -e '\e[34mRunning the GUI\e[0m'
IP=$(wget -qO- eth0.me)
ssh -L 127.0.0.1:44003:127.0.0.1:44003 -L 127.0.0.1:44004:127.0.0.1:44004 -L 127.0.0.1:44005:127.0.0.1:44005 -L 127.0.0.1:44006:127.0.0.1:44006 root@$IP
if [ $? -ne 0 ]; then
    echo -e '\e[31mRunning the GUI failed. Please try again.\e[0m'
    exit 1
fi
echo -e '\e[32mGUI ran successfully.\e[0m'

# Backup server information
echo -e '\e[34mBacking Up Server Information\e[0m'
sonaric identity-export -o mysonaric.identity
if [ $? -ne 0 ]; then
    echo -e '\e[31mBacking up server information failed. Please try again.\e[0m'
    exit 1
fi
echo -e '\e[32mServer information backed up successfully.\e[0m'

# Ask the user if they want to change the Moniker name
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

# Closing message
echo -e '\e[32mIf you encounter any issues, please contact me for support and don't forget to follow me on X: https://x.com/brsbtc\e[0m'
