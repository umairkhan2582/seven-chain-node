#!/bin/bash
# ================================================================
# Seven Chain — Start Validator Node
# Run this AFTER install.sh and configuring validator.env
# ================================================================

set -euo pipefail

DATA_DIR="/data/seven-chain"
LOG_DIR="${DATA_DIR}/logs"

# Load environment
if [ -f /etc/seven-chain/validator.env ]; then
  source /etc/seven-chain/validator.env
else
  echo "ERROR: /etc/seven-chain/validator.env not found"
  echo "Copy validator.env.example and fill in your values."
  exit 1
fi

echo "Starting Seven Chain validator node..."
echo "  Validator: ${VALIDATOR_ADDRESS}"
echo "  Data dir : ${DATA_DIR}"
echo "  Chain ID : 70007"
echo "  Bootnode : ${BOOTNODE_ENODE}"
echo ""

bsc \
  --config "${DATA_DIR}/config.toml" \
  --datadir "${DATA_DIR}" \
  --unlock "${VALIDATOR_ADDRESS}" \
  --password /etc/seven-chain/keystore.pass \
  --mine \
  --bootnodes "${BOOTNODE_ENODE}" \
  --networkid 70007 \
  --verbosity 3 \
  2>&1 | tee -a "${LOG_DIR}/seven-chain.log"
