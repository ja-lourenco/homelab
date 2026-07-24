#!/usr/bin/env bash
# Edit these values for your lab.

CTID=110
HOSTNAME=minio
STORAGE=local-lvm
BRIDGE=vmbr0

TEMPLATE_STORAGE=local
TEMPLATE_FILE=debian-12-standard_12.12-1_amd64.tar.zst
TEMPLATE="${TEMPLATE_STORAGE}:vztmpl/${TEMPLATE_FILE}"

CORES=1
MEMORY=512
SWAP=512
DISK_SIZE=8

IP=192.168.15.110/24
GW=192.168.15.1
NAMESERVER=192.168.15.1

BUCKET=terraform-state
MINIO_ENV_FILE=./minio.env
BACKEND_ENV_FILE=./terraform-backend.env