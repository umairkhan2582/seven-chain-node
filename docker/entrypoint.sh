#!/usr/bin/env bash
set -euo pipefail

DATA_DIR="${DATA_DIR:-/data/seven-chain}"
GENESIS_FILE="${DATA_DIR}/genesis.json"
CONFIG_FILE="${DATA_DIR}/config.toml"

if [[ ! -f "${GENESIS_FILE}" || ! -f "${CONFIG_FILE}" ]]; then
  echo "ERROR: image genesis/config files are missing." >&2
  exit 1
fi

# Named volumes are empty on first launch. Initialize only the fresh data volume.
if [[ ! -d "${DATA_DIR}/geth/chaindata" ]]; then
  bsc init --datadir "${DATA_DIR}" "${GENESIS_FILE}"
fi

args=(
  --config "${CONFIG_FILE}"
  --datadir "${DATA_DIR}"
  --networkid 70007
  --verbosity 3
  --http
  --http.addr 0.0.0.0
  --http.api eth,net,web3
)
if [[ -n "${BOOTNODE_ENODES:-}" ]]; then
  args+=(--bootnodes "${BOOTNODE_ENODES}")
fi

# This is a non-mining full-node smoke test; it does not claim validator status.
exec bsc "${args[@]}"
