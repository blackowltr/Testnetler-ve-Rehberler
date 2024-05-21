#!/bin/bash

# Kullanıcıdan teklif numarasını ve cüzdan adını al
read -p "Lütfen teklif numarasını girin: " PROPOSAL
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
initiad tx gov vote $PROPOSAL $VOTE --from $WALLET --chain-id initiation-1 --gas-prices 0.15uinit --gas-adjustment 1.5 --gas auto -y
