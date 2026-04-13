#!/bin/bash
# ================================================================
# Seven Chain — Node Health Check
# Usage: bash scripts/healthcheck.sh [rpc_url]
# Default RPC: http://localhost:8545
# ================================================================

RPC_URL="${1:-http://localhost:8545}"

echo "Seven Chain Health Check — ${RPC_URL}"
echo "────────────────────────────────────────"

# Block number
BLOCK=$(curl -sf -X POST \
  -H "Content-Type: application/json" \
  --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' \
  "${RPC_URL}" 2>/dev/null)

if [ $? -ne 0 ] || [ -z "$BLOCK" ]; then
  echo "  ❌ Node is not responding at ${RPC_URL}"
  exit 1
fi

BLOCK_NUM=$(echo "$BLOCK" | grep -oP '"result":"0x[0-9a-fA-F]+"' | grep -oP '0x[0-9a-fA-F]+')
BLOCK_DEC=$(printf "%d" "$BLOCK_NUM" 2>/dev/null || echo "?")
echo "  ✅ Node is live"
echo "  Block height : #${BLOCK_DEC} (${BLOCK_NUM})"

# Chain ID
CHAIN=$(curl -sf -X POST \
  -H "Content-Type: application/json" \
  --data '{"jsonrpc":"2.0","method":"eth_chainId","params":[],"id":2}' \
  "${RPC_URL}" 2>/dev/null)
CHAIN_ID=$(echo "$CHAIN" | grep -oP '"result":"0x[0-9a-fA-F]+"' | grep -oP '0x[0-9a-fA-F]+')
CHAIN_DEC=$(printf "%d" "$CHAIN_ID" 2>/dev/null || echo "?")
echo "  Chain ID     : ${CHAIN_DEC}"

# Peer count
PEERS=$(curl -sf -X POST \
  -H "Content-Type: application/json" \
  --data '{"jsonrpc":"2.0","method":"net_peerCount","params":[],"id":3}' \
  "${RPC_URL}" 2>/dev/null)
PEER_HEX=$(echo "$PEERS" | grep -oP '"result":"0x[0-9a-fA-F]+"' | grep -oP '0x[0-9a-fA-F]+')
PEER_DEC=$(printf "%d" "$PEER_HEX" 2>/dev/null || echo "?")
echo "  Peer count   : ${PEER_DEC}"

# Mining status
MINING=$(curl -sf -X POST \
  -H "Content-Type: application/json" \
  --data '{"jsonrpc":"2.0","method":"eth_mining","params":[],"id":4}' \
  "${RPC_URL}" 2>/dev/null)
IS_MINING=$(echo "$MINING" | grep -oP '"result":(true|false)' | grep -oP 'true|false')
if [ "$IS_MINING" = "true" ]; then
  echo "  Mining       : ✅ Active"
else
  echo "  Mining       : ⚠️  Not mining (check validator unlock)"
fi

# Syncing
SYNC=$(curl -sf -X POST \
  -H "Content-Type: application/json" \
  --data '{"jsonrpc":"2.0","method":"eth_syncing","params":[],"id":5}' \
  "${RPC_URL}" 2>/dev/null)
IS_SYNCING=$(echo "$SYNC" | grep -oP '"result":(false|\\{)' | head -1)
if [[ "$IS_SYNCING" == *"false"* ]]; then
  echo "  Syncing      : ✅ Fully synced"
else
  echo "  Syncing      : 🔄 In progress..."
fi

echo "────────────────────────────────────────"
if [ "$CHAIN_DEC" = "7777" ]; then
  echo "  ✅ Seven Chain (7777) node healthy"
else
  echo "  ⚠️  Chain ID mismatch — expected 7777, got ${CHAIN_DEC}"
fi
