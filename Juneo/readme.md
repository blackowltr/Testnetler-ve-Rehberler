# Juneo Node Kurulum Rehberi

![image](https://github.com/brsbrc/Testnetler-ve-Rehberler/assets/107190154/d4b4cc0c-e95f-4909-982c-134c56e6a957)

### [Başvuru adresi](https://juneo.com/forms)

## 1) Node Kurulum

### 1. Makinemizi güncelleyelim ve kütüphane kurulumlarını tamamlayalım.
```
sudo apt update && sudo apt upgrade
sudo apt-get -y install libssl-dev && apt-get -y install cmake build-essential git wget jq make gcc
```

### 2. Kuruluma aşağıdaki komutla başlayalım:
> Tek tek komutları girmenize gerek yok, komple alın ve terminale yapıştırın.
```
git clone https://github.com/Juneo-io/juneogo-binaries && \
cd juneogo-binaries && \
sudo cp -r juneogo /root/ && \
cd plugins && \
sudo cp -r ./* /root/ && \
cd
```

### 3. Dosyaları yetkilendirelim. 
> Tek tek komutları girmenize gerek yok, komple alın ve terminale yapıştırın.
```
chmod +x juneogo && \
chmod +x jevm && \
chmod +x srEr2XGGtowDVNQ6YgXcdUb16FGknssLTGUFYg7iMqESJ4h8e
```

### 4. Şimdi ise Binary'den aldığımız dosyaları ilgili kısımlara taşıyacağız.
> Tek tek komutları girmenize gerek yok, komple alın ve terminale yapıştırın.
```
mkdir -p .juneogo/plugins && \
mv jevm .juneogo/plugins && \
mv srEr2XGGtowDVNQ6YgXcdUb16FGknssLTGUFYg7iMqESJ4h8e .juneogo/plugins
```

### 5. Node'u başlatalım.
```
sudo apt install screen
screen -S juneogo
./juneogo
```

**Örnek çıktı:**

![image](https://github.com/brsbrc/Testnetler-ve-Rehberler/assets/107190154/44c2c670-1539-438b-8257-1e7f778b7975)

### 6. Daha sonra buradan ctrl a - d ile çıkalım.

### 7. Bir süre sonra node'un boostrapped olup olmadığını aşağıdaki komutla kontrol edebilirsiniz:

Burada tıpkı örnek çıktıda olduğu gibi isBootstrapped kısmı "true" olmalıdır.

Not: Yaklaşık 45-60 dk arasında "true" çıktısı veriyor.
```
curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     :1,
    "method" :"info.isBootstrapped",
    "params": {
        "chain":"JUNE"
    }
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/info
```

**Örnek Çıktı:** 

![image](https://github.com/brsbrc/Testnetler-ve-Rehberler/assets/107190154/a67c01db-bc84-43f0-b74d-4607be197af7)

### 8. İlgili Portları Açalım:
```
sudo ufw allow 9650
sudo ufw allow 9651 
```

### 9. Tarih/saat senkronizasyonunu ayarlama

Bunun sebebini resmi dokümanda şu şekilde ifade etmişler: "Node'unuzun saatinin doğru şekilde senkronize edilmesi son derece önemlidir. Yanlış zaman senkronizasyonu, node'un çevrimdışı olarak işaretlenmesine neden olur ve bu da stake ödüllerinin kaybedilmesine yol açabilir."
```
timedatectl set-ntp on
```

### 10. Node ID'mizi alalım:
```
curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     :1,
    "method" :"info.getNodeID"
}' -H 'content-type:application/json' 127.0.0.1:9650/ext/info
```

**Örnek Çıktı:**
```
{"jsonrpc":"2.0","result":{"nodeID":"NodeID-HPUJEHhp4ZzCTXXXXXXXXXXXXX","nodePOP":{"publicKey":"0xXXXXXXXXXXXXXXXX
```

### 11. Şimdi [MCN cüzdana'a gidelim](https://www.mcnwallet.io/) ve bir cüzdan oluşturalım: 

### 12. Cüzdan oluşturduktan sonra Node Id'nizi ve June-Chain cüzdan adresinizi ekibe iletin.

### 13. Token geldikten sonra cüzdanda Cross-Chain kısmına gelelim:

June-Chain'den Platform-Chain'e token transfer edelim. 50 adet yollayın.

![image](https://github.com/brsbrc/Testnetler-ve-Rehberler/assets/107190154/5a1a3e52-2a6a-4b76-80f0-e1b126d8d43c)

### 14. Daha sonra cüzdanın en solundaki "Stake" butonuna tıklayın. 

### 15. Sonra da "Validate" kısmına geçelim. 

Ardından az evvel aldığımız Node ID'mizi Node ID yazan yere yapıştıralım. Stake adedimiz en az 1 olacak şekilde ayarlayalım ve token adedimizi istenen ve gereken şekilde ayarladıktan sonra cüzdanın en sağında mavi renkli fonu olan "Validate" butonuna tıklayalım.

### 16. İşlem tamamlandıktan sonra tarayıcıya gidelim.

Buradan Node ID'mizi kontrol edelim. Başarılı bir kurulum sonucunda örnek aşağıdaki görseldeki gibi olacaktır. 

![image](https://github.com/brsbrc/Testnetler-ve-Rehberler/assets/107190154/6b2d0bff-bbae-46ef-aa9a-d34aad960847)

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# Supernet Oluşturma

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# Supernet EVM Deploy Etme

-BlackOwl
