#!/bin/bash

# Sonsuz döngü
while true
do
    # Log dosyasını kontrol et
    if journalctl -u tracksd -n 100 --no-pager --no-hostname -o cat | grep -Eq "rpc error: code = Unknown desc = failed to execute message|Failed to get transaction by hash: not found|Retrying the transaction after 10 seconds..."; then
        echo "Hata bulundu, işlemler başlatılıyor..."

        # Servisleri durdur
        service cron stop
        if [ $? -ne 0 ]; then
            echo "Cron servisini durdurma başarısız oldu. Tekrar denenecek..."
            continue
        fi

        systemctl stop tracksd
        if [ $? -ne 0 ]; then
            echo "Tracksd servisini durdurma başarısız oldu. Tekrar denenecek..."
            continue
        fi

        # Güncellemeleri çek ve derle
        git pull
        if [ $? -ne 0 ]; then
            echo "Git pull başarısız oldu. Tekrar denenecek..."
            continue
        fi

        make build
        if [ $? -ne 0 ]; then
            echo "Build işlemi başarısız oldu. Tekrar denenecek..."
            continue
        fi

        # Rollback işlemini 5-6 defa çalıştır
        for i in {1..5}
        do
            go run cmd/main.go rollback
            if [ $? -ne 0 ]; then
                echo "Rollback başarısız oldu. Tekrar denenecek..."
                continue 2
            fi
        done

        # Servisleri yeniden başlat
        systemctl restart tracksd
        if [ $? -ne 0 ]; then
            echo "Tracksd servisini başlatma başarısız oldu. Tekrar denenecek..."
            continue
        fi
        sleep 3

        service cron start
        if [ $? -ne 0 ]; then
            echo "Cron servisini başlatma başarısız oldu. Tekrar denenecek..."
            continue
        fi
        sleep 3

        echo "İşlemler tamamlandı."
    else
        echo "Hata bulunamadı, kontrol için 2 dakika bekleniyor..."
    fi

    # 2 dakika bekle
    sleep 120
done
