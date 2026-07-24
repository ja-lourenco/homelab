#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=config.sh
source "${SCRIPT_DIR}/config.sh"

if pct status "${CTID}" &>/dev/null; then
  echo "CT ${CTID} already exists — skipping create"
  exit 0
fi

echo "Creating CT ${CTID} (${HOSTNAME})..."
pct create "${CTID}" "${TEMPLATE}" \
  --hostname "${HOSTNAME}" \
  --cores "${CORES}" \
  --memory "${MEMORY}" \
  --swap "${SWAP}" \
  --rootfs "${STORAGE}:${DISK_SIZE}" \
  --net0 "name=eth0,bridge=${BRIDGE},ip=${IP},gw=${GW}" \
  --unprivileged 1 \
  --onboot 1 \
  --start 1

echo "CT ${CTID} created and started"