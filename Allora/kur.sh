#!/bin/bash

# Fonksiyon tanımlayarak komutları çalıştırma
run_command() {
    command="$1"
    echo "Running command: $command"
    echo "###############################################"
    $command
    local exit_status=$?
    echo "###############################################"
    if [ $exit_status -eq 0 ]; then
        echo "Command succeeded: $command"
    else
        echo "Command failed: $command"
        exit 1
    fi
    echo "-----------------------------------------------"
    sleep 2  # 2 saniye bekleme
}

echo "###############################################"
echo "Allora ağı ve cüzdan kurulumu başlıyor..."
echo "###############################################"
echo "-----------------------------------------------"

# Sistem güncelleme ve Python kurulumu
run_command "apt update && apt upgrade -y"
run_command "apt install python3 python3-pip -y"
run_command "apt install expect -y"

# Gerekli paketlerin kurulumu
run_command "apt install ca-certificates curl gnupg lsb-release git htop liblz4-tool screen wget make jq gcc unzip lz4 build-essential pkg-config libssl-dev libreadline-dev libffi-dev zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev -y"

# Docker kurulumu
run_command "curl -fsSL https://get.docker.com -o get-docker.sh"
run_command "sh get-docker.sh"

# Docker Compose kurulumu
run_command 'curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose'
run_command 'chmod +x /usr/local/bin/docker-compose'

# Go dilinin kurulumu
ver="1.22.2"
run_command "wget https://golang.org/dl/go$ver.linux-amd64.tar.gz"
run_command "rm -rf /usr/local/go"
run_command "tar -C /usr/local -xzf go$ver.linux-amd64.tar.gz"
run_command "rm go$ver.linux-amd64.tar.gz"
echo 'export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin' >> $HOME/.bash_profile
. $HOME/.bash_profile  # . (nokta) komutu ile kaynak dosyayı çalıştır

# Allora ve cüzdan kurulumu
run_command "git clone https://github.com/allora-network/allora-chain.git"
run_command "cd allora-chain && make all"

# Allora cüzdan oluşturma ve çıktıyı dosyaya kaydetme
read -p "Lütfen cüzdan adınızı girin: " wallet_name

# Expect ile cüzdan oluşturma işlemi
expect << EOF
spawn allorad keys add $wallet_name
expect "Enter keyring passphrase:"
send "\n"
expect "Re-enter keyring passphrase:"
send "\n"
expect eof
EOF

echo "Cüzdanınızı Keplr'e import etmeyi unutmayın."
echo "Allora ağı eklemek için https://explorer.edgenet.allora.network/wallet/suggest sayfasına gidin."
echo "Allora kontrol panelini https://app.allora.network üzerinden takip edebilirsiniz."

# Allora Worker kurulumu
run_command "cd $HOME"
run_command "git clone https://github.com/allora-network/basic-coin-prediction-node"
run_command "cd basic-coin-prediction-node"

# Worker ve Head veri dosyalarını oluşturma ve izin ayarları
run_command "mkdir worker-data"
run_command "mkdir head-data"
run_command "chmod -R 777 worker-data"
run_command "chmod -R 777 head-data"

# Head ve Worker key oluşturma
run_command 'docker run -it --entrypoint=bash -v $HOME/basic-coin-prediction-node/head-data:/data alloranetwork/allora-inference-base:latest -c "mkdir -p /data/keys && (cd /data/keys && allora-keys)"'
run_command 'docker run -it --entrypoint=bash -v $HOME/basic-coin-prediction-node/worker-data:/data alloranetwork/allora-inference-base:latest -c "mkdir -p /data/keys && (cd /data/keys && allora-keys)"'

# Head key öğrenme
head_key=$(cat $HOME/basic-coin-prediction-node/head-data/keys/identity)
echo "Head key: $head_key"

# docker-compose.yml dosyasını oluşturma
cat << EOF > $HOME/basic-coin-prediction-node/docker-compose.yml
version: '3'

services:
  # Inference ve Updater servisleri buraya eklenecek

  worker:
    container_name: worker-basic-eth-pred
    environment:
      - INFERENCE_API_ADDRESS=http://inference:8000
      - HOME=/data
    build:
      context: .
      dockerfile: Dockerfile_b7s
    entrypoint:
      - "/bin/bash"
      - "-c"
      - |
        if [ ! -f /data/keys/priv.bin ]; then
          echo "Generating new private keys..."
          mkdir -p /data/keys
          cd /data/keys
          allora-keys
        fi
        allora-node --role=worker --peer-db=/data/peerdb --function-db=/data/function-db \
          --runtime-path=/app/runtime --runtime-cli=bls-runtime --workspace=/data/workspace \
          --private-key=/data/keys/priv.bin --log-level=debug --port=9011 \
          --boot-nodes=/ip4/172.22.0.100/tcp/9010/p2p/$head_key \
          --topic=allora-topic-1-worker \
          --allora-chain-key-name=$wallet_name \
          --allora-chain-restore-mnemonic='$MNEMONIC' \
          --allora-node-rpc-address=https://allora-rpc.edgenet.allora.network/ \
          --allora-chain-topic-id=1
    volumes:
      - ./worker-data:/data
    working_dir: /data
    depends_on:
      - inference
      - head

  head:
    container_name: head-basic-eth-pred
    image: alloranetwork/allora-inference-base-head:latest
    environment:
      - HOME=/data
    entrypoint:
      - "/bin/bash"
      - "-c"
      - |
        if [ ! -f /data/keys/priv.bin ]; then
          echo "Generating new private keys..."
          mkdir -p /data/keys
          cd /data/keys
          allora-keys
        fi
        allora-node --role=head --peer-db=/data/peerdb --function-db=/data/function-db  \
          --runtime-path=/app/runtime --runtime-cli=bls-runtime --workspace=/data/workspace \
          --private-key=/data/keys/priv.bin --log-level=debug --port=9010 --rest-api=:6000
    ports:
      - "6000:6000"
    volumes:
      - ./head-data:/data
    working_dir: /data

networks:
  eth-model-local:
    driver: bridge
    ipam:
      config:
        - subnet: 172.22.0.0/24

volumes:
  worker-data:
  head-data:
EOF

# Allora Worker başlatma
run_command "cd $HOME/basic-coin-prediction-node"
run_command "docker-compose up -d"

echo "Allora Worker başarıyla başlatıldı."

# Worker ve Head node'larını kontrol etme
echo "Worker ve Head node'larını kontrol etmek için aşağıdaki komutları kullanabilirsiniz:"
echo "Worker node logs: docker logs -f worker-basic-eth-pred"
echo "Head node logs: docker logs -f head-basic-eth-pred"

# Allora puanlarını kontrol etme
echo "Allora puanlarınızı https://app.allora.network adresinden kontrol edebilirsiniz."

echo "###############################################"
echo "Allora ağı ve cüzdan kurulumu tamamlandı."
echo "###############################################"
