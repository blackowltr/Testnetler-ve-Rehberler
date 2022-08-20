#!/bin/sh

echo -e ''
echo -e '\e[40m\e[92m'
echo ' ██████╗ ██╗      █████╗  ██████╗██╗  ██╗ ██████╗ ██╗    ██╗██╗'     
echo ' ██╔══██╗██║     ██╔══██╗██╔════╝██║ ██╔╝██╔═══██╗██║    ██║██║'
echo ' ██████╔╝██║     ███████║██║     █████╔╝ ██║   ██║██║ █╗ ██║██║'    
echo ' ██╔══██╗██║     ██╔══██║██║     ██╔═██╗ ██║   ██║██║███╗██║██║'
echo ' ██████╔╝███████╗██║  ██║╚██████╗██║  ██╗╚██████╔╝╚███╔███╔╝███████╗'
echo ' ╚═════╝ ╚══════╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝ ╚═════╝  ╚══╝╚══╝ ╚══════╝'
echo -e '\e[0m'
echo ''

###############################################################################
#
#                             kurulum.sh
#
# Bu, Bitcoin Core tabanlı Bitcoin tam düğümü için yükleme komut dosyasıdır.
# Bu komut dosyası, düğümünüzü ağdaki diğer düğümler tarafından otomatik olarak erişilebilir hale getirmeye çalışır. 
# Bu, yönlendiricinizde 8333 numaralı bağlantı noktasını açmak için uPnP kullanılarak yapılır.
# 8333 numaralı bağlantı noktasına gelen bağlantıları kabul etmek ve bağlantıları kendi cihazınıza yönlendirmek için yerel ağınızın içinde çalışan düğüm.
#
# Güvenlik nedeniyle, cüzdan işlevi varsayılan olarak etkin değildir.
#
# Desteklenen işletim sistemleri: Linux, Mac OS X, BSD, Windows (Windows Subsystem for Linux)
# Desteklenen Platformlar: x86, x86_64, ARM
#
# Usage:
#   Open your terminal and type:
#
#     curl https://bitnodes.io/install-full-node.sh | sh
#
# Bitcoin Core, bitcoin.org tarafından sağlanan ikili dosyalar kullanılarak kurulacak.
#
# Sisteminiz için ikili dosyalar mevcut değilse, yükleyici kaynaktan Bitcoin Core oluşturmaya ve yüklemeye çalışır.
#
# Tüm dosyalar $HOME/bitcoin-core dizinine kurulacaktır. Kurulumdan sonra bu dizinin yerleşimi aşağıda gösterilmiştir:
#
# Kaynak dosyası:
#   $HOME/bitcoin-core/bitcoin/
#
# Binary:
#   $HOME/bitcoin-core/bin/
#
# Konfigürasyon dosyası:
#   $HOME/bitcoin-core/.bitcoin/bitcoin.conf
#
# Blockchain data dosyaları:
#   $HOME/bitcoin-core/.bitcoin/blocks
#   $HOME/bitcoin-core/.bitcoin/chainstate
#
# If you get any problems, try reinstalling.
#
###############################################################################

REPO_URL="https://github.com/bitcoin/bitcoin.git"

# See https://github.com/bitcoin/bitcoin/tags for latest version.
VERSION=23.0

TARGET_DIR=$HOME/bitcoin-core
PORT=8333

BUILD=0
UNINSTALL=0

BLUE='\033[94m'
GREEN='\033[32;1m'
YELLOW='\033[33;1m'
RED='\033[91;1m'
RESET='\033[0m'

ARCH=$(uname -m)
SYSTEM=$(uname -s)
MAKE="make"
if [ "$SYSTEM" = "FreeBSD" ]; then
    MAKE="gmake"
fi
SUDO=""

usage() {
    cat <<EOF

Bu, Bitcoin Core'a dayalı Bitcoin tam düğümü için yükleme komut dosyasıdır.

Usage: $0 [-h] [-v <version>] [-t <target_directory>] [-p <port>] [-b] [-u]

-h
    Print usage.

-v <version>
    Version of Bitcoin Core to install.
    Default: $VERSION

-t <target_directory>
    Target directory for source files and binaries.
    Default: $HOME/bitcoin-core

-p <port>
    Bitcoin Core listening port.
    Default: $PORT

-b
    Build and install Bitcoin Core from source.
    Default: $BUILD

-u
    Uninstall Bitcoin Core.

EOF
}

print_info() {
    printf "$BLUE$1$RESET\n"
}

print_success() {
    printf "$GREEN$1$RESET\n"
    sleep 1
}

print_warning() {
    printf "$YELLOW$1$RESET\n"
}

print_error() {
    printf "$RED$1$RESET\n"
    sleep 1
}

print_start() {
    print_info "Başlangıç ​​tarihi: $(date)"
}

print_end() {
    print_info "\nBitiş Tarihi: $(date)"
}

print_readme() {
    cat <<EOF

# Okuyunuz

Bitcoin Core'u durdurmak için:

    cd $TARGET_DIR/bin && ./stop.sh

Bitcoin Core'u yeniden başlatmak için:

    cd $TARGET_DIR/bin && ./start.sh

bitcoin-cli programını kullanmak için:

    cd $TARGET_DIR/bin && ./bitcoin-cli -conf=$TARGET_DIR/.bitcoin/bitcoin.conf getnetworkinfo

Bitcoin Core günlük dosyasını (log) görüntülemek için:

    tail -f $TARGET_DIR/.bitcoin/debug.log

Bitcoin Core'u kaldırmak için:

    ./install-full-node.sh -u

Yükleme komut dosyasının yerel bir kopyası olmadan Bitcoin Core'u kaldırmak için:

    sh <( curl -Ls https://bitnodes.io/install-full-node.sh ) -u

EOF
}

program_exists() {
    type "$1" > /dev/null 2>&1
    return $?
}

create_target_dir() {
    if [ ! -d "$TARGET_DIR" ]; then
        print_info "\nHedef dizin oluşturuluyor: $TARGET_DIR"
        mkdir -p $TARGET_DIR
    fi
}

init_system_install() {
    if [ $(id -u) -ne 0 ]; then
        if program_exists "sudo"; then
            SUDO="sudo"
            print_info "\nGerekli sistem paketlerini yükleniyor.."
        else
            print_error "\nsistem paketlerini kurmak için sudo programı gereklidir. Lütfen sudo'yu root olarak kurun ve bu scripti normal kullanıcı olarak yeniden çalıştırın."
            exit 1
        fi
    fi
}

install_miniupnpc() {
    print_info "Miniupnpc kaynaktan yükleniyor.."
    rm -rf miniupnpc-2.0 miniupnpc-2.0.tar.gz &&
        wget -q http://miniupnp.free.fr/files/download.php?file=miniupnpc-2.0.tar.gz -O miniupnpc-2.0.tar.gz && \
        tar xzf miniupnpc-2.0.tar.gz && \
        cd miniupnpc-2.0 && \
        $SUDO $MAKE install > build.out 2>&1 && \
        cd .. && \
        rm -rf miniupnpc-2.0 miniupnpc-2.0.tar.gz
}

install_debian_build_dependencies() {
    $SUDO apt-get update
    $SUDO apt-get install -y \
        automake \
        autotools-dev \
        build-essential \
        curl \
        git \
        libboost-all-dev \
        libevent-dev \
        libminiupnpc-dev \
        libssl-dev \
        libtool \
        pkg-config
}

install_fedora_build_dependencies() {
    $SUDO dnf install -y \
        automake \
        boost-devel \
        curl \
        gcc-c++ \
        git \
        libevent-devel \
        libtool \
        miniupnpc-devel \
        openssl-devel
}

install_centos_build_dependencies() {
    $SUDO yum install -y \
        automake \
        boost-devel \
        curl \
        gcc-c++ \
        git \
        libevent-devel \
        libtool \
        openssl-devel
    install_miniupnpc
    echo '/usr/lib' | $SUDO tee /etc/ld.so.conf.d/miniupnpc-x86.conf > /dev/null && $SUDO ldconfig
}

install_archlinux_build_dependencies() {
    $SUDO pacman -S --noconfirm \
        automake \
        boost \
        curl \
        git \
        libevent \
        libtool \
        miniupnpc \
        openssl
}

install_alpine_build_dependencies() {
    $SUDO apk update
    $SUDO apk add \
        autoconf \
        automake \
        boost-dev \
        build-base \
        curl \
        git \
        libevent-dev \
        libtool \
        openssl-dev
    install_miniupnpc
}

install_mac_build_dependencies() {
    if ! program_exists "gcc"; then
        print_info "Açılır pencere göründüğünde, XCode Komut Satırı Araçlarını yüklemek için 'Yükle'yi tıklayın."
        xcode-select --install
    fi

    if ! program_exists "brew"; then
        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi

    brew install \
        --c++11 \
        automake \
        boost \
        libevent \
        libtool \
        miniupnpc \
        openssl \
        pkg-config
}

install_freebsd_build_dependencies() {
    $SUDO pkg install -y \
        autoconf \
        automake \
        boost-libs \
        curl \
        git \
        gmake \
        libevent2 \
        libtool \
        openssl \
        pkgconf \
        wget
    install_miniupnpc
}

install_build_dependencies() {
    init_system_install
    case "$SYSTEM" in
        Linux)
            if program_exists "apt-get"; then
                install_debian_build_dependencies
            elif program_exists "dnf"; then
                install_fedora_build_dependencies
            elif program_exists "yum"; then
                install_centos_build_dependencies
            elif program_exists "pacman"; then
                install_archlinux_build_dependencies
            elif program_exists "apk"; then
                install_alpine_build_dependencies
            else
                print_error "\nÜzgünüz, sisteminiz bu yükleyici tarafından desteklenmiyor."
                exit 1
            fi
            ;;
        Darwin)
            install_mac_build_dependencies
            ;;
        FreeBSD)
            install_freebsd_build_dependencies
            ;;
        *)
            print_error "\nÜzgünüz, sisteminiz bu yükleyici tarafından desteklenmiyor."
            exit 1
            ;;
    esac
}

build_bitcoin_core() {
    cd $TARGET_DIR

    if [ ! -d "$TARGET_DIR/bitcoin" ]; then
        print_info "\nBitcoin Core kaynak dosyalarının indiriliyor.."
        git clone --quiet $REPO_URL
    fi

    # Tek kartlı bilgisayarlarda daha az bellek kullanmak için gcc'yi ayarlayın.
    cxxflags=""
    if [ "$SYSTEM" = "Linux" ]; then
        ram_kb=$(grep MemTotal /proc/meminfo | awk '{print $2}')
        if [ $ram_kb -lt 1500000 ]; then
            cxxflags="--param ggc-min-expand=1 --param ggc-min-heapsize=32768"
        fi
    fi

    print_info "\nBitcoin core oluşturuluyor v$VERSION"
    print_info "Oluşturma çıktısı: $TARGET_DIR/bitcoin/build.out"
    print_info "Bu bir saat veya daha fazla sürebilir."
    rm -f build.out
    cd bitcoin &&
        git fetch > build.out 2>&1 &&
        git checkout "v$VERSION" 1>> build.out 2>&1 &&
        git clean -f -d -x 1>> build.out 2>&1 &&
        ./autogen.sh 1>> build.out 2>&1 &&
        ./configure \
            CXXFLAGS="$cxxflags" \
            --without-gui \
            --with-miniupnpc \
            --disable-wallet \
            --disable-tests \
            --enable-upnp-default \
            1>> build.out 2>&1 &&
        $MAKE 1>> build.out 2>&1

    if [ ! -f "$TARGET_DIR/bitcoin/src/bitcoind" ]; then
        print_error "Yapı hatalı oldu. $TARGET_DIR/bitcoin/build.out"
        exit 1
    fi

    sleep 1

    $TARGET_DIR/bitcoin/src/bitcoind -? > /dev/null
    retcode=$?
    if [ $retcode -ne 1 ]; then
        print_error "Çalıştırılamadı $TARGET_DIR/bitcoin/src/bitcoind. See $TARGET_DIR/bitcoin/build.out"
        exit 1
    fi
}

get_bin_url() {
    url="https://bitcoincore.org/bin/bitcoin-core-$VERSION"
    case "$SYSTEM" in
        Linux)
            if program_exists "apk"; then
                echo ""
            elif [ "$ARCH" = "armv7l" ]; then
                url="$url/bitcoin-$VERSION-arm-linux-gnueabihf.tar.gz"
                echo "$url"
            else
                url="$url/bitcoin-$VERSION-$ARCH-linux-gnu.tar.gz"
                echo "$url"
            fi
            ;;
        Darwin)
            url="$url/bitcoin-$VERSION-osx64.tar.gz"
            echo "$url"
            ;;
        FreeBSD)
            echo ""
            ;;
        *)
            echo ""
            ;;
    esac
}

download_bin() {
    checksum_url="https://bitcoincore.org/bin/bitcoin-core-$VERSION/SHA256SUMS"

    cd $TARGET_DIR

    rm -f bitcoin-$VERSION.tar.gz checksum.asc

    print_info "\nBitcoin core binary indiriliyor.."
    if program_exists "wget"; then
        wget -q "$1" -O bitcoin-$VERSION.tar.gz &&
            wget -q "$checksum_url" -O checksum.asc &&
            mkdir -p bitcoin-$VERSION &&
            tar xzf bitcoin-$VERSION.tar.gz -C bitcoin-$VERSION --strip-components=1
    elif program_exists "curl"; then
        curl -s "$1" -o bitcoin-$VERSION.tar.gz &&
            curl -s "$checksum_url" -o checksum.asc &&
            mkdir -p bitcoin-$VERSION &&
            tar xzf bitcoin-$VERSION.tar.gz -C bitcoin-$VERSION --strip-components=1
    else
        print_error "\nDevam etmek için wget veya curl programı gereklidir. Lütfen wget veya curl'i root olarak kurun ve bu betiği normal kullanıcı olarak yeniden çalıştırın."
        exit 1
    fi

    if program_exists "shasum"; then
        checksum=$(shasum -a 256 bitcoin-$VERSION.tar.gz | awk '{ print $1 }')
        if grep -q "$checksum" checksum.asc; then
            print_success "Sağlama toplamı geçti: bitcoin-$VERSION.tar.gz ($checksum)"
        else
            print_error "Sağlama toplamı geçti: bitcoin-$VERSION.tar.gz ($checksum). Lütfen binary dosyalarını tekrar indirmek ve doğrulamak için bu scripti yeniden çalıştırın."
            exit 1
        fi
    fi

    rm -f bitcoin-$VERSION.tar.gz checksum.asc
}

install_bitcoin_core() {
    cd $TARGET_DIR

    print_info "\nBitcoin core yükleniyor v$VERSION"

    if [ ! -d "$TARGET_DIR/bin" ]; then
        mkdir -p $TARGET_DIR/bin
    fi

    if [ ! -d "$TARGET_DIR/.bitcoin" ]; then
        mkdir -p $TARGET_DIR/.bitcoin
    fi

    if [ "$SYSTEM" = "Darwin" ]; then
        if [ ! -e "$HOME/Library/Application Support/Bitcoin" ]; then
            ln -s $TARGET_DIR/.bitcoin "$HOME/Library/Application Support/Bitcoin"
        fi
    else
        if [ ! -e "$HOME/.bitcoin" ]; then
            ln -s $TARGET_DIR/.bitcoin $HOME/.bitcoin
        fi
    fi

    if [ -f "$TARGET_DIR/bitcoin/src/bitcoind" ]; then
        # Install compiled binaries.
        cp "$TARGET_DIR/bitcoin/src/bitcoind" "$TARGET_DIR/bin/" &&
            cp "$TARGET_DIR/bitcoin/src/bitcoin-cli" "$TARGET_DIR/bin/" &&
            print_success "Bitcoin Core v$VERSION (compiled) Yükleme işlemi başarılı!"
    elif [ -f "$TARGET_DIR/bitcoin-$VERSION/bin/bitcoind" ]; then
        # Install downloaded binaries.
        cp "$TARGET_DIR/bitcoin-$VERSION/bin/bitcoind" "$TARGET_DIR/bin/" &&
            cp "$TARGET_DIR/bitcoin-$VERSION/bin/bitcoin-cli" "$TARGET_DIR/bin/" &&
                rm -rf "$TARGET_DIR/bitcoin-$VERSION"
            print_success "Bitcoin Core v$VERSION (binaries) Yükleme işlemi başarılı!"
    else
        print_error "Yüklenecek dosyaları bulamıyor."
        exit 1
    fi

    cat > $TARGET_DIR/.bitcoin/bitcoin.conf <<EOF
### IPv4/IPv6 mode ###
# This mode requires uPnP feature on your router to allow Bitcoin Core to accept incoming connections.
bind=0.0.0.0
upnp=1

### Tor mode ###
# This mode requires tor (https://www.torproject.org/download/) to be running at the proxy address below.
# No configuration is needed on your router to allow Bitcoin Core to accept incoming connections.
#proxy=127.0.0.1:9050
#bind=127.0.0.1
#onlynet=onion

listen=1
port=$PORT
maxconnections=64

dbcache=64
par=2
checkblocks=24
checklevel=0

disablewallet=1

rpccookiefile=$TARGET_DIR/.bitcoin/.cookie
rpcbind=127.0.0.1
rpcport=8332
rpcallowip=127.0.0.1
EOF
    chmod go-rw $TARGET_DIR/.bitcoin/bitcoin.conf

    cat > $TARGET_DIR/bin/start.sh <<EOF
#!/bin/sh
if [ -f $TARGET_DIR/bin/bitcoind ]; then
    $TARGET_DIR/bin/bitcoind -conf=$TARGET_DIR/.bitcoin/bitcoin.conf -datadir=$TARGET_DIR/.bitcoin -daemon
fi
EOF
    chmod ugo+x $TARGET_DIR/bin/start.sh

    cat > $TARGET_DIR/bin/stop.sh <<EOF
#!/bin/sh
if [ -f $TARGET_DIR/.bitcoin/bitcoind.pid ]; then
    kill \$(cat $TARGET_DIR/.bitcoin/bitcoind.pid)
fi
EOF
    chmod ugo+x $TARGET_DIR/bin/stop.sh
}

start_bitcoin_core() {
    if [ ! -f $TARGET_DIR/.bitcoin/bitcoind.pid ]; then
        print_info "\nBitcoin Core Başlatılıyor.."
        cd $TARGET_DIR/bin && ./start.sh

        timer=0
        until [ -f $TARGET_DIR/.bitcoin/bitcoind.pid ] || [ $timer -eq 5 ]; do
            timer=$((timer + 1))
            sleep $timer
        done

        if [ -f $TARGET_DIR/.bitcoin/bitcoind.pid ]; then
            print_success "Bitcoin Core Çalışıyor!"
        else
            print_error "Bitcoin Core başlatılamadı."
            exit 1
        fi
    fi
}

stop_bitcoin_core() {
    if [ -f $TARGET_DIR/.bitcoin/bitcoind.pid ]; then
        print_info "\nBitcoin Core Durduruluyor.."
        cd $TARGET_DIR/bin && ./stop.sh

        timer=0
        until [ ! -f $TARGET_DIR/.bitcoin/bitcoind.pid ] || [ $timer -eq 120 ]; do
            timer=$((timer + 1))
            sleep $timer
        done

        if [ ! -f $TARGET_DIR/.bitcoin/bitcoind.pid ]; then
            print_success "Bitcoin core durduruldu."
        else
            print_error "Bitcoin Core durdurulamadı."
            exit 1
        fi
    fi
}

check_bitcoin_core() {
    if [ -f $TARGET_DIR/.bitcoin/bitcoind.pid ]; then
        if [ -f $TARGET_DIR/bin/bitcoin-cli ]; then
            print_info "\nBitcoin Core Kontrol Ediliyor.."
            sleep 5
            $TARGET_DIR/bin/bitcoin-cli -conf=$TARGET_DIR/.bitcoin/bitcoin.conf -datadir=$TARGET_DIR/.bitcoin getnetworkinfo
        fi

        reachable=$(curl -I https://bitnodes.io/api/v1/nodes/me-$PORT/ 2> /dev/null | head -n 1 | cut -d ' ' -f2)
        if [ $reachable -eq 200 ]; then
            print_success "Bitcoin Core, limanda gelen bağlantıları kabul ediyor $PORT!"
        else
            print_warning "Bitcoin Core, limanda gelen bağlantıları kabul etmiyor $PORT. Yönlendiricinizde Bağlantı noktası iletmeyi yapılandırmanız gerekebilir (https://bitcoin.org/en/full-node#port-forwarding)"
        fi
    fi
}

uninstall_bitcoin_core() {
    stop_bitcoin_core

    if [ -d "$TARGET_DIR" ]; then
        print_info "\nBitcoin Core'u Kaldırılıyor.."
        rm -rf $TARGET_DIR

        # Remove stale symlink.
        if [ "$SYSTEM" = "Darwin" ]; then
            if [ -L "$HOME/Library/Application Support/Bitcoin" ] && [ ! -d "$HOME/Library/Application Support/Bitcoin" ]; then
                rm "$HOME/Library/Application Support/Bitcoin"
            fi
        else
            if [ -L $HOME/.bitcoin ] && [ ! -d $HOME/.bitcoin ]; then
                rm $HOME/.bitcoin
            fi
        fi

        if [ ! -d "$TARGET_DIR" ]; then
            print_success "Bitcoin Core başarıyla kaldırıldı!"
        else
            print_error "Kaldırma başarısız oldu. Bitcoin Core hala çalışıyor mu?"
            exit 1
        fi
    else
        print_error "Bitcoin Core yüklü değil."
    fi
}

while getopts ":v:t:p:bu" opt
do
    case "$opt" in
        v)
            VERSION=${OPTARG}
            ;;
        t)
            TARGET_DIR=${OPTARG}
            ;;
        p)
            PORT=${OPTARG}
            ;;
        b)
            BUILD=1
            ;;
        u)
            UNINSTALL=1
            ;;
        h)
            usage
            exit 0
            ;;
        ?)
            usage >& 2
            exit 1
            ;;
    esac
done

WELCOME_TEXT=$(cat <<EOF

Hoş Geldiniz!

Bitcoin Core tabanlı bir Bitcoin tam düğümü kurmak üzeresiniz v$VERSION.

Tüm dosyalar altına yüklenecek $TARGET_DIR directory.

Düğümünüz, yönlendiricinizdeki uPnP özelliğini kullanarak Bitcoin ağındaki diğer düğümlerden gelen bağlantıları kabul edecek şekilde yapılandırılacaktır.
For security reason, wallet functionality is not enabled by default.

Yüklemeden sonra, düğümünüzün bir dosyayı indirmesi birkaç saat sürebilir.
blok zincirinin tam kopyası.

Bitcoin Core'u daha sonra kaldırmak isterseniz, bu betiği indirebilir ve
"sh install-full-node.sh -u" komutunu çalıştırın veya bu kısayol komutunu çalıştırın
"sh <( curl -Ls https://bitnodes.io/install-full-node.sh ) -u"

EOF
)

print_start

if [ $UNINSTALL -eq 1 ]; then
    echo
    read -p "UYARI: Bu, Bitcoin Core'u durduracak ve sisteminizden kaldıracaktır. Kaldırılsın mı? (y/n) " answer
    if [ "$answer" = "y" ]; then
        uninstall_bitcoin_core
    fi
else
    echo "$WELCOME_TEXT"
    if [ -t 0 ]; then
        # Prompt for confirmation when invoked in tty.
        echo
        read -p "Install? (y/n) " answer
    else
        # Continue installation when invoked via pipe, e.g. curl .. | sh
        answer="y"
        echo
        echo "15 saniye içinde kuruluma başlıyor.."
        sleep 15
    fi
    if [ "$answer" = "y" ]; then
        if [ "$BUILD" -eq 0 ]; then
            bin_url=$(get_bin_url)
        else
            bin_url=""
        fi
        stop_bitcoin_core
        create_target_dir
        if [ "$bin_url" != "" ]; then
            download_bin "$bin_url"
        else
            install_build_dependencies && build_bitcoin_core
        fi
        install_bitcoin_core && start_bitcoin_core && check_bitcoin_core
        print_readme > $TARGET_DIR/README.md
        cat $TARGET_DIR/README.md
        print_success "Bu ilk kurulumunuzsa, Bitcoin Core'un blok zincirinin tam bir kopyasını indirmesi birkaç saat/gün sürebilir."
        print_success "\nTebrikler, Yükleme tamamlandı!"
    fi
fi

print_end
