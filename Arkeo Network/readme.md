# Arkeo Node Kurulum Rehberi

![adsadad](https://github.com/brsbrc/Testnetler-ve-Rehberler/assets/107190154/a04a94b7-9afe-43e0-bcc2-5e842ccc5189)

## Sistemi Güncelle ve Gerekli Araçları Yükle

```bash
sudo apt update

sudo apt-get install git curl build-essential make jq gcc snapd chrony lz4 tmux unzip bc -y
```

## Go'yu Yükle
```bash
rm -rf $HOME/go
sudo rm -rf /usr/local/go
cd $HOME
curl https://dl.google.com/go/go1.20.5.linux-amd64.tar.gz | sudo tar -C /usr/local -zxvf -
cat <<'EOF' >>$HOME/.profile
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export GO111MODULE=on
export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin
EOF
source $HOME/.profile
go version
```

## Node'u Yükle
```bash
cd $HOME

mkdir -p /root/go/bin/

wget https://ss-t.arkeo.nodestake.top/arkeod

chmod +x arkeod

mv arkeod /root/go/bin/

arkeod version
```

## Node'u Başlat
Kendi takma adınızı "NodeAdın" ile değiştirin.
```bash
arkeod init NodeAdın --chain-id=arkeo
```

## Genesis'i İndir
```bash
curl -Ls https://ss-t.arkeo.nodestake.top/genesis.json > $HOME/.arkeo/config/genesis.json
```

## addrbook'u İndir
```bash
curl -Ls https://ss-t.arkeo.nodestake.top/addrbook.json > $HOME/.arkeo/config/addrbook.json
```

## Servis Oluştur
```bash
sudo tee /etc/systemd/system/arkeod.service > /dev/null <<EOF
[Unit]
Description=arkeod Daemon
After=network-online.target
[Service]
User=$USER
ExecStart=$(which arkeod) start
Restart=always
RestartSec=3
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl enable arkeod
```

## Snapshot İndir (İsteğe Bağlı)
```bash
SNAP_NAME=$(curl -s https://ss-t.arkeo.nodestake.top/ | egrep -o ">20.*\.tar.lz4" | tr -d ">")

curl -o - -L https://ss-t.arkeo.nodestake.top/${SNAP_NAME}  | lz4 -c -d - | tar -x -C $HOME/.arkeo
```

## Node'u Başlat
```bash
sudo systemctl restart arkeod
journalctl -u arkeod -f
```
