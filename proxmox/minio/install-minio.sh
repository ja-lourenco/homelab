#!/usr/bin/env bash
set -euo pipefail

export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get install -y curl ca-certificates

if ! id minio-user &>/dev/null; then
  useradd -r -s /sbin/nologin minio-user
fi

mkdir -p /usr/local/bin /data/minio /etc/minio

curl -fsSL https://dl.min.io/server/minio/release/linux-amd64/minio \
  -o /usr/local/bin/minio
chmod +x /usr/local/bin/minio

chown -R minio-user:minio-user /data/minio
chmod 600 /etc/minio/minio.env
chown root:root /etc/minio/minio.env

systemctl daemon-reload
systemctl enable --now minio
systemctl --no-pager --full status minio