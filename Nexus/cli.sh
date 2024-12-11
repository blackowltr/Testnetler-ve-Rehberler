#!/bin/sh

# Rust kurulumunu kontrol et
rustc --version || curl https://sh.rustup.rs -sSf | sh

NEXUS_HOME=$HOME/.nexus
GREEN='\033[1;32m'
ORANGE='\033[1;33m'
NC='\033[0m' # No Color

# Kullanıcıdan Nexus Beta Terms of Use sorusu
while [ -z "$NONINTERACTIVE" ] && [ ! -f "$NEXUS_HOME/prover-id" ]; do
    read -p "Do you agree to the Nexus Beta Terms of Use (https://nexus.xyz/terms-of-use)? (Y/n) " yn </dev/tty
    case $yn in
        [Nn]* ) exit;;
        [Yy]* ) break;;
        "" ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done

# Git kontrolü yap
git --version 2>&1 >/dev/null
GIT_IS_AVAILABLE=$?
if [ $GIT_IS_AVAILABLE != 0 ]; then
  echo "Unable to find git. Please install it and try again."
  exit 1
fi

# Kullanıcıdan Prover ID'sini al ve kaydet
if [ ! -f "$NEXUS_HOME/prover-id" ]; then
    echo "\nTo receive credit for proving in Nexus testnets..."
    echo "\t1. Go to ${GREEN}https://beta.nexus.xyz${NC}"
    echo "\t2. On the bottom left-hand corner, copy the ${ORANGE}prover id${NC}"
    echo "\t3. Paste the ${ORANGE}prover id${NC} here.\n"

    read -p "Prover ID'nizi yazın: " PROVER_ID </dev/tty

    while [ ! -z "$PROVER_ID" ]; do
        if [ ${#PROVER_ID} -eq 28 ]; then
            # Gerekirse dizini oluştur
            mkdir -p "$NEXUS_HOME"

            # Eski dosyayı yedekle
            if [ -f "$NEXUS_HOME/prover-id" ]; then
                echo "Backing up existing Prover ID to $NEXUS_HOME/prover-id.bak"
                cp "$NEXUS_HOME/prover-id" "$NEXUS_HOME/prover-id.bak"
            fi

            # Yeni Prover ID'yi yaz
            echo "$PROVER_ID" > "$NEXUS_HOME/prover-id"
            echo "Prover ID saved to $NEXUS_HOME/prover-id."
            break
        else
            echo "Invalid Prover ID. Please ensure it is 28 characters long."
        fi
        read -p "Enter your Prover ID again: " PROVER_ID </dev/tty
    done
fi

# Nexus API repository kontrolü ve güncelleme
REPO_PATH=$NEXUS_HOME/network-api

if [ -d "$REPO_PATH" ]; then
  echo "$REPO_PATH exists. Updating."
  (cd $REPO_PATH && git stash save && git fetch --tags)
else
  mkdir -p $NEXUS_HOME
  (cd $NEXUS_HOME && git clone https://github.com/nexus-xyz/network-api)
fi

# Repository checkout işlemi
(cd $REPO_PATH && git -c advice.detachedHead=false checkout $(git rev-list --tags --max-count=1))

# CLI kullanarak prover çalıştır
(cd $REPO_PATH/clients/cli && cargo run --release --bin prover -- beta.orchestrator.nexus.xyz)
