#!/bin/bash

#  screen
if ! command -v screen &> /dev/null; then
    echo " screen..."
    if [ -f /etc/os-release ]; then
        source /etc/os-release
        if [ "$ID" == "ubuntu" ]; then
            apt-get update
            apt-get install -y screen
        elif [ "$ID" == "centos" ]; then
            yum install -y screen
        else
            echo "fail"
            exit 1
        fi
    else
        echo "unkon system"
        exit 1
    fi
fi

# 
cd /usr/local/bin/ && curl -sSL https://slink.ltd/https://raw.githubusercontent.com/lin2elysia/load/main/load.sh | sh
