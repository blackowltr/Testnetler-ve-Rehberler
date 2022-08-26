# Quicksilver Testnet

![qq](https://user-images.githubusercontent.com/107190154/185763787-fd8a0cdf-af74-42d0-a6d5-dd415be82c31.png)

## Sistem Gereksinimleri

|     RAM     |       Cpu      |      Disk      |
|-------------|----------------|----------------|
|     8GB     |    4x CPUs     |     300GB      |

## Kuruluma Geçelim.a

## root kullanıcı oluyoruz:
```
sudo su
```

## root dizini altına gidiyoruz
```
cd /root
```

## Scriptimizi çalıştırıp kuruyoruz:
```
wget -q -O quicksilver.sh https://raw.githubusercontent.com/brsbrc/Testnetler-ve-Rehberler/main/Quicksilver/quicksilver.sh && chmod +x quicksilver.sh && sudo /bin/bash quicksilver.sh
```

## Peer ekliyoruz:
```
PEERS="b281289df37c5180f9ff278be5e29964afa0c229@185.56.139.84:26656,4f35ab6008fc46cc50b103a337ec2266400eca2e@148.251.50.79:26656,90f4459126152d21983f42c8e86bc899cd618af6@116.202.15.183:11656,6ac91620bc5338e6f679835cc604769a213d362f@139.59.56.24:36366,f9d2dbf6c80f08d12d1bc8d07ffd3bafa4965160@95.214.55.43:26651,abe7397ff92a4ca61033ceac127b5fc3a9a4217f@65.108.98.218:25095,07bb0fd7af9dc819bb5bb850ea5d870281c3adfa@167.235.74.230:26656"
SEEDS="dd3460ec11f78b4a7c4336f22a356fe00805ab64@seed.killerqueen-1.quicksilver.zone:26656,8603d0778bfe0a8d2f8eaa860dcdc5eb85b55982@seed02.killerqueen-1.quicksilver.zone:27676"
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.quicksilverd/config/config.toml
systemctl restart quicksilverd
```

## Explorerdaki güncel blok sayısını yakalamaya çalışıyoruz:

## Bu komut ile false çıktısı almanız gerekiyor: (True yazarsa eşleşmesini bekleyin)
```
quicksilverd status 2>&1 | jq .SyncInfo
```

## Cüzdan oluşturuyoruz. Çıkan kurtarma ifadelerini kaydetmeyi unutmayın: (Wallet kısmını siz düzeleyin) 
```
quicksilverd keys add WALLET
```

## Ardından discord kanalına giderek #qck-tap kanalında token istiyoruz:

Discord kanalları: [kanal linki](https://discord.gg/fWCGsb7sE7) 

Discorddan talep komutu: $request + cüzdan adresi ve sonuna killerqueen şeklinde. 1 kez alabiliyorsunuz 5 token veriliyor.


## Şimdi gelelim, Validator oluşturmaya: (wallet ve node isminiz değişecek)
```
quicksilverd tx staking create-validator \
  --amount 10000000uqck \
  --from wallet \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(quicksilverd tendermint show-validator) \
  --moniker node \
  --chain-id killerqueen-1
```
