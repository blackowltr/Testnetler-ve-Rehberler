# Avail Node Kurulumu

![Avail Rehberi](https://github.com/brsbrc/Testnetler-ve-Rehberler/assets/107190154/236f1794-4fe0-4698-a60a-37acddb5a361)

## Donanım Gereksinimleri:

**İşlemci (CPU):** 2 çekirdekli işlemci (2 CPU)

**Bellek (RAM):** En az 4 GB RAM

**Depolama (Disk):** 100 GB boş depolama alanı

**İşletim Sistemi:** Ubuntu 20.04 ve sonraki sürümler

# Kurulum
> Kurulumu screen için de başlatmanızı öneririm burada o şekilde komutları ayarladım. Kolay gelsin.
```
sudo apt install screen
screen -S avail
wget https://raw.githubusercontent.com/brsbrc/Testnetler-ve-Rehberler/main/Avail/avail.sh && chmod +x avail.sh && ./avail.sh
```

## Servis dosyası oluşturalım.

```
sudo touch /etc/systemd/system/availd.service
```
```
sudo nano /etc/systemd/system/availd.service
```

## Moniker adınızı düzenlemeyi unutmayın.

```
[Unit]
Description=Avail Validator
After=network.target
StartLimitIntervalSec=0
[Service]
User=root
ExecStart= /root/avail/target/release/data-avail --base-path `pwd`/data --chain kate --name MONIKERADINIZ
Restart=always
RestartSec=120
[Install]
WantedBy=multi-user.target
```
```
sudo systemctl enable availd.service
```
```
sudo systemctl start availd.service
```
```
sudo systemctl status availd.service
```

### Log kontrol: 
```
journalctl -f -u availd
```

### Kurulum Sonrası Kontrol ve Form Bağlantısı

**Telemetry:** https://telemetry.avail.tools/

**Form:** https://docs.google.com/forms/d/e/1FAIpQLScvgXjSUmwPpUxf1s-MR2C2o5V79TSoud1dLPKVgeLiLFuyGQ/viewform
