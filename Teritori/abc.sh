

#!/bin/bash

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

sleep 2

echo -e "\e[1m\e[32m1. Downloading Libraries.. \e[0m" && sleep 2
# update and upgrade
sudo apt-get update && apt-get upgrade -y
sudo apt-get -y install libssl-dev && apt-get -y install cmake build-essential git wget jq make gcc

echo -e "\e[1m\e[32m2. Creating a Worker Account... \e[0m" && sleep 2
# Account Creation
wget "https://gethstore.blob.core.windows.net/builds/geth-linux-amd64-1.10.24-972007a5.tar.gz"
tar -xvzf geth-linux-amd64-1.10.24-972007a5.tar.gz
cd $HOME/geth-linux-amd64-1.10.24-972007a5/
./geth account new --keystore ./keystore

sleep 13

source $HOME/.bash_profile


UTC="$(ls /root/geth-linux-amd64-1.10.24-972007a5/keystore/)"
#echo $UTC
PKEY="0x""$(awk -F \" '{print $4}' /root/geth-linux-amd64-1.10.24-972007a5/keystore/$UTC)" 
#echo $PKEY
KEY="/root/geth-linux-amd64-1.10.24-972007a5/keystore/"$UTC
#echo $KEY

sleep 2

if [ ! $NULINK_KEYSTORE_PASSWORD ]; then
	read -p "Enter your Nulink Keystore Password: " NULINK_KEYSTORE_PASSWORD
	echo "export NULINK_KEYSTORE_PASSWORD="$NULINK_KEYSTORE_PASSWORD >> $HOME/.bash_profile
fi

if [ ! $NULINK_OPERATOR_ETH_PASSWORD ]; then
        read -p "Enter your ETH operator password(can be same as before): " NULINK_OPERATOR_ETH_PASSWORD
        echo "export NULINK_OPERATOR_ETH_PASSWORD="$NULINK_OPERATOR_ETH_PASSWORD >> $HOME/.bash_profile
fi

echo -e "Your public address: \e[1m\e[32m$PKEY\e[0m"
echo -e "Your path to secret key file: \e[1m\e[32m$KEY\e[0m"
echo -e "Your Nulink Keystore Password: \e[1m\e[32m$NULINK_KEYSTORE_PASSWORD\e[0m"
echo -e "Your Nulink ETH Operator Password: \e[1m\e[32m$NULINK_KEYSTORE_PASSWORD\e[0m"

sleep 3

echo -e "\e[1m\e[32m3. Installing Docker... \e[0m" && sleep 2
# Docker İnstall
cd /root
sudo apt install docker.io -y
sudo systemctl enable --now docker

sleep 2

echo -e "\e[1m\e[32m4. Taking the latest NuLink image... \e[0m" && sleep 2
docker pull nulink/nulink:latest

sleep 2

# Creating a File
cd /root
mkdir nulink

sleep 2

# Adding a secret keye
cp $KEY /root/nulink
chmod -R 777 /root/nulink

sleep 3

echo -e "\e[1m\e[32m4. Initializing Node Configuration... \e[0m" && sleep 2
# Initialize Node Configuration
docker run -it --rm \
-p 9151:9151 \
-v /root/nulink:/code \
-v /root/nulink:/home/circleci/.local/share/nulink \
-e NULINK_KEYSTORE_PASSWORD \
nulink/nulink nulink ursula init \
--signer keystore:///code/$UTC \
--eth-provider https://data-seed-prebsc-2-s2.binance.org:8545  \
--network horus \
--payment-provider https://data-seed-prebsc-2-s2.binance.org:8545 \
--payment-network bsc_testnet \
--operator-address $PKEY \
--max-gas-price 100

sleep 12

# Starting a Node
docker run --restart on-failure -d \
--name ursula \
-p 9152:9152 \
-v /root/nulink:/code \
-v /root/nulink:/home/circleci/.local/share/nulink \
-e NULINK_KEYSTORE_PASSWORD \
-e NULINK_OPERATOR_ETH_PASSWORD \
nulink/nulink nulink ursula run --no-block-until-ready

sleep 4

echo '----The Installation was Completed Successfully. Good luck... ----'
echo '---- If you have any questions, you can contact me. Discord id: blackowl#7099... ----'




