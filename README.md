# Seven Chain — Validator Node

<div align="center">

### 🟢 MAINNET LIVE · Chain ID 70007 · Updated May 20, 2026

[![Chain ID](https://img.shields.io/badge/Chain%20ID-70007-22c55e?style=for-the-badge&logo=ethereum)](https://theseven.meme)
[![Staking APR](https://img.shields.io/badge/Staking%20APR-8%25%20to%2025%25-gold?style=for-the-badge)](https://theseven.meme/staking)
[![Buy SEVEN](https://img.shields.io/badge/Buy%20SEVEN-%24100%2FSEVEN-orange?style=for-the-badge)](https://theseven.meme/spot/seven)
[![License](https://img.shields.io/badge/License-MIT-gray?style=for-the-badge)](LICENSE)

**Validate blocks on Seven Chain. Earn relay fees, block rewards, and up to 25% APR on staked SEVEN — fully automated, no human approval, active in under 5 minutes.**

[🛒 Buy SEVEN](https://theseven.meme/spot/seven) &nbsp;•&nbsp; [🥩 Stake & Register](https://theseven.meme/staking) &nbsp;•&nbsp; [🌉 Bridge Assets](https://theseven.meme/bridge) &nbsp;•&nbsp; [📈 Exchange](https://theseven.meme) &nbsp;•&nbsp; [💬 Telegram](https://t.me/thesevenmeme)

</div>

---

## What is a Seven Chain Validator?

Seven Chain is the immutable settlement ledger for [TheSeven.meme](https://theseven.meme) — the world's first on-chain perpetual futures exchange with up to **2001× leverage**, a meme token launchpad, and a P2P spot market. Every trade open, close, liquidation, profit payout, meme token buy/sell, and sUSDT transfer is written on-chain permanently.

**Validators seal these blocks and get paid for every single one.**

---

## 💰 How Much Can You Earn?

Validators earn from **three simultaneous revenue streams**:

### Stream 1 — Relay Fees (BNB paid per trade)
Every time a user bridges from BNB Chain and opens a futures trade, they pay a **0.0004 BNB relay fee** directly to your validator wallet.

| Daily Trades on Platform | Your BNB / Day | USD / Day (BNB @ $600) |
|--------------------------|----------------|------------------------|
| 50 trades | 0.02 BNB | ~$12 |
| 200 trades | 0.08 BNB | ~$48 |
| 500 trades | 0.20 BNB | ~$120 |
| 1,000 trades | 0.40 BNB | ~$240 |
| 5,000 trades | 2.00 BNB | ~$1,200 |

> Higher tiers (GOLD/DIAMOND) are selected more often for block sealing, earning more relay fees.

### Stream 2 — Block Rewards (SEVEN per block)
SEVEN tokens are emitted each time your node seals a block. Higher tier = higher selection frequency.

### Stream 3 — Staking APR (paid daily in SEVEN)

| Tier | Minimum Stake | APR | Annual Earnings at $100/SEVEN |
|------|--------------|-----|-------------------------------|
| 🥉 **BRONZE** | 0 SEVEN | **8% / year** | Start free — earn block rewards + relay fees |
| 🥈 **SILVER** | 5,000 SEVEN | **12% / year** | 600 SEVEN/yr = **~$60,000/yr** |
| 🥇 **GOLD** | 10,000 SEVEN | **18% / year** | 1,800 SEVEN/yr = **~$180,000/yr** |
| 💎 **DIAMOND** | 50,000 SEVEN | **25% / year** | 12,500 SEVEN/yr = **~$1,250,000/yr** |

**Example DIAMOND validator at current prices:**
- 50,000 SEVEN staked × 25% APR = **12,500 SEVEN / year in staking rewards**
- 12,500 SEVEN × $100 = **$1,250,000/year** in staking alone
- Plus relay fees from every trade
- Plus block rewards from every block sealed

---

## 🛒 STEP 1 — Buy SEVEN Tokens

You need SEVEN to stake. Here are two ways to get it, step by step.

### Option A: Buy SEVEN on the Spot Market (fastest)

1. Go to **[theseven.meme/spot/seven](https://theseven.meme/spot/seven)**
2. Click **Connect Wallet** (top right) — supports MetaMask, Trust Wallet, Binance Wallet
3. Make sure you are on **Seven Chain (Chain ID 70007)**
   - MetaMask: Add network → RPC URL: `https://theseven.meme/api/seven-chain/jsonrpc` → Chain ID: `70007`
4. You need **sUSDT** to buy SEVEN. If you have sUSDT skip to step 6.
5. If you don't have sUSDT yet → Bridge from BNB Chain first (Option B below)
6. Enter the amount of SEVEN you want to buy
7. Click **Buy SEVEN** → confirm in your wallet
8. SEVEN lands in your wallet instantly

**Current price: ~$100 / SEVEN**

| Tier Target | SEVEN Needed | Cost at $100 |
|-------------|-------------|--------------|
| BRONZE | 0 | Free |
| SILVER | 5,000 SEVEN | ~$500,000 |
| GOLD | 10,000 SEVEN | ~$1,000,000 |
| DIAMOND | 50,000 SEVEN | ~$5,000,000 |

### Option B: Bridge USDT/BNB from BNB Chain

1. Go to **[theseven.meme/bridge](https://theseven.meme/bridge)**
2. Connect your wallet (must have BNB or USDT on BSC Mainnet)
3. Select direction: **BSC → Seven Chain**
4. Select token: **USDT** or **BNB**
5. Enter amount (minimum 1 USDT)
6. Click **Bridge** → confirm the BSC transaction in your wallet
7. Wait ~30 seconds → solver fills your order → sUSDT appears in your Seven Chain wallet
8. Now go to **[theseven.meme/spot/seven](https://theseven.meme/spot/seven)** and buy SEVEN with your sUSDT

---

## 🥩 STEP 2 — Stake SEVEN & Register Your Node

> **No approval needed. Instant activation. Fully self-service.**

1. Go to **[theseven.meme/staking](https://theseven.meme/staking)**
2. Click **Connect Wallet**
3. Choose your **Validator Tier**:
   - BRONZE = free, 8% APR
   - SILVER = 5,000 SEVEN, 12% APR
   - GOLD = 10,000 SEVEN, 18% APR
   - DIAMOND = 50,000 SEVEN, 25% APR
4. Enter your **stake amount** (must be ≥ tier minimum)
5. Enter your **Node RPC URL**: `http://YOUR_SERVER_IP:8545`
   - This is the public IP address of your validator server
   - Port 8545 must be open (see STEP 3 below)
6. Click **Stake & Register**
7. Confirm the transaction in your wallet
8. The platform immediately:
   - Stakes your SEVEN
   - Registers your node in the validator registry
   - Pings your RPC to verify it responds with Chain ID 70007
   - Sets your status → **ACTIVE** ✅

**Check your status:**
```bash
curl "https://theseven.meme/api/validators/0xYOUR_WALLET" | python3 -m json.tool
```

---

## 🖥️ STEP 3 — Install & Run Your Validator Node

### 3a. Get a Server

Any cloud VPS works. Recommended providers:

| Provider | Droplet | Monthly Cost |
|----------|---------|-------------|
| DigitalOcean | 2 vCPU / 4GB / 80GB SSD | ~$24/mo |
| Hetzner | CX21 (2 vCPU / 4GB) | ~$6/mo |
| Vultr | 2 vCPU / 4GB / 80GB | ~$20/mo |

**Operating system: Ubuntu 22.04 LTS or Ubuntu 24.04 LTS**

### 3b. Open Required Ports

```bash
sudo ufw allow 22/tcp    # SSH — always keep this open
sudo ufw allow 8545/tcp  # Seven Chain RPC — REQUIRED for platform ping
sudo ufw allow 30303/tcp # P2P sync — optional but recommended
sudo ufw enable
sudo ufw status
```

### 3c. Install Node.js 20

```bash
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs git
node --version   # Should print v20.x.x
npm --version    # Should print 10.x.x
```

### 3d. Clone This Repository

```bash
git clone https://github.com/umairkhan2582/seven-chain-node.git
cd seven-chain-node
npm install
```

### 3e. Configure Your Node

```bash
# Copy the example config
cp config.toml config.local.toml

# Edit it — change HTTPHost to 0.0.0.0 so the platform can reach you
nano config.local.toml
```

Find and change this line:
```toml
# CHANGE THIS:
HTTPHost = "127.0.0.1"

# TO THIS (allows platform to ping your node):
HTTPHost = "0.0.0.0"
HTTPPort = 8545
```

### 3f. Initialize Genesis Block

```bash
npm run init-genesis
```

Expected output:
```
INFO Successfully wrote genesis state
INFO Genesis block written (chain 70007)
```

### 3g. Start Your Node

```bash
# Start in the background
npm start &

# Wait 5 seconds for startup, then verify
sleep 5
curl -s http://localhost:8545 \
  -X POST \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","method":"eth_chainId","params":[],"id":1}'
```

Expected response:
```json
{"jsonrpc":"2.0","id":1,"result":"0x1117f"}
```
> `0x1117f` in decimal = **70007** = Seven Chain ✅

**Now test that it's reachable from the outside:**
```bash
# Run this from your laptop or any other machine — NOT from the server itself
curl -s http://YOUR_SERVER_IP:8545 \
  -X POST \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","method":"net_version","params":[],"id":1}'
# Expected: {"result":"70007"}
```

### 3h. Run Node as systemd Service (Recommended)

This keeps your node running 24/7 and auto-restarts if it crashes:

```bash
sudo tee /etc/systemd/system/seven-chain.service > /dev/null << EOF
[Unit]
Description=Seven Chain Validator Node
After=network-online.target
Wants=network-online.target

[Service]
WorkingDirectory=/root/seven-chain-node
ExecStart=/usr/bin/npm start
Restart=always
RestartSec=5
StandardOutput=journal
StandardError=journal
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOF

# Enable and start
sudo systemctl daemon-reload
sudo systemctl enable seven-chain
sudo systemctl start seven-chain

# Verify it's running
sudo systemctl status seven-chain

# View live logs
sudo journalctl -u seven-chain -f
```

---

## 💓 STEP 4 — Set Up the Heartbeat (Keep Node Active)

Your node must send a heartbeat to the platform every **30 seconds** to stay in `active` status. Without it, your node will go inactive and stop earning relay fees.

### Option A: Built-in heartbeat script

```bash
npm run heartbeat -- \
  --wallet 0xYOUR_WALLET_ADDRESS \
  --rpc    http://YOUR_SERVER_IP:8545
```

### Option B: systemd service (recommended for 24/7)

```bash
sudo tee /etc/systemd/system/seven-heartbeat.service > /dev/null << EOF
[Unit]
Description=Seven Chain Validator Heartbeat
After=network.target

[Service]
WorkingDirectory=/root/seven-chain-node
ExecStart=/usr/bin/npm run heartbeat -- --wallet 0xYOUR_WALLET --rpc http://YOUR_IP:8545
Restart=always
RestartSec=10
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable seven-heartbeat
sudo systemctl start seven-heartbeat
sudo systemctl status seven-heartbeat
```

### Option C: Manual curl loop

```bash
while true; do
  curl -s -X POST https://theseven.meme/api/node-heartbeat \
    -H "Content-Type: application/json" \
    -d '{"walletAddress":"0xYOUR_WALLET","rpcUrl":"http://YOUR_IP:8545","nodeVersion":"1.0.0"}' \
    > /dev/null
  echo "Heartbeat sent at $(date)"
  sleep 30
done
```

---

## ✅ STEP 5 — Verify Your Node Is Active

```bash
# Check node status
curl "https://theseven.meme/api/validators/0xYOUR_WALLET" | python3 -m json.tool

# Check systemd services are both running
systemctl is-active seven-chain       # should print: active
systemctl is-active seven-heartbeat   # should print: active

# Check chain ID one more time
curl -s http://localhost:8545 -X POST \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","method":"eth_chainId","params":[],"id":1}'
# Must return: {"result":"0x1117f"}
```

View your live dashboard and earnings at: **[theseven.meme/staking](https://theseven.meme/staking)**

---

## ⚡ Quick Summary — Complete Flow

```
1. Buy SEVEN    → theseven.meme/spot/seven   (or bridge at theseven.meme/bridge)
       ↓
2. Stake + Register → theseven.meme/staking
       Enter stake amount + your Node RPC URL (http://YOUR_IP:8545)
       ↓
3. Install node
       git clone + npm install + set HTTPHost=0.0.0.0 + npm run init-genesis + npm start
       ↓
4. Run heartbeat service
       npm run heartbeat -- --wallet 0x... --rpc http://YOUR_IP:8545
       (or install as systemd service)
       ↓
5. STATUS: ACTIVE ✅
       Earn relay fees + block rewards + staking APR automatically
```

---

## 🏗️ System Requirements

| Component | Minimum | Recommended |
|-----------|---------|-------------|
| OS | Ubuntu 22.04 LTS | Ubuntu 24.04 LTS |
| CPU | 2 vCPUs | 4+ vCPUs |
| RAM | 4 GB | 8 GB |
| Disk | 50 GB SSD | 200 GB NVMe |
| Bandwidth | 25 Mbps | 100 Mbps |
| Port 8545 | **Must be open** | + port 30303 |

---

## 🔗 Useful Links

| What | URL |
|------|-----|
| 🛒 Buy SEVEN | [theseven.meme/spot/seven](https://theseven.meme/spot/seven) |
| 🥩 Stake & Register | [theseven.meme/staking](https://theseven.meme/staking) |
| 🌉 Bridge from BNB | [theseven.meme/bridge](https://theseven.meme/bridge) |
| 📈 Exchange | [theseven.meme](https://theseven.meme) |
| 💬 Telegram | [t.me/thesevenmeme](https://t.me/thesevenmeme) |
| 📧 Support | support@theseven.meme |

---

## 🔧 Troubleshooting

| Problem | Fix |
|---------|-----|
| Platform says "not reachable" after staking | `sudo ufw allow 8545/tcp && sudo ufw reload` — then test from outside the server |
| Status stuck on "approved" not "active" | Confirm port 8545 is publicly reachable from a different machine |
| `eth_chainId` returns wrong chain | Re-run `npm run init-genesis` then restart node |
| Heartbeat service fails to start | Double-check wallet address is `0x` + 40 hex characters |
| Don't have sUSDT to buy SEVEN | Bridge USDT from BSC at [theseven.meme/bridge](https://theseven.meme/bridge) |
| Node crashes on startup | Check logs: `journalctl -u seven-chain -n 50` |

---

## 🔗 Related Repositories

| Repo | Purpose |
|------|---------|
| [seven-chain-node](https://github.com/umairkhan2582/seven-chain-node) | This repo — validator node |
| [seven-chain-solver](https://github.com/umairkhan2582/seven-chain-solver) | Bridge solver — relay cross-chain intents |

---

*Seven Chain Validator Node — Updated May 20, 2026*
*Seal blocks. Earn fees. Power the chain.*
