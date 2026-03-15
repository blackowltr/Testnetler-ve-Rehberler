# 🖥️ Hetzner Sunucusuna Ubuntu Kurulum Rehberi

> Hetzner'da satın aldığın bir dedicated sunucuya Ubuntu kurmak için adım adım rehber.

---

## ⚠️ Başlamadan Önce

- Bu rehberdeki işlemler **root** yetkisiyle yapılır, dikkatli ol.
- RAID ve disk ayarları **geri alınamaz** — iki kez kontrol et.
- FTP yerine **SFTP** kullan (SSH üzerinden çalışır, daha güvenli).

---

## 📋 Adım Adım Kurulum

### 1. Hetzner Paneline Giriş

Hetzner Robot paneline gir ve satın aldığın sunucuyu seç.

---

### 2. Rescue (Kurtarma) Sistemini Aktifleştir

- Sunucu ayarlarında **Rescue** sekmesine git.
- Rescue sistemini aktifleştir.
- Sana verilen **şifreyi kaydet** — ilk bağlantıda lazım olacak.

---

### 3. Sunucuyu Yeniden Başlat

Sunucuyu kapat ve tekrar aç:

- **"Press power button of server"** → **Send** (kapat)
- Aynı şekilde tekrar aç.

---

### 4. SSH ile Bağlan

```bash
ssh root@SUNUCU_IP_ADRESI
```

Rescue şifresiyle giriş yap.

---

### 5. `installimage` Scriptini Çalıştır

```bash
installimage
```

Bu script, Hetzner'ın geliştirdiği kurulum aracıdır.

---

### 6. Ubuntu'yu Seç

- Listeden **Ubuntu** seç.
- Sürüm olarak **Ubuntu 22.04 (Jammy)** veya **24.04 (Noble)** seç.  
  > ⚠️ Ubuntu 20.04 artık destek dışı (EOL Nisan 2025), kullanma.

---

### 7. RAID Ayarlarını Yap

Açılan config dosyasında şu satırları bul ve ayarla:

```
SWRAID 1
SWRAIDLEVEL 1
```

> 💡 **RAID Seviyesi Seçimi:**
> - `SWRAIDLEVEL 0` → Hız öncelikli, **yedekleme YOK** (bir disk bozulursa her şey gider)
> - `SWRAIDLEVEL 1` → Yansılama, **veri güvenliği var** (önerilen)

---

### 8. Partition Ayarlarını Düzenle

Config dosyasında `PART /boot` ve `lvm` satırlarının başındaki `#` işaretlerini kaldır.

Örnek yapı:

```
PART /boot ext3 512M
PART lvm vg0 all

LV vg0 root / ext4 50G
LV vg0 swap swap swap 8G
LV vg0 home /home ext4 all
```

> Disk boyutlarını sunucuna göre ayarla.

---

### 9. Kaydet ve Kur

- `F10` tuşuna bas → **Yes** seç.
- Kurulum tamamlanınca sunucu otomatik yeniden başlar.

---

### 10. Sunucuyu Yeniden Başlat

```bash
reboot
```

---

### 11. Disk Kurulumunu Doğrula

Sunucu açıldıktan sonra SSH ile bağlan ve kontrol et:

```bash
df -h          # Disk kullanımını gösterir
lsblk          # Disk yapısını gösterir
cat /proc/mdstat  # RAID durumunu gösterir
```

---

### 12. Sistemi Güncelle

```bash
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install software-properties-common
sudo add-apt-repository universe
```

---

### 13. DNS Ayarla

Ubuntu'da `/etc/resolv.conf` doğrudan düzenlenmez — sistem yeniden başlayınca değişiklikler silinir. Doğru yol:

```bash
sudo nano /etc/systemd/resolved.conf
```

Şu satırları bul ve düzenle:

```ini
[Resolve]
DNS=8.8.8.8 8.8.4.4
```

Kaydet ve servisi yeniden başlat:

```bash
sudo systemctl restart systemd-resolved
```

---

### 14. Güvenlik Duvarını Kur ve Ayarla

```bash
sudo apt-get install ufw
```

Temel kuralları ekle:

```bash
sudo ufw default deny incoming      # Varsayılan: gelen trafiği engelle
sudo ufw default allow outgoing     # Varsayılan: giden trafiğe izin ver

sudo ufw allow ssh                  # SSH (22)
sudo ufw allow 22/tcp
sudo ufw allow 2222/tcp             # Alternatif SSH portu

sudo ufw enable                     # Güvenlik duvarını aktifleştir
```

Durumu kontrol et:

```bash
sudo ufw status verbose
```

> ⚠️ **FTP kullanma!** Şifreler açık metin olarak iletilir. Bunun yerine **SFTP** kullan (SSH ile gelir, ekstra kurulum gerekmez).

---

### 15. Root Şifresini Değiştir (İsteğe Bağlı)

```bash
passwd root
```

---

### 16. Normal Kullanıcı Oluştur (Önerilen)

Root ile her zaman çalışmak güvenli değil. Kendine bir kullanıcı oluştur:

```bash
adduser kullanici_adi
usermod -aG sudo kullanici_adi
```

Artık bu kullanıcıyla bağlanabilir, gerektiğinde `sudo` kullanabilirsin.

---

### 17. Son Reboot

```bash
reboot
```

---

## ✅ Kurulum Sonrası Kontrol Listesi

- [ ] Sunucuya SSH ile bağlanabiliyor musun?
- [ ] `df -h` çıktısında diskler doğru görünüyor mu?
- [ ] `cat /proc/mdstat` RAID'in aktif olduğunu gösteriyor mu?
- [ ] `sudo ufw status` doğru portları gösteriyor mu?
- [ ] DNS çalışıyor mu? (`ping google.com`)

---

## 🔒 Güvenlik Özeti

| Konu | Öneri |
|---|---|
| Uzaktan erişim | SSH kullan, FTP kullanma |
| Dosya transferi | SFTP kullan |
| Kullanıcı | Root yerine sudo kullanıcısı oluştur |
| RAID | Veri güvenliği için RAID 1 tercih et |
| DNS | `systemd-resolved` ile yönet |
