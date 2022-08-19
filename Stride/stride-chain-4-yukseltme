# Stride Yükseltme - STRIDE-TESTNET-4

> Halihazırda stride kuruluysa sunucunuzda buradaki adımları takip ederek yeni chaine yani chain-4'e geçebilirsiniz.

## Binary Dosyamızı İndirelim
```
sudo systemctl stop strided
cd $HOME && rm -rf stride
git clone https://github.com/Stride-Labs/stride.git
cd stride
git checkout cf4e7f2d4ffe2002997428dbb1c530614b85df1b
make build
sudo cp $HOME/stride/build/strided /usr/local/bin
```

## Genesis Güncellememizi Yapıyoruz
```
wget -qO $HOME/.stride/config/genesis.json "https://raw.githubusercontent.com/Stride-Labs/testnet/main/poolparty/genesis.json"
```

## Seed/Peer Güncellememizi Yapıyoruz
```
SEEDS="d2ec8f968e7977311965c1dbef21647369327a29@seedv2.poolparty.stridenet.co:26656"
PEERS="2771ec2eeac9224058d8075b21ad045711fe0ef0@34.135.129.186:26656,a3afae256ad780f873f85a0c377da5c8e9c28cb2@54.219.207.30:26656,328d459d21f82c759dda88b97ad56835c949d433@78.47.222.208:26639,bf57701e5e8a19c40a5135405d6757e5f0f9e6a3@143.244.186.222:16656,f93ce5616f45d6c20d061302519a5c2420e3475d@135.125.5.31:54356"
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.stride/config/config.toml
```

## Stride Config Dosyamızda Güncellemeler Yapıyoruz
```
sed -i '/STRIDE_CHAIN_ID/d' ~/.bash_profile
echo "export STRIDE_CHAIN_ID=STRIDE-TESTNET-4" >> $HOME/.bash_profile
source $HOME/.bash_profile
strided config chain-id $STRIDE_CHAIN_ID
```

## Zincir Sıfırlama İşlemini Yapıyoruz.
```
sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1false|" $HOME/.stride/config/config.toml
strided tendermint unsafe-reset-all --home $HOME/.stride
```

## Servisi Başlatıyoruz
```
sudo systemctl start strided && journalctl -fu strided -o cat
```

## Cüzdan Bakiyesi Kontrol Etmek İçin
```
strided query bank balances $STRIDE_WALLET_ADDRESS
```

## Validator Oluşturmak İçin
```
strided tx staking create-validator \
  --amount 9900000ustrd \
  --from cüzdanisminiz \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(strided tendermint show-validator) \
  --moniker nodeisminiz \
  --chain-id=STRIDE-TESTNET-4 
```

## Kendi Validatorumuze Delege Etme Komutu
```
strided tx staking delegate stridevaloperadresimiz <AMOUNT>ustrd --from=Cüzdanismi --chain-id=STRIDE-TESTNET-4 --gas=auto
```

### Herkese Kolay Gelsin..
