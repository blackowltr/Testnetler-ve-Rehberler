# Görevler

## 1. adım
> Add liquid stake

```
strided tx stakeibc liquid-stake 1000 uatom --from <WALLET> --chain-id STRIDE-TESTNET-4
```

## 2. adım
> Redeem stake

```
strided tx stakeibc redeem-stake 1000 GAIA <COSMOS_ADDRESS_YOU_WANT_TO_REDEEM_TO> --chain-id STRIDE-TESTNET-4 --from cüzdanismi
```


## 3. adım
> Check if tokens are claimable

```
strided q records list-user-redemption-record --limit 10000 --output json | jq '.UserRedemptionRecord | map(select(.sender == "stride15rdc0pzpr4x88wee3tjlu6f2alknh79ph03y2t"))'
```
Çıktı örneği;

```
[
  {
    "id": "GAIA.280.stride15rdc0pzpr4x88wee3tjlu6f2alknh79ph03y2t",
    "sender": "stride15rdc0pzpr4x88wee3tjlu6f2alknh79ph03y2t",
    "receiver": "cosmos15rdc0pzpr4x88wee3tjlu6f2alknh79p5y3c78",
    "amount": "1504870",
    "denom": "uatom",
    "hostZoneId": "GAIA",
    "epochNumber": "280",
    "isClaimable": true
  }
]
```

## 4. adım
> Claim your stake

```
strided tx stakeibc claim-undelegated-tokens GAIA 280 stride15rdc0pzpr4x88wee3tjlu6f2alknh79ph03y2t --chain-id STRIDE-TESTNET-4 --from cüzdanismi --yes
```
## 5. adım
> Delegate to another validator

```
strided tx staking delegate stridevaloper1xxn6tgdc75gdh9l9tlvncy45dytshkvx0y0zt8 100000ustrd --from=cüzdanismi --chain-id=STRIDE-TESTNET-4 --gas=auto
```

### Hepinize kolay gelsin..
