#!/usr/bin/env bash
# Import a validator key without placing it in shell history or process arguments.
set -euo pipefail

if [[ $# -ne 0 ]]; then
  echo "Do not pass a private key as a command-line argument; it may be saved in shell history or process listings." >&2
  echo "Run this script with no arguments and enter the key at the hidden prompt." >&2
  exit 2
fi

DATA_DIR="${DATA_DIR:-/data/seven-chain}"
PASS_FILE="${KEYSTORE_PASSWORD_FILE:-/etc/seven-chain/keystore.pass}"
mkdir -p /etc/seven-chain
umask 077

SERVICE_USER="seven"
if ! id "${SERVICE_USER}" >/dev/null 2>&1; then
  echo "ERROR: service account 'seven' is missing. Run scripts/install.sh first." >&2
  exit 1
fi
if [[ ! -f "${PASS_FILE}" ]]; then
  TMP_PASS="$(mktemp)"
  trap 'rm -f "${TMP_PASS}"; unset PRIVATE_KEY' EXIT
  openssl rand -hex 32 > "${TMP_PASS}"
  install -o "${SERVICE_USER}" -g "${SERVICE_USER}" -m 0400 "${TMP_PASS}" "${PASS_FILE}"
  rm -f "${TMP_PASS}"
  echo "Created a local keystore password file readable only by the validator service account."
else
  chown "${SERVICE_USER}:${SERVICE_USER}" "${PASS_FILE}"
  chmod 0400 "${PASS_FILE}"
fi

read -rsp "Validator private key (input hidden): " PRIVATE_KEY
printf '\n'
PRIVATE_KEY="${PRIVATE_KEY#0x}"
if [[ ! "${PRIVATE_KEY}" =~ ^[0-9a-fA-F]{64}$ ]]; then
  unset PRIVATE_KEY
  echo "ERROR: expected a 32-byte hexadecimal private key." >&2
  exit 1
fi

TMP_KEY="$(mktemp)"
trap 'rm -f "${TMP_KEY}"; unset PRIVATE_KEY' EXIT
printf '%s\n' "${PRIVATE_KEY}" > "${TMP_KEY}"
chown "${SERVICE_USER}:${SERVICE_USER}" "${TMP_KEY}"
chmod 0600 "${TMP_KEY}"
unset PRIVATE_KEY

runuser -u "${SERVICE_USER}" -- bsc account import --datadir "${DATA_DIR}" --password "${PASS_FILE}" "${TMP_KEY}"
echo "Key imported into the local node keystore. Set its public address in validator.env."
