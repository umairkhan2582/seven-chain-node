#!/bin/bash
# ================================================================
# Seven Chain — Import Validator Private Key into Keystore
# Usage: bash scripts/import-key.sh YOUR_PRIVATE_KEY
# ================================================================

set -euo pipefail

PRIVATE_KEY="${1:-}"
DATA_DIR="/data/seven-chain"
PASS_FILE="/etc/seven-chain/keystore.pass"

if [ -z "$PRIVATE_KEY" ]; then
  echo "Usage: bash scripts/import-key.sh YOUR_PRIVATE_KEY"
  echo "Example: bash scripts/import-key.sh 0xabcdef..."
  exit 1
fi

# Strip 0x prefix
PRIVATE_KEY="${PRIVATE_KEY#0x}"

mkdir -p /etc/seven-chain

# Generate a random keystore password if not set — NEVER echoed to stdout
if [ ! -f "$PASS_FILE" ]; then
  openssl rand -hex 32 > "$PASS_FILE"
  chmod 600 "$PASS_FILE"
  # Password is NOT printed to stdout to prevent capture in logs/history.
  # Retrieve it manually: sudo cat /etc/seven-chain/keystore.pass
  echo "Keystore password generated and stored at: $PASS_FILE (not echoed — read it directly)"
fi

# Write private key to temp file
TMP_KEY=$(mktemp)
echo "$PRIVATE_KEY" > "$TMP_KEY"
trap "rm -f $TMP_KEY" EXIT

# Import into geth keystore
echo "Importing validator key..."
bsc account import \
  --datadir "${DATA_DIR}" \
  --password "${PASS_FILE}" \
  "${TMP_KEY}"

echo ""
echo "✅ Key imported. Your validator address has been added to the keystore."
echo "   Update VALIDATOR_ADDRESS in /etc/seven-chain/validator.env"
