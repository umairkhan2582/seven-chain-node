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
echo "║         Chain ID: 7777 — BSC Fork (Parlia PoA)          ║"
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

cp "${REPO_DIR}/genesis.json" "${DATA_DIR}/genesis.json"
cp "${REPO_DIR}/config.toml" "${DATA_DIR}/config.toml"

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
echo "[7/8] Configuring firewall..."
ufw --force reset
ufw default deny incoming
ufw default allow outgoing
ufw allow ssh
ufw allow 30303/tcp   # P2P
ufw allow 30303/udp   # P2P UDP
ufw allow 80/tcp      # HTTP (for Certbot)
ufw allow 443/tcp     # HTTPS (public RPC via Nginx)
ufw --force enable
echo "  Firewall configured."

# ── 8. Create systemd service ────────────────────────────────────
echo "[8/8] Creating systemd service..."
cat > /etc/systemd/system/seven-chain.service << EOF
[Unit]
Description=Seven Chain Validator Node (Chain ID 7777)
After=network.target
Wants=network-online.target

[Service]
Type=simple
User=${SERVICE_USER}
Group=${SERVICE_USER}
WorkingDirectory=${DATA_DIR}
EnvironmentFile=-/etc/seven-chain/validator.env
ExecStart=/usr/local/bin/bsc \\
  --config ${DATA_DIR}/config.toml \\
  --datadir ${DATA_DIR} \\
  --unlock \${VALIDATOR_ADDRESS} \\
  --password /etc/seven-chain/keystore.pass \\
  --mine \\
  --bootnodes \${BOOTNODE_ENODE} \\
  --networkid 7777
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
BOOTNODE_ENODE=enode://BOOTNODE_PUBKEY@BOOTNODE_IP:30303
EOF

systemctl daemon-reload
systemctl enable seven-chain
echo "  Service created. NOT started yet — configure validator.env first."

echo ""
echo "╔══════════════════════════════════════════════════════════╗"
echo "║  Installation complete!                                  ║"
echo "╠══════════════════════════════════════════════════════════╣"
echo "║  Next steps:                                             ║"
echo "║  1. Import validator keystore:                           ║"
echo "║     bash scripts/import-key.sh YOUR_PRIVATE_KEY         ║"
echo "║  2. Configure /etc/seven-chain/validator.env            ║"
echo "║  3. Set up Nginx RPC proxy:                              ║"
echo "║     bash scripts/setup-nginx.sh rpc-testnet.theseven.meme║"
echo "║  4. Start the node:                                      ║"
echo "║     systemctl start seven-chain                          ║"
echo "║  5. Check status:                                        ║"
echo "║     bash scripts/healthcheck.sh                          ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo ""
