#!/bin/bash

# Stop and remove specific containers
docker stop $(docker ps -q --filter "name=worker-basic-eth-pred" --filter "name=updater-basic-eth-pred" --filter "name=inference-basic-eth-pred")
docker rm $(docker ps -a -q --filter "name=worker-basic-eth-pred" --filter "name=updater-basic-eth-pred" --filter "name=inference-basic-eth-pred")

# Get container IDs related to Allora
container_ids=$(docker ps -a --filter "ancestor=alloranetwork/allora-inference-base-head" -q)

# Stop and remove each Allora container
for container_id in $container_ids; do
    echo "Stopping Allora container: $container_id"
    docker stop $container_id
    echo "Removing Allora container: $container_id"
    docker rm $container_id
done
