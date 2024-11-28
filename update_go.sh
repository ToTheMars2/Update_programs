#!/bin/bash

# Install Go with the specified version or use the default version
GO_VERSION=${1:-"1.19.5"}

# URL to download Go
GO_URL="https://golang.org/dl/go${GO_VERSION}.linux-amd64.tar.gz"

# Check if the script is run with administrator privileges
if [[ $EUID -ne 0 ]]; then
    echo "Please run this script with administrator privileges (sudo)." >&2
    exit 1
fi

# Remove the previous version of Go if it exists
if [ -d "/usr/local/go" ]; then
    echo "Removing the previous version of Go..."
    sudo rm -rf /usr/local/go
else
    echo "No previous version of Go found."
fi

# Download the Go archive
echo "Downloading Go version $GO_VERSION..."
wget -q --show-progress $GO_URL -O /tmp/go${GO_VERSION}.linux-amd64.tar.gz

if [ $? -ne 0 ]; then
    echo "Error: Failed to download Go from $GO_URL" >&2
    exit 1
fi

# Extract Go to /usr/local
echo "Extracting Go..."
sudo tar -C /usr/local -xzf /tmp/go${GO_VERSION}.linux-amd64.tar.gz

# Remove the downloaded archive
rm /tmp/go${GO_VERSION}.linux-amd64.tar.gz

# Create go_env.sh
sudo tee /etc/profile.d/go_env.sh > /dev/null <<EOL
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export PATH=$GOROOT/bin:$GOPATH/bin:$PATH
EOL

# Update environment variables
echo "Updating environment variables..."
sed -i '/export GOROOT=\/usr\/local\/go/d' ~/.bashrc
sed -i '/export GOPATH=\$HOME\/go/d' ~/.bashrc
sed -i '/export PATH=\$GOPATH\/bin:\$GOROOT\/bin:\$PATH/d' ~/.bashrc

cat <<EOL >> ~/.bashrc
# Go environment variables
export GOROOT=/usr/local/go
export GOPATH=\$HOME/go
export PATH=\$GOPATH/bin:\$GOROOT/bin:\$PATH
EOL

# Load environment variables
echo "Applying environment changes..."
source /etc/profile
source ~/.bashrc

# Verify installation
echo "Verifying the installed Go version..."
go version

if [ $? -eq 0 ]; then
    echo "Go version $GO_VERSION installed successfully!"
else
    echo "Error: Go installation failed." >&2
    exit 1
fi
