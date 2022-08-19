## Snapshot

```
sudo apt update
sudo apt install lz4 -y
sudo systemctl stop seid
seid tendermint unsafe-reset-all --home $HOME/.sei --keep-addr-book

cd $HOME/.sei
rm -rf data

SNAP_NAME=$(curl -s https://snapshots1-testnet.nodejumper.io/sei-testnet/ | egrep -o ">atlantic-1.*\.tar.lz4" | tr -d ">")
curl https://snapshots1-testnet.nodejumper.io/sei-testnet/${SNAP_NAME} | lz4 -dc - | tar -xf -

sudo systemctl restart seid
sudo journalctl -u seid -f --no-hostname -o cat
```
