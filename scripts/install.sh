#!/bin/bash
# ================================================================
# Seven Chain — Validator Node Installer
# Target: Ubuntu 22.04 LTS (DigitalOcean $12/month droplet)
# Specs: 2GB RAM, 2 vCPU, 60GB SSD
#
# Usage: bash scripts/install.sh
# Run as root or with sudo.
# ================================================================

set -euo pipefail

BSC_VERSION="v1.4.10"
BSC_BINARY_URL="https://github.com/bnb-chain/bsc/releases/download/${BSC_VERSION}/geth_linux"
DATA_DIR="/data/seven-chain"
LOG_DIR="${DATA_DIR}/logs"
SERVICE_USER="seven"

echo ""
echo "╔══════════════════════════════════════════════════════════╗"
echo "║         Seven Chain Validator Node Installer             ║"
echo "║         Chain ID: 70007 — BSC Fork (Parlia PoA)         ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo ""

# ── 1. System dependencies ────────────────────────────────────────
echo "[1/8] Installing system dependencies..."
apt-get update -qq
apt-get install -y -qq curl wget jq nginx certbot python3-certbot-nginx ufw fail2ban

# ── 2. Create service user ───────────────────────────────────────
echo "[2/8] Creating service user: ${SERVICE_USER}..."
if ! id "${SERVICE_USER}" &>/dev/null; then
  useradd -m -s /bin/bash "${SERVICE_USER}"
fi

# ── 3. Create data directories ───────────────────────────────────
echo "[3/8] Creating data directories..."
mkdir -p "${DATA_DIR}" "${LOG_DIR}"
chown -R "${SERVICE_USER}:${SERVICE_USER}" "${DATA_DIR}"

# ── 4. Download BSC binary (geth-compatible) ─────────────────────
echo "[4/8] Downloading BSC node binary (${BSC_VERSION})..."
wget -q -O /usr/local/bin/bsc "${BSC_BINARY_URL}"
chmod +x /usr/local/bin/bsc
echo "  BSC binary installed at /usr/local/bin/bsc"
bsc version 2>&1 | head -3 || true

# ── 5. Copy node configuration files ────────────────────────────
echo "[5/8] Installing Seven Chain configuration..."
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

if [[ ! -f "${DATA_DIR}/genesis.json" ]]; then
  cp "${REPO_DIR}/genesis.json" "${DATA_DIR}/genesis.json"
else
  echo "  Existing genesis file preserved."
fi
if [[ ! -f "${DATA_DIR}/config.toml" ]]; then
  cp "${REPO_DIR}/config.toml" "${DATA_DIR}/config.toml"
else
  echo "  Existing node configuration preserved."
fi

# ── 6. Initialize chain data from genesis ───────────────────────
echo "[6/8] Initializing chain data from genesis block..."
if [ ! -d "${DATA_DIR}/geth" ]; then
  sudo -u "${SERVICE_USER}" bsc init \
    --datadir "${DATA_DIR}" \
    "${DATA_DIR}/genesis.json"
  echo "  Chain initialized from genesis."
else
  echo "  Chain data already exists — skipping genesis init."
fi

# ── 7. Set up firewall rules ─────────────────────────────────────
echo "[7/8] Configuring firewall without resetting existing rules..."
if ! ufw status | grep -q "Status: active"; then
  ufw default deny incoming
  ufw default allow outgoing
fi
ufw allow ssh
ufw allow 30303/tcp  # P2P
ufw allow 30303/udp  # P2P UDP
# RPC is loopback-only; HTTP/HTTPS are not opened by this installer.
ufw --force enable
echo "  Firewall configured. JSON-RPC remains private by default."

# Install the repository launcher used by systemd.
install -m 0755 "${REPO_DIR}/scripts/start-validator.sh" /usr/local/bin/seven-chain-start

# ── 8. Create systemd service ────────────────────────────────────
echo "[8/8] Creating systemd service..."
cat > /etc/systemd/system/seven-chain.service << EOF
[Unit]
Description=Seven Chain Validator Node (Chain ID 70007)
After=network.target
Wants=network-online.target

[Service]
Type=simple
User=${SERVICE_USER}
Group=${SERVICE_USER}
WorkingDirectory=${DATA_DIR}
EnvironmentFile=-/etc/seven-chain/validator.env
ExecStart=/usr/local/bin/seven-chain-start
Restart=on-failure
RestartSec=10
LimitNOFILE=65536
StandardOutput=append:${LOG_DIR}/seven-chain.log
StandardError=append:${LOG_DIR}/seven-chain-error.log

[Install]
WantedBy=multi-user.target
EOF

# ── Create env directory ─────────────────────────────────────────
mkdir -p /etc/seven-chain
cat > /etc/seven-chain/validator.env.example << 'EOF'
# Copy to /etc/seven-chain/validator.env and fill in values
VALIDATOR_ADDRESS=0xYOUR_VALIDATOR_ADDRESS
# Comma-separated independent P2P bootnodes. Configure your own verified peers.
BOOTNODE_ENODES=enode://BOOTNODE_PUBKEY_1@BOOTNODE_HOST_1:30303,enode://BOOTNODE_PUBKEY_2@BOOTNODE_HOST_2:30303
EOF
chown root:seven /etc/seven-chain/validator.env.example
chmod 0640 /etc/seven-chain/validator.env.example

systemctl daemon-reload
systemctl enable seven-chain
echo "  Service created. NOT started yet — configure validator.env first."

echo ""
echo "Next steps:"
echo "  1. Copy /etc/seven-chain/validator.env.example to validator.env."
echo "  2. Create the encrypted local account: sudo bash scripts/create-validator-account.sh"
echo "  3. Set the printed public address in validator.env and configure P2P peers."
echo "  4. Start the node: sudo systemctl start seven-chain"
echo "  5. Keep JSON-RPC private; the installer does not open HTTP/HTTPS ports."
echo ""
