# Allora Güncelleme

**1. Allora Container'larını Durdurun ve Kaldırın**

```shell
bash -c "$(curl -s https://raw.githubusercontent.com/blackowltr/Testnetler-ve-Rehberler/main/Allora/stop.sh)"
```

Bu komut, Allora container'larını durdurur ve kaldırır.

**2. basic-coin-prediction-node Klasörüne Gidin**

```shell
cd basic-coin-prediction-node
```

basic-coin-prediction-node klasörüne gidin.

**3. Docker-compose.yml Dosyasını Güncelleme**

```shell
sed -i 's/timeout: 5s/timeout: 10s/g' docker-compose.yml
sed -i 's/--topic=1/--topic=allora-topic-1-worker/g' docker-compose.yml
```

Bu adımlarla Docker-compose.yml dosyanızı güncelleyin:

- `timeout` süresini 5 saniyeden 10 saniyeye çıkarır.
- `--topic=1` kısmını `--topic=allora-topic-1-worker` olarak değiştirir.

**4. Docker Container'larını Yeniden Oluşturma ve Başlatma**

```shell
docker compose build
docker compose up -d
```

Bu komutlarla Docker container'larını yeniden oluşturun ve arka planda çalıştırın.

**5. Log Kontrol**

```shell
bash <(curl -s https://raw.githubusercontent.com/blackowltr/Testnetler-ve-Rehberler/main/Allora/log.sh)
```

Son olarak, logları kontrol etmek için bu komutu kullanın.

Örnek Log aşağıdaki gibi olmalıdır:

<img width="1362" alt="Ekran Resmi 2024-07-04 01 58 08" src="https://github.com/koltigin/Allora-Price-Prediction-Worker-Node/assets/107190154/6f13dda0-ffd8-4e6a-85a5-8b5f597d76f8">
