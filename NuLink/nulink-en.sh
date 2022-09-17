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
wget https://gethstore.blob.core.windows.net/builds/geth-linux-amd64-1.10.24-972007a5.tar.gz
tar -xvzf geth-linux-amd64-1.10.24-972007a5.tar.gz
cd geth-linux-amd64-1.10.24-972007a5/
./geth account new --keystore ./keystore

sleep 13

# Assignment of the Variable
if [ ! $KEY ]; then
	read -p "Type the directory path of the secret key file : " KEY
	echo 'export KEY='$KEY >> $HOME/.bash_profile
fi

sleep 2

if [ ! $PKEY ]; then
	read -p "Write your public address: " PKEY
	echo 'export PKEY='$PKEY >> $HOME/.bash_profile
fi

sleep 2

if [ ! $UTC ]; then
	read -p "Write the secret key from the part of your file starting with UTC: " UTC
	echo 'export UTC='$UTC >> $HOME/.bash_profile
fi

sleep 2

if [ ! $SFR ]; then
	read -p "create a password of 8 characters: " SFR
	echo 'export SFR='$SFR >> $HOME/.bash_profile
fi

sleep 3

echo -e "\e[1m\e[32m3. Installing Docker... \e[0m" && sleep 2
# Docker İnstall
cd /root
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update && sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y </dev/null
sudo chmod 666 /var/run/docker.sock
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
-e $SFR \
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
-e SFR \
-e SFR \
nulink/nulink nulink ursula run --no-block-until-ready

sleep 4

echo '------------------- The Installation was Completed Successfully. good luck... -------------------'
echo '------------------- If you have any questions, you can contact me. Discord id: blackowl#7099... -------------------'
