#!/bin/bash

while getopts v: flag; do
  case "${flag}" in
  v) V=$OPTARG ;;
  *) echo "WARN: unknown parameter: ${OPTARG}"
  esac
done

# Determine the go version
LATEST_VERSION=$(curl -s https://go.dev/dl/?mode=json | jq -r '.[0].version')
if [ -n "$V" ]; then
  VERSION="go$V"
else
  VERSION="$LATEST_VERSION"
fi

# Determine the operating system
if [[ "$(uname -s)" == "Linux" ]]; then
  OS="linux"
elif [[ "$(uname -s)" == "Darwin" ]]; then
  OS="darwin"
else
  echo "Unsupported operating system"
  exit 1
fi

# Determine the architecture
if [[ "$(uname -m)" == "x86_64" ]]; then
  ARCH="amd64"
elif [[ "$(uname -m)" == "aarch64" ]]; then
  ARCH="arm64"
else
  echo "Unsupported architecture"
  exit 1
fi

# Install the binaries
curl -L -# -O "https://golang.org/dl/$VERSION.$OS-$ARCH.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "$VERSION.$OS-$ARCH.tar.gz"
rm "$VERSION.$OS-$ARCH.tar.gz"

# Set the path if needed
touch $HOME/.bash_profile
source $HOME/.bash_profile
PATH_INCLUDES_GO=$(grep "$HOME/go/bin" $HOME/.bash_profile)
if [ -z "$PATH_INCLUDES_GO" ]; then
  echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> $HOME/.bash_profile
  echo "export GOPATH=$HOME/go" >> $HOME/.bash_profile
fi

source $HOME/.bash_profile

go version
