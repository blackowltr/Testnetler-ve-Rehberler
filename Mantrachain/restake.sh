#!/bin/bash

read -p "Mantrachain Valoper Adresinizi yazın: " MANTRACHAIN_VALOPER_ADRES
read -p "Mantrachain Cüzdan Adresinizi yazın: " MANTRACHAIN_CUZDAN_ADRES
read -p "Cüzdan adınızı yazın: " CUZDAN

for (( ;; )); do
	echo -e "\033[0;32mReward topluyor!\033[0m"
	mantrachaind tx distribution withdraw-rewards $MANTRACHAIN_VALOPER_ADRES --from=$CUZDAN --commission --chain-id=mantrachain-1 --fees=300uaum --yes
	echo -e "\033[0;32mBakiye sorgulamadan önce 45 saniye bekleniyor\033[0m"
	sleep 45
	MIKTAR=$(mantrachaind query bank balances $MANTRACHAIN_CUZDAN_ADRES | grep amount | awk '{split($0,a,"\""); print a[2]}')
	MIKTAR=$(($MIKTAR - 800))
	MIKTAR_STRING=$MIKTAR"uaum"
	echo -e "Toplam bakiyeniz: \033[0;32m$MIKTAR_STRING\033[0m"
	mantrachaind tx staking delegate $MANTRACHAIN_VALOPER_ADRES $MIKTAR_STRING --from $CUZDAN --chain-id mantrachain-1 --fees=300uaum --yes
	echo -e "\033[0;32m$MIKTAR_STRING stake edildi! 10800 saniye sonra yeniden başlatılacak!\033[0m"
	sleep 10800
done
