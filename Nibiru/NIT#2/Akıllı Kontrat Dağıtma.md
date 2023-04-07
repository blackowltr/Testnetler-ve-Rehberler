# Nibiru’da bir akıllı sözleşme dağıtın.

![Nibiru Teşvikli Test Ağı](https://user-images.githubusercontent.com/107190154/230292010-0829ac0c-b088-4354-96cb-5aa236465060.png)

## Akıllı Kontrat Görevleri 
**Nibiru üzerinde bir akıllı sözleşme dağıtın.**

**Nibiru üzerinde bir akıllı sözleşme başlatın.**

**Bir ExecuteContract işlemini başarıyla yayınlayın.**

### Bu rehberi sonuna kadar tamamladığınızda `Akıllı Kontrat Görevleri` tamamlanmış olacak. 

<h1 align="center">Nibiru'da bir akıllı sözleşme dağıtma</h1>


## Adımları sırasıyla yaparsanız sorunsuz şekilde yaparsınız.
>Nibiru Binary yükleyelim.
```
curl -s https://get.nibiru.fi/! | bash
```

## Konfigürasyonu ayarlama

```
nibid config node https://rpc.itn-1.nibiru.fi:443
nibid config chain-id nibiru-itn-1
nibid config broadcast-mode block
nibid config keyring-backend os
```

## İlk olarak NibiruChain reposundan cw-nibiru dosyamızı çekiyoruz.
```
git clone https://github.com/NibiruChain/cw-nibiru
```

## Kontratı ağa yüklüyoruz.

```
CUZDAN=CÜZDANADINIZ
nibid tx wasm store $HOME/cw-nibiru/artifacts-cw-plus/cw20_base.wasm --from $CUZDAN --gas-adjustment 1.2 --gas auto  --fees 80000unibi  -y 
```

### Örnek Çıktı:
```
code: 0
codespace: ""
data: 0A470A1E2F636F736D7761736D2E7761736D2E76312E4D736753746F7265436F64651225088E0712201525A17A5B98438A26B019FFA184B2A355D225485FCFC87CCBCD524D4A24BE18
events:
- attributes:
  - index: true
    key: c3BlbmRlcg==
    value: bmliaTF4eG42dGdkYzc1Z2RoOWw5dGx2bmN5NDVkeXRzaGt2eGNsMG02YQ==
  - index: true
    key: YW1vdW50
    value: ODAwMDB1bmliaQ==
  type: coin_spent
- attributes:
  - index: true
    key: cmVjZWl2ZXI=
    value: bmliaTE3eHBmdmFrbTJhbWc5NjJ5bHM2Zjg0ejNrZWxsOGM1bDh1OGV6dw==
  - index: true
    key: YW1vdW50
    value: ODAwMDB1bmliaQ==
  type: coin_received
- attributes:
  - index: true
    key: cmVjaXBpZW50
    value: bmliaTE3eHBmdmFrbTJhbWc5NjJ5bHM2Zjg0ejNrZWxsOGM1bDh1OGV6dw==
  - index: true
    key: c2VuZGVy
    value: bmliaTF4eG42dGdkYzc1Z2RoOWw5dGx2bmN5NDVkeXRzaGt2eGNsMG02YQ==
  - index: true
    key: YW1vdW50
    value: ODAwMDB1bmliaQ==
  type: transfer
- attributes:
  - index: true
    key: c2VuZGVy
    value: bmliaTF4eG42dGdkYzc1Z2RoOWw5dGx2bmN5NDVkeXRzaGt2eGNsMG02YQ==
  type: message
- attributes:
  - index: true
    key: ZmVl
    value: ODAwMDB1bmliaQ==
  type: tx
- attributes:
  - index: true
    key: YWNjX3NlcQ==
    value: bmliaTF4eG42dGdkYzc1Z2RoOWw5dGx2bmN5NDVkeXRzaGt2eGNsMG02YS84OTM5
  type: tx
- attributes:
  - index: true
    key: c2lnbmF0dXJl
    value: NEhuQk5nVE1yYjl0VWNydk1vQlUrVGRnb2FkVElUT1BVRS9RZkxXUVJKZy9lMG16cGJTcEN6UnhVZzBYM3RXa2JVNE9iWWtwbk5ZSitzMzlxUjlTV1E9PQ==
  type: tx
- attributes:
  - index: true
    key: YWN0aW9u
    value: L2Nvc213YXNtLndhc20udjEuTXNnU3RvcmVDb2Rl
  type: message
- attributes:
  - index: true
    key: bW9kdWxl
    value: d2FzbQ==
  - index: true
    key: c2VuZGVy
    value: bmliaTF4eG42dGdkYzc1Z2RoOWw5dGx2bmN5NDVkeXRzaGt2eGNsMG02YQ==
  type: message
- attributes:
  - index: true
    key: Y29kZV9jaGVja3N1bQ==
    value: MTUyNWExN2E1Yjk4NDM4YTI2YjAxOWZmYTE4NGIyYTM1NWQyMjU0ODVmY2ZjODdjY2JjZDUyNGQ0YTI0YmUxOA==
  - index: true
    key: Y29kZV9pZA==
    value: OTEw
  type: store_code
gas_used: "2140833"
gas_wanted: "2567307"
height: "1702222"
info: ""
logs:
- events:
  - attributes:
    - key: action
      value: /cosmwasm.wasm.v1.MsgStoreCode
    - key: module
      value: wasm
    - key: sender
      value: nibi1xxn6tgdc75gdh9l9tlvncy45dytshkvxcl0m6a
    type: message
  - attributes:
    - key: code_checksum
      value: 1525a17a5b98438a26b019ffa184b2a355d225485fcfc87ccbcd524d4a24be18
    - key: code_id
      value: "910"
    type: store_code
  log: ""
  msg_index: 0
raw_log: '[{"events":[{"type":"message","attributes":[{"key":"action","value":"/cosmwasm.wasm.v1.MsgStoreCode"},{"key":"module","value":"wasm"},{"key":"sender","value":"nibi1xxn6tgdc75gdh9l9tlvncy45dytshkvxcl0m6a"}]},{"type":"store_code","attributes":[{"key":"code_checksum","value":"1525a17a5b98438a26b019ffa184b2a355d225485fcfc87ccbcd524d4a24be18"},{"key":"code_id","value":"910"}]}]}]'
timestamp: ""
tx: null
txhash: 7AF12037B5F01242C5AF25CFEBF78C2AE1ABC0ED50075113447A1C3B86628D70
```

## `code id` ve `txhash` bir yere not edin.

## Code ID'nizi unuttuysanız şu komutla bakabilirsiniz.
> TXHASH kısmını doldurmayı unutmayın.

```
nibid q tx TXHASHYAZIN -o json |  jq -r '.raw_log'
```

### Örnek Komut:
```
nibid q tx 7AF12037B5F01242C5AF25CFEBF78C2AE1ABC0ED50075113447A1C3B86628D70 -o json |  jq -r '.raw_log'
```

<img width="1207" alt="image" src="https://user-images.githubusercontent.com/107190154/230658645-0b5af65c-6ad4-4acc-82c4-0c97cbba9358.png">

<h1 align="center">Nibiru'da bir akıllı sözleşme başlatma</h1>

## Bu aşamada bir token basacağız.

## Aşağıdaki örnek komuta göre doldurup komutu kullanınız.
>name,symbol, adres kısımlarını dolduracaksınız.
```
INIT='{"name":"test","symbol":"test","decimals":6,"initial_balances":[{"address":"ADRES","amount":"5000000"}],"mint":{"minter":"ADRES"},"marketing":{}}'
```

### Örnek Komut

```
INIT='{"name":"blackowl","symbol":"bbw","decimals":6,"initial_balances":[{"address":"nibi1xxn6tgdc75gdh9l9tlvncy45dytshkvxcl0m6a","amount":"5000000"}],"mint":{"minter":"nibi1xxn6tgdc75gdh9l9tlvncy45dytshkvxcl0m6a"},"marketing":{}}'
```

<img width="1217" alt="image" src="https://user-images.githubusercontent.com/107190154/230659334-cec729c3-0504-4f65-a87f-ab2b5d6b73fa.png">

## Label kısmını isterseniz değiştirebilirsiniz, dilerseniz aynı da kalabilir.
>Code ID'nizi ve cüzdan adınızı yazın.
```
ID=CODEIDYAZIN
CUZDAN=CUZDANADINIZ
```
```
nibid tx wasm instantiate $ID $INIT --from $CUZDAN --label "test" --gas-adjustment 1.2 --gas auto  --fees 80000unibi --no-admin -y
```

Örnek Çıktı:
```
code: 0
codespace: ""
data: 0A6D0A282F636F736D7761736D2E7761736D2E76312E4D7367496E7374616E7469617465436F6E747261637412410A3F6E69626931743972706D30773079777939717937776A6C76356A72786D797473667876726D66713563656464787730726A776B71306E736C7174713630736B
events:
- attributes:
  - index: true
    key: c3BlbmRlcg==
    value: bmliaTF4eG42dGdkYzc1Z2RoOWw5dGx2bmN5NDVkeXRzaGt2eGNsMG02YQ==
  - index: true
    key: YW1vdW50
    value: NzM3OTR1bmliaQ==
  type: coin_spent
- attributes:
  - index: true
    key: cmVjZWl2ZXI=
    value: bmliaTE3eHBmdmFrbTJhbWc5NjJ5bHM2Zjg0ejNrZWxsOGM1bDh1OGV6dw==
  - index: true
    key: YW1vdW50
    value: NzM3OTR1bmliaQ==
  type: coin_received
- attributes:
  - index: true
    key: cmVjaXBpZW50
    value: bmliaTE3eHBmdmFrbTJhbWc5NjJ5bHM2Zjg0ejNrZWxsOGM1bDh1OGV6dw==
  - index: true
    key: c2VuZGVy
    value: bmliaTF4eG42dGdkYzc1Z2RoOWw5dGx2bmN5NDVkeXRzaGt2eGNsMG02YQ==
  - index: true
    key: YW1vdW50
    value: NzM3OTR1bmliaQ==
  type: transfer
- attributes:
  - index: true
    key: c2VuZGVy
    value: bmliaTF4eG42dGdkYzc1Z2RoOWw5dGx2bmN5NDVkeXRzaGt2eGNsMG02YQ==
  type: message
- attributes:
  - index: true
    key: ZmVl
    value: NzM3OTR1bmliaQ==
  type: tx
- attributes:
  - index: true
    key: YWNjX3NlcQ==
    value: bmliaTF4eG42dGdkYzc1Z2RoOWw5dGx2bmN5NDVkeXRzaGt2eGNsMG02YS84OTQw
  type: tx
- attributes:
  - index: true
    key: c2lnbmF0dXJl
    value: MDM3RWZLK3pNTlZSZEdlQXdCdDgydUNFNkZhcDRvTDBLMUFoUG9teHlFY0Z0ZERBNWJnVTdKd1FYUjZpd2l1eEFjOStqWUZROGxuSGVFbUNaT09LWHc9PQ==
  type: tx
- attributes:
  - index: true
    key: YWN0aW9u
    value: L2Nvc213YXNtLndhc20udjEuTXNnSW5zdGFudGlhdGVDb250cmFjdA==
  type: message
- attributes:
  - index: true
    key: bW9kdWxl
    value: d2FzbQ==
  - index: true
    key: c2VuZGVy
    value: bmliaTF4eG42dGdkYzc1Z2RoOWw5dGx2bmN5NDVkeXRzaGt2eGNsMG02YQ==
  type: message
- attributes:
  - index: true
    key: X2NvbnRyYWN0X2FkZHJlc3M=
    value: bmliaTF0OXJwbTB3MHl3eTlxeTd3amx2NWpyeG15dHNmeHZybWZxNWNlZGR4dzByandrcTBuc2xxdHE2MHNr
  - index: true
    key: Y29kZV9pZA==
    value: OTEw
  type: instantiate
gas_used: "178999"
gas_wanted: "212797"
height: "1702529"
info: ""
logs:
- events:
  - attributes:
    - key: _contract_address
      value: nibi1t9rpm0w0ywy9qy7wjlv5jrxmytsfxvrmfq5ceddxw0rjwkq0nslqtq60sk
    - key: code_id
      value: "910"
    type: instantiate
  - attributes:
    - key: action
      value: /cosmwasm.wasm.v1.MsgInstantiateContract
    - key: module
      value: wasm
    - key: sender
      value: nibi1xxn6tgdc75gdh9l9tlvncy45dytshkvxcl0m6a
    type: message
  log: ""
  msg_index: 0
raw_log: '[{"events":[{"type":"instantiate","attributes":[{"key":"_contract_address","value":"nibi1t9rpm0w0ywy9qy7wjlv5jrxmytsfxvrmfq5ceddxw0rjwkq0nslqtq60sk"},{"key":"code_id","value":"910"}]},{"type":"message","attributes":[{"key":"action","value":"/cosmwasm.wasm.v1.MsgInstantiateContract"},{"key":"module","value":"wasm"},{"key":"sender","value":"nibi1xxn6tgdc75gdh9l9tlvncy45dytshkvxcl0m6a"}]}]}]'
timestamp: ""
tx: null
txhash: 3E4B7146371CFE31C081CC20249661DA58D7AC8BDEBDA6C851E87D7E0A3884F5
```

### Bu çıktı da contract_address kısmını da not düşelim kenara.

**cw20 tokenlarımızdan bazılarını arkadaşlarımıza gönderelim. Token'arı göndermek istediğiniz adresi ve token sayısını belirtin.**

<h1 align="center">Bir ExecuteContract işlemini başarıyla yayınlama</h1>

### Amount kısmından miktarı değiştirebilirsiniz.
```
TRANSFER='{"transfer":{"recipient":"GÖNDERMEKİSTEDİĞİNİZADRES","amount":"100"}}'
```

## Execute adımı
```
nibid tx wasm execute $CONTRACT $TRANSFER --gas-adjustment 1.2 --gas auto --fees 4000unibi --from $CUZDAN -y
```

### Örnek Çıktı
```
code: 0
codespace: ""
data: 0A260A242F636F736D7761736D2E7761736D2E76312E4D736745786563757465436F6E7472616374
events:
- attributes:
  - index: true
    key: c3BlbmRlcg==
    value: bmliaTF4eG42dGdkYzc1Z2RoOWw5dGx2bmN5NDVkeXRzaGt2eGNsMG02YQ==
  - index: true
    key: YW1vdW50
    value: NDAwMHVuaWJp
  type: coin_spent
- attributes:
  - index: true
    key: cmVjZWl2ZXI=
    value: bmliaTE3eHBmdmFrbTJhbWc5NjJ5bHM2Zjg0ejNrZWxsOGM1bDh1OGV6dw==
  - index: true
    key: YW1vdW50
    value: NDAwMHVuaWJp
  type: coin_received
- attributes:
  - index: true
    key: cmVjaXBpZW50
    value: bmliaTE3eHBmdmFrbTJhbWc5NjJ5bHM2Zjg0ejNrZWxsOGM1bDh1OGV6dw==
  - index: true
    key: c2VuZGVy
    value: bmliaTF4eG42dGdkYzc1Z2RoOWw5dGx2bmN5NDVkeXRzaGt2eGNsMG02YQ==
  - index: true
    key: YW1vdW50
    value: NDAwMHVuaWJp
  type: transfer
- attributes:
  - index: true
    key: c2VuZGVy
    value: bmliaTF4eG42dGdkYzc1Z2RoOWw5dGx2bmN5NDVkeXRzaGt2eGNsMG02YQ==
  type: message
- attributes:
  - index: true
    key: ZmVl
    value: NDAwMHVuaWJp
  type: tx
- attributes:
  - index: true
    key: YWNjX3NlcQ==
    value: bmliaTF4eG42dGdkYzc1Z2RoOWw5dGx2bmN5NDVkeXRzaGt2eGNsMG02YS84OTQx
  type: tx
- attributes:
  - index: true
    key: c2lnbmF0dXJl
    value: Tloxc2NXY25DaVo0RG91U256Z205U2VmT1ZHTFlnMjkwcTlwd1lDQWpLa0I4MkZ2SnBBdGg4SENBN2Y5TDBFVG1NRWVBaDZ6QllSRWhKd0xSbHNkYlE9PQ==
  type: tx
- attributes:
  - index: true
    key: YWN0aW9u
    value: L2Nvc213YXNtLndhc20udjEuTXNnRXhlY3V0ZUNvbnRyYWN0
  type: message
- attributes:
  - index: true
    key: bW9kdWxl
    value: d2FzbQ==
  - index: true
    key: c2VuZGVy
    value: bmliaTF4eG42dGdkYzc1Z2RoOWw5dGx2bmN5NDVkeXRzaGt2eGNsMG02YQ==
  type: message
- attributes:
  - index: true
    key: X2NvbnRyYWN0X2FkZHJlc3M=
    value: bmliaTF0OXJwbTB3MHl3eTlxeTd3amx2NWpyeG15dHNmeHZybWZxNWNlZGR4dzByandrcTBuc2xxdHE2MHNr
  type: execute
- attributes:
  - index: true
    key: X2NvbnRyYWN0X2FkZHJlc3M=
    value: bmliaTF0OXJwbTB3MHl3eTlxeTd3amx2NWpyeG15dHNmeHZybWZxNWNlZGR4dzByandrcTBuc2xxdHE2MHNr
  - index: true
    key: YWN0aW9u
    value: dHJhbnNmZXI=
  - index: true
    key: ZnJvbQ==
    value: bmliaTF4eG42dGdkYzc1Z2RoOWw5dGx2bmN5NDVkeXRzaGt2eGNsMG02YQ==
  - index: true
    key: dG8=
    value: bmliaTF2bm5rZ2NubHdkNDZ0M3ZkdDRjeW5mbHNsczk0cHZsYWY1Z3o5eg==
  - index: true
    key: YW1vdW50
    value: MTAw
  type: wasm
gas_used: "134041"
gas_wanted: "159124"
height: "1702731"
info: ""
logs:
- events:
  - attributes:
    - key: _contract_address
      value: nibi1t9rpm0w0ywy9qy7wjlv5jrxmytsfxvrmfq5ceddxw0rjwkq0nslqtq60sk
    type: execute
  - attributes:
    - key: action
      value: /cosmwasm.wasm.v1.MsgExecuteContract
    - key: module
      value: wasm
    - key: sender
      value: nibi1xxn6tgdc75gdh9l9tlvncy45dytshkvxcl0m6a
    type: message
  - attributes:
    - key: _contract_address
      value: nibi1t9rpm0w0ywy9qy7wjlv5jrxmytsfxvrmfq5ceddxw0rjwkq0nslqtq60sk
    - key: action
      value: transfer
    - key: from
      value: nibi1xxn6tgdc75gdh9l9tlvncy45dytshkvxcl0m6a
    - key: to
      value: nibi1vnnkgcnlwd46t3vdt4cynflsls94pvlaf5gz9z
    - key: amount
      value: "100"
    type: wasm
  log: ""
  msg_index: 0
raw_log: '[{"events":[{"type":"execute","attributes":[{"key":"_contract_address","value":"nibi1t9rpm0w0ywy9qy7wjlv5jrxmytsfxvrmfq5ceddxw0rjwkq0nslqtq60sk"}]},{"type":"message","attributes":[{"key":"action","value":"/cosmwasm.wasm.v1.MsgExecuteContract"},{"key":"module","value":"wasm"},{"key":"sender","value":"nibi1xxn6tgdc75gdh9l9tlvncy45dytshkvxcl0m6a"}]},{"type":"wasm","attributes":[{"key":"_contract_address","value":"nibi1t9rpm0w0ywy9qy7wjlv5jrxmytsfxvrmfq5ceddxw0rjwkq0nslqtq60sk"},{"key":"action","value":"transfer"},{"key":"from","value":"nibi1xxn6tgdc75gdh9l9tlvncy45dytshkvxcl0m6a"},{"key":"to","value":"nibi1vnnkgcnlwd46t3vdt4cynflsls94pvlaf5gz9z"},{"key":"amount","value":"100"}]}]}]'
timestamp: ""
tx: null
txhash: 4BC17CEF06BD6844CB7A790AEC02382F855140E0FEFEE4BDF0DB22FA9DFC5E67
```

### İşlemler bu kadardı. Txler explorerda şöyle görünecek:

<img width="1081" alt="image" src="https://user-images.githubusercontent.com/107190154/230661410-6b8f6057-9eca-4d7d-aa21-7881f6875e00.png">

### Akıllı kontrat görevlerinin hepsini yerine getirmiş olduk.

### Herhangi bir sorunuz varsa, discord'da sorabilirsiniz : https://discord.gg/EPF8ZxD9zP

### BlackOwl Twitter : https://twitter.com/brsbtc 
