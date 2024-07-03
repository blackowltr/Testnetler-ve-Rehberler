#!/bin/bash

# Container ID'sini bul
container_id=$(docker ps | grep basic-coin-prediction-node-worker | awk '{print $1}')

if [ -z "$container_id" ]; then
  echo "Error: Container 'basic-coin-prediction-node-worker' not found."
  exit 1
fi

# Logları takip et
docker logs -f "$container_id"
