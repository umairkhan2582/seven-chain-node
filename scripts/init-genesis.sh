#!/usr/bin/env bash
# Initialize a fresh data directory only. Never reinitialize existing chain data.
set -euo pipefail

DATA_DIR="${DATA_DIR:-/data/seven-chain}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
GENESIS_FILE="${GENESIS_FILE:-${REPO_DIR}/genesis.json}"

if ! command -v bsc >/dev/null 2>&1; then
  echo "ERROR: bsc binary not found. Run scripts/install.sh first." >&2
  exit 1
fi
if [[ ! -f "${GENESIS_FILE}" ]]; then
  echo "ERROR: genesis file not found: ${GENESIS_FILE}" >&2
  exit 1
fi
if [[ -d "${DATA_DIR}/geth" || -d "${DATA_DIR}/chaindata" ]]; then
  echo "Refusing to initialize: existing chain data was found at ${DATA_DIR}." >&2
  echo "This command is for a fresh test/dev data directory only; it never resets a node." >&2
  exit 2
fi

mkdir -p "${DATA_DIR}"
bsc init --datadir "${DATA_DIR}" "${GENESIS_FILE}"
echo "Initialized a fresh Seven Chain data directory at ${DATA_DIR}."
echo "Do not use a new genesis file for an existing live network."
