#!/usr/bin/env python3
import os
import subprocess
import pexpect

def run_command(command):
    result = subprocess.run(command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, universal_newlines=True)
    if result.returncode != 0:
        print(f"Command '{command}' failed with error:")
        print(result.stderr)
        exit(1)
    else:
        print(result.stdout)

def create_wallet(wallet_name):
    # Expect ile cüzdan oluşturma işlemi
    child = pexpect.spawn(f'allorad keys add {wallet_name}')
    child.expect('Enter keyring passphrase:')
    child.sendline('')
    child.expect('Re-enter keyring passphrase:')
    child.sendline('')
    child.expect(pexpect.EOF)

    print("Cüzdan oluşturma işlemi tamamlandı.")

def main():
    # Sistem güncelleme ve Python kurulumu
    run_command("apt update && apt upgrade -y")
    run_command("sudo apt install python3 python3-pip -y")
    run_command("sudo apt-get install expect -y")

    # Gerekli paketlerin kurulumu
    packages = "ca-certificates curl gnupg lsb-release git htop liblz4-tool screen wget make jq gcc unzip lz4 build-essential pkg-config libssl-dev libreadline-dev libffi-dev zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev -y"
    run_command(f"apt install {packages}")

    # Docker kurulumu
    run_command("curl -fsSL https://get.docker.com -o get-docker.sh")
    run_command("sudo sh get-docker.sh")

    # Docker Compose kurulumu
    run_command("curl -L \"https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)\" -o /usr/local/bin/docker-compose")
    run_command("chmod +x /usr/local/bin/docker-compose")

    # Go dilinin kurulumu
    ver = "1.22.2"
    run_command(f"wget \"https://golang.org/dl/go{ver}.linux-amd64.tar.gz\"")
    run_command("rm -rf /usr/local/go")
    run_command(f"tar -C /usr/local -xzf \"go{ver}.linux-amd64.tar.gz\"")
    run_command(f"rm \"go{ver}.linux-amd64.tar.gz\"")
    run_command('echo \'export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin\' >> $HOME/.bash_profile')
    run_command('source $HOME/.bash_profile')

    # Allora ve cüzdan kurulumu
    run_command("git clone https://github.com/allora-network/allora-chain.git")
    os.chdir("allora-chain")
    run_command("make all")

    # Allora cüzdan oluşturma
    wallet_name = input("Lütfen cüzdan adınızı girin: ")
    create_wallet(wallet_name)

    print("Cüzdanınızı Keplr'e import etmeyi unutmayın.")
    print("Allora ağı eklemek için https://explorer.edgenet.allora.network/wallet/suggest sayfasına gidin.")
    print("Allora kontrol panelini https://app.allora.network üzerinden takip edebilirsiniz.")

    # Allora Worker kurulumu
    os.chdir(os.environ["HOME"])
    run_command("git clone https://github.com/allora-network/basic-coin-prediction-node")
    os.chdir("basic-coin-prediction-node")
    run_command("mkdir worker-data")
    run_command("mkdir head-data")
    run_command("chmod -R 777 worker-data")
    run_command("chmod -R 777 head-data")

    # Head ve Worker key oluşturma
    run_command("docker run -it --entrypoint=bash -v $HOME/basic-coin-prediction-node/head-data:/data alloranetwork/allora-inference-base:latest -c \"mkdir -p /data/keys && (cd /data/keys && allora-keys)\"")
    run_command("docker run -it --entrypoint=bash -v $HOME/basic-coin-prediction-node/worker-data:/data alloranetwork/allora-inference-base:latest -c \"mkdir -p /data/keys && (cd /data/keys && allora-keys)\"")

    # Head key öğrenme
    head_key = run_command("cat $HOME/basic-coin-prediction-node/head-data/keys/identity")
    print(f"Head key: {head_key}")

    # docker-compose.yml dosyasını oluşturma
    docker_compose_content = """
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
          --boot-nodes=/ip4/172.22.0.100/tcp/9010/p2p/{head_key} \
          --topic=allora-topic-1-worker \
          --allora-chain-key-name={wallet_name} \
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
"""
    with open("docker-compose.yml", "w") as f:
        f.write(docker_compose_content)

    # Allora Worker başlatma
    run_command("docker-compose up -d")

    print("Allora Worker başarıyla başlatıldı.")

    # Worker ve Head node'larını kontrol etme
    print("Worker ve Head node'larını kontrol etmek için aşağıdaki komutları kullanabilirsiniz:")
    print("Worker node logs: docker logs -f worker-basic-eth-pred")
    print("Head node logs: docker logs -f head-basic-eth-pred")

    # Allora puanlarını kontrol etme
    print("Allora puanlarınızı https://app.allora.network adresinden kontrol edebilirsiniz.")

if __name__ == "__main__":
    main()
