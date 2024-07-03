#!/bin/bash

# Stop and remove specific containers if they exist
if docker ps -q --filter "name=worker-basic-eth-pred" --filter "name=updater-basic-eth-pred" --filter "name=inference-basic-eth-pred" 2>/dev/null; then
    echo -e "\e[32mStopping and removing specified containers...\e[0m"
    docker stop $(docker ps -q --filter "name=worker-basic-eth-pred" --filter "name=updater-basic-eth-pred" --filter "name=inference-basic-eth-pred")
    docker rm $(docker ps -a -q --filter "name=worker-basic-eth-pred" --filter "name=updater-basic-eth-pred" --filter "name=inference-basic-eth-pred")
else
    echo -e "\e[32mİlgili container  bulunamadı. Tüm containerlar zaten durduruldu ve ardından kaldırıldı.\e[0m"
fi

# Get container IDs related to Allora
container_ids=$(docker ps -a --filter "ancestor=alloranetwork/allora-inference-base-head" -q)

# Stop and remove each Allora container if they exist
for container_id in $container_ids; do
    echo "Stopping Allora container: $container_id"
    docker stop $container_id
    echo "Removing Allora container: $container_id"
    docker rm $container_id
done
