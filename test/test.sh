#!/bin/bash

# Renkler
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # Renk sıfırlama

# Başlık
echo -e "${GREEN}Self-Chain İşlem Menüsü${NC}"
echo "Lütfen aşağıdaki seçeneklerden birini seçin:"
echo "1. Self-Chain Düğümünü Yükle"
echo "2. Cüzdan Oluştur"
echo "3. Doğrulayıcı Oluştur"
echo -n "Seçiminizi girin (1/2/3): "

# Kullanıcının seçimini okuyun
read choice

# Sadece seçenek 1 için "sudo su" komutunu çalıştırın
if [ "$choice" -eq 1 ]; then
    sudo su
fi

# Kullanıcının seçimine göre işlemler yapın
case $choice in
    1)
        echo -e "${GREEN}Self-Chain Düğümü Yükleme seçildi, lütfen bekleyin...${NC}"
        # Komutu çalıştır
        wget -O selfchain.sh https://raw.githubusercontent.com/brsbrc/Testnetler-ve-Rehberler/main/Selfchain/selfchain.sh && chmod +x selfchain.sh && ./selfchain.sh
        ;;
    2)
        echo "Cüzdan Oluştur seçildi."
        read -p "Lütfen cüzdanınız için bir isim girin (KEYNAME): " KEYNAME
        if [ -z "$KEYNAME" ]; then
            echo -e "${RED}Geçersiz cüzdan ismi. Lütfen tekrar deneyin.${NC}"
        else
            echo "Cüzdanınız ismi: $KEYNAME ile oluşturuluyor."
            # Kullanıcı tarafından girilen KEYNAME ile cüzdan oluştur
            selfchaind keys add "$KEYNAME"
        fi
        ;;
    3)
        echo "Doğrulayıcı Oluştur seçildi, düğüm senkronizasyon durumu kontrol ediliyor..."
        status=$(selfchaind status --node http://localhost:26657 -t 10)
        if [[ $status == *"\"catching_up\": false"* ]]; then
            echo "Düğümünüz senkronize. Doğrulayıcı oluşturmaya devam ediliyor..."
            read -p "Düğüm isminizi girin (moniker): " MONIKER
            read -p "Cüzdan adresinizi girin (from): " WALLET_ADDRESS
            # Kullanıcının girdiği MONIKER ve WALLET_ADDRESS değerleriyle doğrulayıcı oluştur
            selfchaind tx staking create-validator \
                --amount=100000000uself \
                --pubkey=$(selfchaind tendermint show-validator) \
                --moniker="$MONIKER" \
                --identity="" \
                --details="" \
                --security-contact="" \
                --website="" \
                --chain-id=self-dev-1 \
                --commission-rate=0.15 \
                --commission-max-rate=0.20 \
                --commission-max-change-rate=0.1 \
                --min-self-delegation=1 \
                --gas-adjustment 1.5 \
                --from="$WALLET_ADDRESS" \
                --fees=1000uself \
                -y
            if [ $? -eq 0 ]; then
                echo -e "${GREEN}Doğrulayıcı oluşturma başarılı. Tebrikler!${NC}"
            else
                echo -e "${RED}Doğrulayıcı oluşturma başarısız oldu. Lütfen girdilerinizi kontrol edin ve tekrar deneyin.${NC}"
            fi
        else
            echo -e "${RED}Düğümünüz hala senkronize oluyor. Lütfen düğüm senkronize olduktan sonra tekrar deneyin.${NC}"
        fi
        ;;
    *)
        echo -e "${RED}Geçersiz seçenek, lütfen tekrar deneyin.${NC}"
        ;;
esac
