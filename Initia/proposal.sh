#!/bin/bash

# Kullanıcıdan teklif numarasını ve cüzdan adını al
read -p "Lütfen teklif numarasını girin (sadece sayılar): " PROPOSAL
# Sadece sayı girişini kontrol et
if ! [[ $PROPOSAL =~ ^[0-9]+$ ]]; then
    echo "Geçersiz giriş. Teklif numarası sadece sayılar içerebilir."
    exit 1
fi

read -p "Lütfen cüzdan adını girin: " WALLET

# Kullanıcıya seçenekleri göster ve oy al
echo "Lütfen aşağıdaki seçeneklerden birini seçin:"
echo "1- yes"
echo "2- no"
echo "3- veto"
echo "4- abstain"
read -p "Seçiminizi yapın: " CHOICE

# Kullanıcının seçimine göre oy değişkenini belirle
case $CHOICE in
    1)
        VOTE="yes"
        ;;
    2)
        VOTE="no"
        ;;
    3)
        VOTE="no_with_veto"
        ;;
    4)
        VOTE="abstain"
        ;;
    *)
        echo "Geçersiz seçim. Lütfen geçerli bir seçim yapın."
        exit 1
        ;;
esac

# Oy kullanma işlemini gerçekleştir
TX_RESULT=$(initiad tx gov vote $PROPOSAL $VOTE --from $WALLET --chain-id initiation-1 --gas-prices 0.15uinit --gas-adjustment 1.5 --gas auto -y)

# TX_RESULT içerisindeki "txhash" bilgisini kontrol et
if [[ $TX_RESULT =~ "txhash" ]]; then
    echo "Oylama başarıyla gerçekleştirildi. Lütfen X'te beni takip edin: https://x.com/brsbtc"
else
    echo "Oylama işlemi sırasında bir hata oluştu. Lütfen yeniden deneyin."
fi
