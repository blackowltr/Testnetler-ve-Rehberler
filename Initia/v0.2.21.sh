#!/bin/bash

# Ana dizine geç
cd $HOME

# 'initia' dizinini varsa sil
rm -rf initia

# Depoyu klonla
git clone https://github.com/initia-labs/initia.git

# Klonlanan depo dizinine geç
cd initia

# Belirtilen versiyonu seç
git checkout v0.2.21

# Projeyi derle
make build

# Derlenen 'initiad' ikili dosyasını uygun yere taşı
sudo mv $HOME/initia/build/initiad $(which initiad)

# initiad versiyonunu kontrol et
initiad_version=$(initiad version)

# Eğer versiyon v0.2.15 ise
if [[ $initiad_version == *"v0.2.15"* ]]; then
    echo "Güncelleme başarılı"
    # 'initiad' servisini yeniden başlat ve logları takip et
    sudo systemctl restart initiad && sudo journalctl -u initiad -f
else
    echo "Güncelleme başarısız veya zaten mevcut durumda."
    echo "Mevcut versiyon: $initiad_version"
fi
