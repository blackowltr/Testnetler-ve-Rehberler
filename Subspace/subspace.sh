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

# set vars
if [ ! $NN ]; then
	read -p "Node İsminizi Girin: " NN
	echo 'export NN='$NN >> $HOME/.bash_profile
fi

if [ ! $WA ]; then
	read -p "Ödül almak istediğiniz cüzdan adresinizi yazın: " WA
	echo "export WA="$WA >> $HOME/.bash_profile
fi

sleep 2

PS='100G'

source $HOME/.bash_profile

echo '================================================='
echo -e "Node İsminiz: \e[1m\e[32m$NN\e[0m"
echo -e "Cüzdan Adresiniz: \e[1m\e[32m$WA\e[0m"
echo -e "PlotSize: \e[1m\e[32m$PS\e[0m"
echo '================================================='

sleep 2

echo -e "\e[1m\e[32m1. Makine Güncelleniyor... \e[0m" && sleep 1
# update
sudo apt update && sudo apt upgrade -y

sleep 2

echo -e "\e[1m\e[32m2. Kütüphaneler Yükleniyor... \e[0m" && sleep 1
# packages
sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential bsdmainutils git make ncdu gcc git jq chrony unzip liblz4-tool -y

sleep 2

echo -e "\e[1m\e[32m3. Supspace Node ve Farmer Binary Dosyasaları İndiriliyor... \e[0m" && sleep 1
cd $HOME
wget -qO subspace-node-ubuntu-x86_64-gemini-2a-2022-sep-10 https://github.com/subspace/subspace/releases/download/gemini-2a-2022-sep-10/subspace-node-ubuntu-x86_64-gemini-2a-2022-sep-10
wget -qO subspace-farmer-ubuntu-x86_64-gemini-2a-2022-sep-10 https://github.com/subspace/subspace/releases/download/gemini-2a-2022-sep-10/subspace-farmer-ubuntu-x86_64-gemini-2a-2022-sep-10

sleep 2

#Binary Dosyalarımıza Execute Yetkisi veriliyor
sudo chmod +x subspace-node-ubuntu-x86_64-gemini-2a-2022-sep-10
sudo chmod +x subspace-farmer-ubuntu-x86_64-gemini-2a-2022-sep-10

sleep 2

#Binary Dosyaları /usr/local/bin Altına Taşınıyor
sudo mv subspace-node-ubuntu-x86_64-gemini-2a-2022-sep-10 /usr/local/bin/subspaceNode
sudo mv subspace-farmer-ubuntu-x86_64-gemini-2a-2022-sep-10 /usr/local/bin/subspaceFarmer

sleep 2

echo -e "\e[1m\e[32m4. Servis Başlatılıyor... \e[0m" && sleep 1
#Servis Dosyası
sudo tee <<EOF >/dev/null /etc/systemd/system/subspaced.service
[Unit]
Description=SubsapeNode Node
After=network.target

[Service]
User=$USER
ExecStart=$(which subspaceNode) --chain gemini-2a --execution wasm --state-pruning archive --validator --name $NN
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF

#Başlatma komutları
sudo systemctl daemon-reload
sudo systemctl enable subspaced
sudo systemctl restart subspaced

sleep 2

#Farmer için farmerd isimli bir servis oluşturma
sudo tee <<EOF >/dev/null /etc/systemd/system/farmerd.service
[Unit]
Description=Supsapce Node
After=network.target

[Service]
User=$USER
ExecStart=$(which subspaceFarmer) farm --reward-address $WA --plot-size ${PS}
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF

#Başlatma
sudo systemctl daemon-reload
sudo systemctl enable farmerd
sudo systemctl restart farmerd

echo '=============== Kurulum, Başarıyla Tamamlandı. ==================='
echo -e 'Log Kontrol: \e[1m\e[32m  journalctl -u subspaced -f -o cat  \e[0m'
echo -e "Sync Durumu: \e[1m\e[32m  curl -H "Content-Type: application/json" -d '{"id":1, "jsonrpc":"2.0", "method": "system_health", "params":[]}' http://localhost:9933  \e[0m"
