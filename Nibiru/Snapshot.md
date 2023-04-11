# Snapshot (Block -- 1,814,895)
```
sudo systemctl stop nibid

cp $HOME/.nibid/data/priv_validator_state.json $HOME/.nibid/priv_validator_state.json.backup 

nibid tendermint unsafe-reset-all --home $HOME/.nibid --keep-addr-book 
curl https://snapshots2-testnet.nodejumper.io/nibiru-testnet/nibiru-itn-1_2023-04-11.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.nibid

mv $HOME/.nibid/priv_validator_state.json.backup $HOME/.nibid/data/priv_validator_state.json 

sudo systemctl restart nibid
sudo journalctl -u nibid -f --no-hostname -o cat
```
