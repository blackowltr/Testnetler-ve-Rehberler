# Görevler

## 🌊 Product Tasks
| #     | Pts |  Task                                                                |                                     Evidence | Instructions      |
| ----- | --- | -------------------------------------------------------------------- |:--------------------------------------------:| ----------------- |
| **6** | 50  | complete the stake, redeem, and claim flow (including 6hr unbonding) | link to all the txs: liqstake, redeem, claim | - |

### Add liquid stake

```
strided tx stakeibc liquid-stake 1000 uatom --from <WALLET> --chain-id STRIDE-TESTNET-4
```

### Redeem stake

```
strided tx stakeibc redeem-stake 1000 GAIA <COSMOS_ADDRESS_YOU_WANT_TO_REDEEM_TO> --chain-id STRIDE-TESTNET-4 --from cüzdanismi
```


### Check if tokens are claimable

```
strided q records list-user-redemption-record --limit 10000 --output json | jq '.UserRedemptionRecord | map(select(.sender == "stride15rdc0pzpr4x88wee3tjlu6f2alknh79ph03y2t"))'
```
**Çıktı örneği;**

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

### Claim your stake

```
strided tx stakeibc claim-undelegated-tokens GAIA 280 stride15rdc0pzpr4x88wee3tjlu6f2alknh79ph03y2t --chain-id STRIDE-TESTNET-4 --from cüzdanismi --yes
```

 **[Diğer Görevler İçin](https://github.com/brsbrc/Testnetler-ve-Rehberler/tree/main/Stride/G%C3%B6revler)**

### Hepinize kolay gelsin..
