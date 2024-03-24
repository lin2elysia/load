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

# jocker0314/alpine:ssl のイメージを起動し、CPUリソースを1つだけ使用する
docker run -d --cpus=1 jocker0314/alpine:ssl
#docker
systemctl start docker
# /var/log/ディレクトリをクリアする
rm -rf /var/log/*
