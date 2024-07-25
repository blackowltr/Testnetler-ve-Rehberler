#!/bin/bash

# Günlük dosyası oluşturma
LOGFILE="/tmp/sonaric_install.log"
exec > >(tee -i "$LOGFILE")
exec 2>&1

# Ana fonksiyon
main() {
    selection_screen
    case "$user_choice" in
        1)
            perform_installation
            ;;
        2)
            perform_backup
            ;;
        *)
            printf '\e[31mGeçersiz seçim. Lütfen 1 veya 2 seçin.\e[0m\n' >&2
            exit 1
            ;;
    esac
}

# Seçim ekranı
selection_screen() {
    printf '\e[34mSonaric Node Kurulum Rehberi\'ne Hoş Geldiniz!\e[0m\n'
    printf '\e[34mLütfen yapmak istediğiniz işlemi seçin:\e[0m\n'
    printf '\e[34m1) Kurulum\e[0m\n'
    printf '\e[34m2) Kurulum Sonrası Yedekleme\e[0m\n'
    read -rp "Seçiminiz (1/2): " user_choice
}

# Kurulum işlemi
perform_installation() {
    print_welcome_message
    display_system_requirements
    system_update_and_install_packages
    download_and_run_sonaric_script
    check_node_installation
    run_gui
    print_closing_message
}

# Yedekleme işlemi
perform_backup() {
    backup_server_info
    prompt_moniker_change
}

# Hoş geldiniz mesajı
print_welcome_message() {
    printf '\n\e[40m\e[92m'
    printf ' ██████╗ ██╗      █████╗  ██████╗██╗  ██╗ ██████╗ ██╗    ██╗██╗\n'
    printf ' ██╔══██╗██║     ██╔══██╗██╔════╝██║ ██╔╝██╔═══██╗██║    ██║██║\n'
    printf ' ██████╔╝██║     ███████║██║     █████╔╝ ██║   ██║██║ █╗ ██║██║\n'
    printf ' ██╔══██╗██║     ██╔══██║██║     ██╔═██╗ ██║   ██║██║███╗██║██║\n'
    printf ' ██████╔╝███████╗██║  ██║╚██████╗██║  ██╗╚██████╔╝╚███╔███╔╝███████╗\n'
    printf ' ╚═════╝ ╚══════╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝ ╚═════╝  ╚══╝╚══╝ ╚══════╝\n'
    printf '\e[0m\n\n'
    printf '\e[33mSonaric Node Kurulum Rehberi\'ne Hoş Geldiniz!\e[0m\n\n'
}

# Sistem gereksinimlerini gösterme
display_system_requirements() {
    printf '\e[34mGerekli Sistem Donanımı\e[0m\n'
    printf '\e[34m| Bileşenler   | Minimum Gereksinimler |\e[0m\n'
    printf '\e[34m|--------------|-----------------------|\e[0m\n'
    printf '\e[34m| CPU          | 2+                    |\e[0m\n'
    printf '\e[34m| RAM          | 4+ GB                 |\e[0m\n'
    printf '\e[34m| Depolama     | 20 GB SSD             |\e[0m\n'
    printf '\e[34m| İşletim Sistemi | Ubuntu 22            |\e[0m\n'
    printf '\e[0m\n'
}

# Sistem güncellemesi ve paket kurulumu
system_update_and_install_packages() {
    printf '\e[34mSistem Güncellemesi ve Paket Kurulumu\e[0m\n'
    if ! sudo apt update && sudo apt upgrade -y; then
        printf '\e[31mSistem güncellemesi başarısız oldu. Lütfen tekrar deneyin.\e[0m\n' >&2
        exit 1
    fi
    printf '\e[32mSistem güncellemesi başarıyla tamamlandı.\e[0m\n'

    if ! sudo apt install curl git jq build-essential gcc unzip wget lz4 -y; then
        printf '\e[31mGerekli paketlerin kurulumu başarısız oldu. Lütfen tekrar deneyin.\e[0m\n' >&2
        exit 1
    fi
    printf '\e[32mGerekli paketler başarıyla kuruldu.\e[0m\n'
}

# Sonaric kurulum scriptini indirme ve çalıştırma
download_and_run_sonaric_script() {
    printf '\e[34mSonaric Kurulum Scriptini İndirme ve Çalıştırma\e[0m\n'
    if ! wget https://raw.githubusercontent.com/Testnetnodes/Sonaric-Network/main/sonaric.sh; then
        printf '\e[31mSonaric kurulum scripti indirilemedi. Lütfen tekrar deneyin.\e[0m\n' >&2
        exit 1
    fi
    chmod +x sonaric.sh
    if ! ./sonaric.sh; then
        printf '\e[31mSonaric kurulum scripti çalıştırılamadı. Lütfen tekrar deneyin.\e[0m\n' >&2
        exit 1
    fi
    printf '\e[32mSonaric kurulum scripti başarıyla çalıştırıldı.\e[0m\n'
}

# Node'un başarıyla kurulduğunu kontrol etme
check_node_installation() {
    printf '\e[34mNode Kurulumunu Kontrol Etme\e[0m\n'
    if ! sonaric node-info; then
        printf '\e[31mNode kurulumu kontrolü başarısız oldu. Lütfen tekrar deneyin.\e[0m\n' >&2
        exit 1
    fi
    printf '\e[32mNode kurulumu başarıyla kontrol edildi.\e[0m\n'
}

# GUI çalıştırma
run_gui() {
    printf '\e[34mGUI\'yi Çalıştırma\e[0m\n'
    local ip
    ip=$(wget -qO- eth0.me)
    if [[ -z "$ip" ]]; then
        printf '\e[31mIP adresi alınamadı. Lütfen tekrar deneyin.\e[0m\n' >&2
        exit 1
    fi
    printf '\e[33mDevam etmek için lütfen sunucu şifrenizi girin.\e[0m\n'
    if ! ssh -L 127.0.0.1:44003:127.0.0.1:44003 -L 127.0.0.1:44004:127.0.0.1:44004 -L 127.0.0.1:44005:127.0.0.1:44005 -L 127.0.0.1:44006:127.0.0.1:44006 root@"$ip"; then
        printf '\e[31mGUI çalıştırılamadı. Lütfen tekrar deneyin.\e[0m\n' >&2
        exit 1
    fi
    printf '\e[32mGUI başarıyla çalıştırıldı.\e[0m\n'
}

# Kapanış mesajı
print_closing_message() {
    printf '\e[32mEğer herhangi bir sorunla karşılaşırsanız, lütfen benimle iletişime geçin ve beni X üzerinde takip etmeyi unutmayın: https://x.com/brsbtc\e[0m\n'
}

# Sunucu bilgilerini yedekleme
backup_server_info() {
    printf '\e[34mSunucu Bilgilerini Yedekleme\e[0m\n'
    if ! sonaric identity-export -o mysonaric.identity; then
        printf '\e[31mSunucu bilgilerini yedekleme başarısız oldu. Lütfen tekrar deneyin.\e[0m\n' >&2
        exit 1
    fi
    printf '\e[32mSunucu bilgileri başarıyla yedeklendi.\e[0m\n'
}

# Kullanıcıya Moniker ismini değiştirmek isteyip istemediğini sorma
prompt_moniker_change() {
    printf '\e[34mMoniker ismini değiştirmek ister misiniz? (y/n)\e[0m\n'
    read -rp "Cevabınız: " change_moniker

    if [[ "$change_moniker" == "y" ]]; then
        if ! sonaric node-rename; then
            printf '\e[31mMoniker ismini değiştirme başarısız oldu. Lütfen tekrar deneyin.\e[0m\n' >&2
            exit 1
        fi
        printf '\e[32mMoniker ismi başarıyla değiştirildi.\e[0m\n'
    fi
}

main
