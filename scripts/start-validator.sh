#!/usr/bin/env bash
# Start the upstream BSC client with this repository's Seven Chain configuration.
set -euo pipefail

DATA_DIR="${DATA_DIR:-/data/seven-chain}"
LOG_DIR="${DATA_DIR}/logs"
ENV_FILE="${VALIDATOR_ENV_FILE:-/etc/seven-chain/validator.env}"
PASS_FILE="${KEYSTORE_PASSWORD_FILE:-/etc/seven-chain/keystore.pass}"

if [[ ! -r "${ENV_FILE}" ]]; then
  echo "ERROR: ${ENV_FILE} is missing or unreadable." >&2
  echo "Create it from /etc/seven-chain/validator.env.example." >&2
  exit 1
fi
# The operator-owned file contains non-secret node settings only.
# shellcheck disable=SC1090
source "${ENV_FILE}"

: "${VALIDATOR_ADDRESS:?Set VALIDATOR_ADDRESS in ${ENV_FILE}}"
if [[ ! "${VALIDATOR_ADDRESS}" =~ ^0x[0-9a-fA-F]{40}$ ]]; then
  echo "ERROR: VALIDATOR_ADDRESS must be a 20-byte 0x-prefixed address." >&2
  exit 1
fi
if ! command -v bsc >/dev/null 2>&1; then
  echo "ERROR: bsc binary not found. Run scripts/install.sh first." >&2
  exit 1
fi
if [[ ! -r "${PASS_FILE}" ]]; then
  echo "ERROR: keystore password file is missing or unreadable: ${PASS_FILE}" >&2
  exit 1
fi

BOOTNODE_ENODES="${BOOTNODE_ENODES:-${BOOTNODE_ENODE:-}}"
mkdir -p "${LOG_DIR}"

args=(
  --config "${DATA_DIR}/config.toml"
  --datadir "${DATA_DIR}"
  --unlock "${VALIDATOR_ADDRESS}"
  --password "${PASS_FILE}"
  --mine
  --networkid 70007
  --verbosity 3
)
if [[ -n "${BOOTNODE_ENODES}" ]]; then
  # A comma-separated list permits more than one independently operated seed.
  args+=(--bootnodes "${BOOTNODE_ENODES}")
fi

printf 'Starting Seven Chain validator (chain ID 70007); P2P bootstrap peers: %s\n' "${BOOTNODE_ENODES:-discovery only}"
exec bsc "${args[@]}"
