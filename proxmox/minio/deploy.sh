#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=config.sh
source "${SCRIPT_DIR}/config.sh"

if [[ ! -f "${SCRIPT_DIR}/minio.env" ]]; then
  echo "Missing minio.env"
  echo "Run: cp minio.env.example minio.env && edit the password"
  exit 1
fi

CT_IP="${IP%%/*}"

# ensure CT template exists
echo "==> 1/6 CT Template Download"
pveam update
if ! pveam list "${TEMPLATE_STORAGE}" | grep -q "${TEMPLATE_FILE}"; then
  pveam download "${TEMPLATE_STORAGE}" "${TEMPLATE_FILE}"
fi

echo "==> 2/6 Create LXC"
bash "${SCRIPT_DIR}/create-lxc.sh"

echo "==> 3/6 Wait for CT network"
sleep 5

echo "==> 4/6 Push configs into CT"
pct exec "${CTID}" -- mkdir -p /etc/minio /tmp
pct push "${CTID}" "${SCRIPT_DIR}/minio.service" /etc/systemd/system/minio.service
pct push "${CTID}" "${SCRIPT_DIR}/minio.env" /etc/minio/minio.env
pct push "${CTID}" "${SCRIPT_DIR}/install-minio.sh" /tmp/install-minio.sh

echo "==> 5/6 Install MinIO"
pct exec "${CTID}" -- bash /tmp/install-minio.sh

echo "==> 6/6 Wait for API + bootstrap bucket"
for _ in $(seq 1 30); do
  if curl -sf -o /dev/null "http://${CT_IP}:9000/minio/health/live"; then
    break
  fi
  sleep 2
done

if ! curl -sf -o /dev/null "http://${CT_IP}:9000/minio/health/live"; then
  echo "MinIO API did not become healthy at http://${CT_IP}:9000"
  exit 1
fi

bash "${SCRIPT_DIR}/bootstrap-bucket.sh"

echo
echo "Done."
echo "API:     http://${CT_IP}:9000"
echo "Console: http://${CT_IP}:9001"
echo "Backend env: ${SCRIPT_DIR}/terraform-backend.env"