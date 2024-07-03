#!/bin/bash

# Get container IDs related to Allora
container_ids=$(docker ps -a --filter "ancestor=alloranetwork/allora-inference-base-head" -q)

# Stop and remove each container
for container_id in $container_ids; do
    echo "Stopping container: $container_id"
    docker stop $container_id
    echo "Removing container: $container_id"
    docker rm $container_id
done
