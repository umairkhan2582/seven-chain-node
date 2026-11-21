#!/usr/bin/env bash
# Import a validator key without putting it in shell history or process arguments.
set -euo pipefail
set +x
umask 077
DATA_DIR="${DATA_DIR:-/data/seven-chain}"
PASS_FILE="${PASS_FILE:-/etc/seven-chain/keystore.pass}"
mkdir -p /etc/seven-chain
chmod 700 /etc/seven-chain

if [[ ! -f "$PASS_FILE" ]]; then
  openssl rand -hex 32 > "$PASS_FILE"
  chmod 600 "$PASS_FILE"
  echo "A keystore password was created at $PASS_FILE; keep it protected and back it up securely."
fi

read -r -s -p "Validator private key (input hidden): " PRIVATE_KEY
printf '\n'
PRIVATE_KEY="${PRIVATE_KEY#0x}"
if [[ ! "$PRIVATE_KEY" =~ ^[0-9a-fA-F]{64}$ ]]; then
  unset PRIVATE_KEY
  echo "Invalid private key format." >&2
  exit 1
fi

TMP_KEY="$(mktemp "${TMPDIR:-/tmp}/seven-validator-key.XXXXXX")"
trap 'rm -f "$TMP_KEY"; unset PRIVATE_KEY' EXIT
printf '%s\n' "$PRIVATE_KEY" > "$TMP_KEY"
chmod 600 "$TMP_KEY"
unset PRIVATE_KEY

bsc account import --datadir "$DATA_DIR" --password "$PASS_FILE" "$TMP_KEY"
echo "Key imported. Confirm the public validator address locally; never print or share the key."
