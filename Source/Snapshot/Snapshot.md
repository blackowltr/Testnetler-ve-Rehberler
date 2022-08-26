## Snapshot

### Blok Yüksekliği --> 1847709

```
sudo systemctl stop sourced
sourced unsafe-reset-all
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.source/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.source/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.source/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.source/config/app.toml
wget -O $HOME/.source/config/addrbook.json "https://raw.githubusercontent.com/StakeTake/guidecosmos/main/source/sourcechain-testnet/addrbook.json"
cd
rm -rf ~/.source/data; \
wget -O - http://snap.stake-take.com:8000/source.tar.gz | tar xf -
mv $HOME/root/.source/data $HOME/.source
rm -rf $HOME/root
sudo systemctl restart sourced && journalctl -u sourced -f -o cat
```

### Kolay Gelsin..
