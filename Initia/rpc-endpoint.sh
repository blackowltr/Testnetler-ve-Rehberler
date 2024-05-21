#!/bin/bash

# Fonksiyon: RPC bağlantısını kontrol et
check_rpc_connection() {
    if curl $RPC_URL/status &>/dev/null; then
        SUCCESS=1
    else
        SUCCESS=0
    fi
}

# İlerleme gösterme fonksiyonu
show_progress() {
    local -r total_loops=20  # Toplam döngü sayısı
    local -r sleep_time=5    # Bekleme süresi (saniye cinsinden)
    local current_loop=0
    local percentage=0

    echo -n 'Processing '

    while [ $current_loop -lt $total_loops ]; do
        printf '\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b%02d%%' "$percentage"
        sleep "$sleep_time"
        ((current_loop++))
        ((percentage = current_loop * 100 / total_loops))
    done

    printf '\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b100%%'
}

# IP adresini al
IP=$(wget -qO- eth0.me)

# RPC bağlantı noktasını al
RPC_PORT=$(grep -A 3 "\[rpc\]" $HOME/.initia/config/config.toml | grep -oP ":\K[0-9]+")
RPC_URL="http://$IP:$RPC_PORT"

# Bağlantı başarılı olana kadar döngü
SUCCESS=0
while [ $SUCCESS -eq 0 ]; do
    # RPC bağlantısını kontrol et
    check_rpc_connection
    
    # Eğer bağlantı başarısızsa, gerekli işlemleri yap
    if [ "$SUCCESS" = "0" ]; then
        # Config dosyasını düzenle ve node'u yeniden başlat
        sed -i '/\[rpc\]/,/\[/{s/^laddr = "tcp:\/\/127\.0\.0\.1:/laddr = "tcp:\/\/0.0.0\.0:/}' $HOME/.initia/config/config.toml
        sudo systemctl restart initiad &>/dev/null
        sleep 5

        # Yeniden RPC bağlantısını kontrol et
        check_rpc_connection

        # Eğer hala bağlantı başarısızsa, firewall'u kontrol et ve bağlantı noktasını aç
        if [ "$SUCCESS" = "0" ]; then
            PORT=$(grep -A 3 "\[rpc\]" $HOME/.initia/config/config.toml | egrep -o ":[0-9]+") && \
            PORT=${PORT#:} && \
            sudo ufw allow $PORT/tcp &>/dev/null
            sudo systemctl restart initiad &>/dev/null
            sleep 5

            # Son kez RPC bağlantısını kontrol et
            check_rpc_connection
        fi
    fi
done | show_progress

# İlerleme döngüsünü sonlandır
echo
echo "RPC BAĞLANTISI BAŞARILI"
echo "Public RPC URL'si: $RPC_URL"
echo "Beni X'te takip edin: https://x.com/brsbtc"
