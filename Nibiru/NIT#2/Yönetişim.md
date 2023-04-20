# Yönetişim

![Nibiru Teşvikli Test Ağı](https://user-images.githubusercontent.com/107190154/230293388-fff9ce61-9c08-4107-9780-62afd581519e.png)

## Peki ama nasıl yönetişime katılacağız? diyorsanız okumaya devam edebilirsiniz.

### Aşağıdaki bağlantılardan açık olan oylamaları görebilirsiniz:

https://explorer.kjnodes.com/nibiru-testnet/gov 

https://nibiru.explorers.guru/proposals

https://nibiru.exploreme.pro/proposals

*Explorer’a cüzdan bağlayıp oradan da oy verebilirsiniz.*

### Terminalden oy vermek için ise:

**Evet oyu için**

```
nibid tx gov vote PROPOSALID yes --from CÜZDANADINIZ --chain-id nibiru-itn-1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025unibi -y
```

**Hayır oyu için**

```
nibid tx gov vote PROPOSALID no --from CÜZDANADINIZ --chain-id nibiru-itn-1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025unibi -y 
``` 

**NOT: Proposal ID ve cüzdan adınızı düzenlemeyi unutmayın.**

### Proposal ID ne demek derseniz şöyle ifade edeyim:

**Oylamaların numaraları Proposal ID'dir.**

<img width="1052" alt="w34rfvcd" src="https://user-images.githubusercontent.com/107190154/230294748-c18f0f4b-5ec5-4ad9-b8e8-a9a7011003f8.png">

## Diğer explorer için ise Proposal ID'ler şöyle:

<img width="1259" alt="dfdfadfgr" src="https://user-images.githubusercontent.com/107190154/230295472-dd29c510-22e7-4017-8563-d73bb67e65c7.png">

## Bir oylama başlatmak için aşağıdaki komutu kullanabilirsiniz.

``` 
nibid tx gov submit-proposal --title="BAŞLIK" --description="AÇIKLAMA" --type="Text" --deposit="10000000unibi" --from=CÜZDANADINIZ --fees 500unibi
``` 

### Herhangi bir sorunuz varsa, discord'da sorabilirsiniz : https://discord.gg/nibirufi
### BlackOwl Twitter : https://twitter.com/brsbtc
