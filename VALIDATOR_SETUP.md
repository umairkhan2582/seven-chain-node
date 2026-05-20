# Seven Chain — Validator Node Setup Guide

> **Updated: May 20, 2026**

Complete step-by-step guide to running a Seven Chain validator node on Ubuntu 22.04 / 24.04.

---

## Before You Start

Get SEVEN tokens first:

| Action | URL |
|--------|-----|
| Buy SEVEN with sUSDT | **[theseven.meme/spot/seven](https://theseven.meme/spot/seven)** |
| Bridge USDT from BNB Chain | **[theseven.meme/bridge](https://theseven.meme/bridge)** |
| Stake + Register Validator | **[theseven.meme/staking](https://theseven.meme/staking)** |

> BRONZE tier = 0 SEVEN. Free to start. Upgrade tier anytime.

---

## Validator Tiers

| Tier | Min Stake | APR | Block Priority |
|------|-----------|-----|----------------|
| BRONZE  | 0 SEVEN      | 8%/yr  | Standard |
| SILVER  | 5,000 SEVEN  | 12%/yr | Medium   |
| GOLD    | 10,000 SEVEN | 18%/yr | High     |
| DIAMOND | 50,000 SEVEN | 25%/yr | Maximum  |

---

## System Requirements

| Component | Minimum | Recommended |
|-----------|---------|-------------|
| OS | Ubuntu 22.04 LTS | Ubuntu 24.04 LTS |
| CPU | 2 vCPUs | 4+ vCPUs |
| RAM | 4 GB | 8 GB |
| Disk | 50 GB SSD | 200 GB NVMe |
| Bandwidth | 25 Mbps | 100 Mbps |
| **Open ports** | **8545 (RPC)** | 8545 + 30303 |

> Port 8545 **must** be publicly reachable — the platform pings it to activate your node.

---

## 1. Server Setup

```bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y curl git ufw

sudo ufw allow 22/tcp    # SSH
sudo ufw allow 8545/tcp  # Public RPC — required
sudo ufw allow 30303/tcp # P2P — optional
sudo ufw enable
```

---

## 2. Install Node.js 20

```bash
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs
node --version   # v20.x
```

---

## 3. Clone and Install

```bash
git clone https://github.com/umairkhan2582/seven-chain-node.git
cd seven-chain-node
npm install
```

---

## 4. Configure

```bash
cp config.toml config.local.toml
nano config.local.toml
```

Key change — expose RPC so the platform can ping you:

```toml
[Node]
HTTPHost = "0.0.0.0"   # NOT 127.0.0.1
HTTPPort = 8545
```

---

## 5. Initialize Genesis

```bash
npm run init-genesis
# Expected: INFO Successfully wrote genesis state (chain 70007)
```

---

## 6. Start Node

```bash
npm start &

# Verify chain ID
curl -s http://localhost:8545 -X POST \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","method":"eth_chainId","params":[],"id":1}'
# Expected: {"result":"0x1117f"}  (0x1117f = 70007) OK

# Test public reachability
curl -s http://YOUR_SERVER_IP:8545 -X POST \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","method":"net_version","params":[],"id":1}'
# Expected: {"result":"70007"}
```

---

## 7. Register as Validator — Self-Service, No Approval

1. Go to **[theseven.meme/staking](https://theseven.meme/staking)**
2. Connect wallet
3. Choose tier, enter stake amount
4. Enter **Node RPC URL**: `http://YOUR_SERVER_IP:8545`
5. Click **Stake & Register**

Platform immediately:
- Stakes your SEVEN
- Auto-registers your node
- Pings your RPC (eth_chainId must return 70007)
- Sets status → **ACTIVE**

**No email. No admin. Instant.**

---

## 8. Heartbeat Service

Keeps your node active — send heartbeat every 30 seconds:

```bash
sudo tee /etc/systemd/system/seven-heartbeat.service > /dev/null << EOF
[Unit]
Description=Seven Chain Validator Heartbeat
After=network.target

[Service]
WorkingDirectory=/root/seven-chain-node
ExecStart=npm run heartbeat -- --wallet 0xYOUR_WALLET --rpc http://YOUR_IP:8545
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable --now seven-heartbeat
```

Heartbeat endpoint:
```
POST https://theseven.meme/api/node-heartbeat
{"walletAddress":"0xYOUR_WALLET","rpcUrl":"http://YOUR_IP:8545","nodeVersion":"1.0.0"}
```

---

## 9. Node as systemd Service

```bash
sudo tee /etc/systemd/system/seven-chain.service > /dev/null << EOF
[Unit]
Description=Seven Chain Validator Node
After=network-online.target

[Service]
WorkingDirectory=/root/seven-chain-node
ExecStart=npm start
Restart=always
RestartSec=5
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable --now seven-chain
journalctl -u seven-chain -f
```

---

## 10. Verify

```bash
systemctl is-active seven-chain        # active
systemctl is-active seven-heartbeat    # active
curl "https://theseven.meme/api/validators/0xYOUR_WALLET" | python3 -m json.tool
```

---

## Earnings

| Stream | How | Example |
|--------|-----|---------|
| Block rewards | Per block your node seals | Continuous |
| Relay fees | 0.0004 BNB per bridged trade | 100 trades/day = 0.04 BNB |
| Staking APR | 8-25%/yr on staked SEVEN | 50k SEVEN x 25% = 12,500/yr |

---

## Troubleshooting

| Problem | Fix |
|---------|-----|
| Port 8545 unreachable | `sudo ufw allow 8545/tcp && sudo ufw reload` |
| Wrong chain ID | Re-run `npm run init-genesis` |
| Status stuck on "approved" | Confirm 8545 reachable from public internet |
| No sUSDT | Bridge at [theseven.meme/bridge](https://theseven.meme/bridge) |

---

*Updated May 20, 2026 — Seven Chain Validator Team*
