# Allora Price Prediction Worker Node Kurulumu

## Sistemi Güncelleme, Python Kurulumu ve Gerekli Kütüphanelerin Kurulması
```shell
apt update && apt upgrade -y
sudo apt install python3 && sudo apt install python3-pip
apt install ca-certificates curl gnupg lsb-release git htop liblz4-tool screen wget make jq gcc unzip lz4 build-essential pkg-config libssl-dev libreadline-dev libffi-dev zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev -y < "/dev/null"
```

## Docker Kurulumu
```shell
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
```

## Docker Compose Kurulumu
```shell
curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
```

### Go Kuralım
```
ver="1.22.2" && \
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz" && \
rm -rf /usr/local/go && \
tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz" && \
rm "go$ver.linux-amd64.tar.gz" && \
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> $HOME/.bash_profile && \
source $HOME/.bash_profile
```

## Allora ve Cüzdan Kurulumu
```shell
git clone https://github.com/allora-network/allora-chain.git
cd allora-chain && make all
```

### Allora Cüzdan Kurulumu
```shell
allorad keys add CUZDAN_ADI
```

> Ardından cüzdanınızı Keplr'e import edin. 

### Allora Ağını Ekleme
Allora [explorer](https://explorer.edgenet.allora.network/wallet/suggest) sayfasına gidip ağı ekleyin.

### Allora Kontrol Paneli

Allora [kontrol paneli](https://app.allora.network)'nde puanlarımızı takip edeceğiz.

### Musluk
Allora cüzdanımıza [musluk](https://faucet.edgenet.allora.network/)'tan token istiyoruz.

### Allora Worker Kurulumu

```shell
cd $HOME
git clone https://github.com/allora-network/basic-coin-prediction-node
```

### Data Dosyalarını Oluşturma
```shell
cd basic-coin-prediction-node
mkdir worker-data
mkdir head-data
```

### Data Dosya İzinlerini Ayarlama
```shell
chmod -R 777 worker-data
chmod -R 777 head-data
```

### Head Key Oluşturma
```shell
docker run -it --entrypoint=bash -v ./head-data:/data alloranetwork/allora-inference-base:latest -c "mkdir -p /data/keys && (cd /data/keys && allora-keys)"
```

### Worker Key Oluşturma
```shell
docker run -it --entrypoint=bash -v ./worker-data:/data alloranetwork/allora-inference-base:latest -c "mkdir -p /data/keys && (cd /data/keys && allora-keys)"
```

### Head Key Öğrenme
```shell
cat head-data/keys/identity
```
> Keyi kaydedin, aşağıdaki bölümlerde lazım olacak.

### docker-compose.yml Dosyasını Hazırlama 


#### Var Olan Dosyayı Silme
```shell
rm docker-compose.yml
```
#### Yeni Dosyayı Hazırlama
> Aşağıdaki varsayılan olarak kullanılacak portlar yazılmıştır. Eğer bu portlar sunucusunuzda kullanılıyorsa bunları değiştirin.
> `MNEMONIC` bölümüne cüzdan kelimelerini,
> `CUZDAN_ADI` bölümüne cüzdan adınızı,
> `HEAD_ID` bölümüne ise yukarıda alınan head key kodunu yazın. Ardından kodu çalıştırın. 

```shell
PY_PORT="8000"
W_PORT1="9011"
W_PORT2="9010"
REST_PORT="6000"
MNEMONIC=""
HEAD_ID=""
CUZDAN_ADI=""
```

> Şimdi yeni dosyamızı oluşturuyoruz aşağıdaki kodu olduğu gibi çalıştırı.
```shell
tee $HOME/basic-coin-prediction-node/docker-compose.yml > /dev/null << EOF
version: '3'

services:
  inference:
    container_name: inference-basic-eth-pred
    build:
      context: .
    command: python -u /app/app.py
    ports:
      - "$PY_PORT:$PY_PORT"
    networks:
      eth-model-local:
        aliases:
          - inference
        ipv4_address: 172.22.0.4
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:$PY_PORT/inference/ETH"]
      interval: 10s
      timeout: 10s
      retries: 12
    volumes:
      - ./inference-data:/app/data

  updater:
    container_name: updater-basic-eth-pred
    build: .
    environment:
      - INFERENCE_API_ADDRESS=http://inference:$PY_PORT
    command: >
      sh -c "
      while true; do
        python -u /app/update_app.py;
        sleep 24h;
      done
      "
    depends_on:
      inference:
        condition: service_healthy
    networks:
      eth-model-local:
        aliases:
          - updater
        ipv4_address: 172.22.0.5

  worker:
    container_name: worker-basic-eth-pred
    environment:
      - INFERENCE_API_ADDRESS=http://inference:$PY_PORT
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
        # Change boot-nodes below to the key advertised by your head
        allora-node --role=worker --peer-db=/data/peerdb --function-db=/data/function-db \
          --runtime-path=/app/runtime --runtime-cli=bls-runtime --workspace=/data/workspace \
          --private-key=/data/keys/priv.bin --log-level=debug --port=$W_PORT1 \
          --boot-nodes=/ip4/172.22.0.100/tcp/$W_PORT2/p2p/$HEAD_ID \
          --topic=allora-topic-1-worker \
          --allora-chain-key-name=$CUZDAN_ADI \
          --allora-chain-restore-mnemonic='$MNEMONIC' \
          --allora-node-rpc-address=https://allora-rpc.edgenet.allora.network/ \
          --allora-chain-topic-id=1
    volumes:
      - ./worker-data:/data
    working_dir: /data
    depends_on:
      - inference
      - head
    networks:
      eth-model-local:
        aliases:
          - worker
        ipv4_address: 172.22.0.10

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
          --private-key=/data/keys/priv.bin --log-level=debug --port=$W_PORT2 --rest-api=:$REST_PORT
    ports:
      - "$REST_PORT:$REST_PORT"
    volumes:
      - ./head-data:/data
    working_dir: /data
    networks:
      eth-model-local:
        aliases:
          - head
        ipv4_address: 172.22.0.100


networks:
  eth-model-local:
    driver: bridge
    ipam:
      config:
        - subnet: 172.22.0.0/24

volumes:
  inference-data:
  worker-data:
  head-data:
EOF
````

## Allora Worker Başlatma

```shell
cd $HOME/basic-coin-prediction-node
docker compose build
docker compose up -d
```

🚨 Ben başlatınca aşağıdaki hatayı aldım. Yukarıdaki docker-compose.yml dosyasın düzenlemesinde portlarla ilişkili mi anlayamadım.
![image](https://github.com/koltigin/Allora-Price-Prediction-Worker-Node/assets/102043225/bc7469e3-8cad-445d-8519-f94862f78bdf)

### Node Kontrolü

Allora docker konteynır (`basic-coin-prediction-node`) id'sini almak için aşağıdaki kodu girin.  
```shell
docker ps
```

Aşağıdaki kodda `C_ID` bölümüne id yazıp çalıştıralım.
```shell
docker logs -f C_ID
```

Aşağıdaki gibi bir çıktı alamnız gerekiyor.
```shell
.
.
Succes: register node TX Hash:
.
.
```

## Allora Puanları

[Allora Points](https://app.allora.network?ref=eyJyZWZlcnJlcl9pZCI6IjBlNWRhMjlmLTc3YjItNDQ2NS1hYTcxLTk0NWI3NjRhMTA0ZiJ9) sayfasına gidip cüzdanınızı bağlayıp puanlarınızı kontrol edebilirsiniz.
