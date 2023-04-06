# Governance

![nit-2-banner](https://user-images.githubusercontent.com/107190154/230300642-00934663-445e-44d7-8a24-aa2be59e9f70.jpg)

## But how do we participate in governance?

### You can see the open votes in the links below:

https://explorer.kjnodes.com/nibiru-testnet/gov 

https://nibiru.explorers.guru/proposals

https://nibiru.exploreme.pro/proposals

*You can also connect a wallet to Explorer and vote from there.*

### Use the following commands to vote using the terminal.

**For a yes vote**

```
nibid tx gov vote PROPOSALID yes --from WALLETNAME --chain-id nibiru-itn-1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025unibi -y
```

**For a no vote**

```
nibid tx gov vote PROPOSALID no --from WALLETNAME --chain-id nibiru-itn-1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025unibi -y 
``` 

**NOTE: Don't forget to edit your Proposal ID and wallet name.**

### If you don't know what Proposal ID means, check the images below.

**The number of the vote is the Proposal ID.**

<img width="1052" alt="w34rfvcd" src="https://user-images.githubusercontent.com/107190154/230294748-c18f0f4b-5ec5-4ad9-b8e8-a9a7011003f8.png">

## For the other explorer, the Proposal IDs are as follows:

<img width="1259" alt="dfdfadfgr" src="https://user-images.githubusercontent.com/107190154/230295472-dd29c510-22e7-4017-8563-d73bb67e65c7.png">

## You can use the following command to start a vote.

``` 
nibid tx gov submit-proposal --title="BAŞLIK" --description="AÇIKLAMA" --type="Text" --deposit="10000000unibi" --from=CÜZDANADINIZ --fees 500unibi
``` 

### If you have any questions, you can ask on discord. : https://discord.gg/EPF8ZxD9zP

### BlackOwl Twitter : https://twitter.com/brsbtc 
