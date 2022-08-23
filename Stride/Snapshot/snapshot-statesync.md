# Stride Snapshot ile kurulum (Stride-Chain-4)

## Kurulu değilse, kurulumumuzu sağlayalım
```
wget -O stride.sh https://raw.githubusercontent.com/brsbrc/Testnetler-ve-Rehberler/main/Stride/stride.sh && chmod +x stride.sh && ./stride.sh
```

## Snapshot, Blok Yüksekliği --> 68780
```
sudo systemctl stop strided
strided tendermint unsafe-reset-all --home $HOME/.stride --keep-addr-book
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.stride/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.stride/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.stride/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.stride/config/app.toml
cd
rm -rf ~/.stride/data; \
wget -O - http://snap.stake-take.com:8000/stride.tar.gz | tar xf -
mv $HOME/root/.stride/data $HOME/.stride
rm -rf $HOME/root
sudo systemctl restart strided && journalctl -u strided -f -o cat
```

## State Sync 
```
sudo systemctl stop strided
strided tendermint unsafe-reset-all --home $HOME/.stride
SEEDS=""
PEERS="6d3d7df642fd0cdf0c4b74c499cf4d5937a29d2b@23.88.100.175:26656,bf1414a4cbcfcc6c6fc11d1229f5cefcce1faef5@stride-node1.poolparty.stridenet.co:26656"; \
sed -i.bak -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.stride/config/config.toml
SNAP_RPC="http://stride.stake-take.com:26657"
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)
echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"| ; \
s|^(seeds[[:space:]]+=[[:space:]]+).*$|\1\"\"|" $HOME/.stride/config/config.toml
wget -O $HOME/.stride/config/addrbook.json "https://raw.githubusercontent.com/StakeTake/guidecosmos/main/stride/STRIDE-TESTNET-4/addrbook.json"
sudo systemctl restart strided && journalctl -u strided -f -o cat
```

## Addrbook eklemek için
```
sudo systemctl stop strided
rm $HOME/.stride/config/addrbook.json
wget -O $HOME/.stride/config/addrbook.json "https://raw.githubusercontent.com/StakeTake/guidecosmos/main/stride/STRIDE-TESTNET-4/addrbook.json"
sudo systemctl restart strided && journalctl -u strided -f -o cat
```

### Hepinize Kolay Gelsin..
