#!/usr/bin/env bash
# Generate the validator account locally inside the node keystore; never print a private key.
set -euo pipefail

DATA_DIR="${DATA_DIR:-/data/seven-chain}"
PASS_FILE="${KEYSTORE_PASSWORD_FILE:-/etc/seven-chain/keystore.pass}"
SERVICE_USER="seven"

if [[ $EUID -ne 0 ]]; then
  echo "Run with sudo so the password file and node keystore permissions can be set safely." >&2
  exit 1
fi
if ! id "${SERVICE_USER}" >/dev/null 2>&1; then
  echo "ERROR: service account 'seven' is missing. Run scripts/install.sh first." >&2
  exit 1
fi
if ! command -v bsc >/dev/null 2>&1; then
  echo "ERROR: bsc binary not found. Run scripts/install.sh first." >&2
  exit 1
fi

mkdir -p "$(dirname "${PASS_FILE}")"
if [[ ! -f "${PASS_FILE}" ]]; then
  TMP_PASS="$(mktemp)"
  trap 'rm -f "${TMP_PASS}"' EXIT
  openssl rand -hex 32 > "${TMP_PASS}"
  install -o "${SERVICE_USER}" -g "${SERVICE_USER}" -m 0400 "${TMP_PASS}" "${PASS_FILE}"
else
  chown "${SERVICE_USER}:${SERVICE_USER}" "${PASS_FILE}"
  chmod 0400 "${PASS_FILE}"
fi

# Geth/BSC writes an encrypted keystore entry and prints only the public address.
runuser -u "${SERVICE_USER}" -- bsc account new \
  --datadir "${DATA_DIR}" \
  --password "${PASS_FILE}"
