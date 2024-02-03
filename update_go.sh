#!/bin/bash

# Версія Go, яку ви хочете встановити
GO_VERSION=${1:-"1.19.5"}

# Видалення попередньої версії Go
sudo rm -rf /usr/local/go

# Завантаження та встановлення нової версії Go
wget https://golang.org/dl/go$GO_VERSION.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go$GO_VERSION.linux-amd64.tar.gz
rm go$GO_VERSION.linux-amd64.tar.gz
read -p "Add path to .bashrc? (y/n): " answer
if [ "$answer" == "y" ]; then
    echo -e 'export GOROOT=/usr/local/go\nexport GOPATH=$HOME/go\nexport PATH=$GOPATH/bin:$GOROOT/bin:$PATH' >> ~/.bashrc
    echo "you need enter   source .bashrc "
else
    echo ""
fi
# Вивести версію Go
sleep 1
source ~/.bashrc
go version
