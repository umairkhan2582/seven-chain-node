# Seven Chain — Validator Onboarding Guide

> **Updated: May 20, 2026**  
> **Zero human interaction required. From zero to active validator in under 5 minutes.**

---

## The Complete Flow

```
STEP 0 ── Get SEVEN tokens
STEP 1 ── Spin up a server (any VPS)
STEP 2 ── Clone repo + configure node
STEP 3 ── Start node, confirm RPC is reachable
STEP 4 ── Go to theseven.meme/staking — stake SEVEN + enter your RPC URL
STEP 5 ── Platform auto-registers + pings your node → STATUS: ACTIVE
STEP 6 ── Node sends heartbeat every 30s → stays active forever
STEP 7 ── Earn block rewards + relay fees + staking APR
```

No approval emails. No waiting for admin. No Discord DMs. Fully on-chain and self-service.

---

## STEP 0 — Get SEVEN Tokens

### Option A: Buy on the Spot Market

1. Go to **[theseven.meme/spot/seven](https://theseven.meme/spot/seven)**
2. Connect your MetaMask or Binance Wallet
3. Enter the amount of SEVEN you want to buy
4. Pay with sUSDT — SEVEN lands in your platform wallet instantly

**Tier guide:**
| Tier | SEVEN Needed | USD Value (at $100/SEVEN) | APR |
|------|-------------|--------------------------|-----|
| 🥉 BRONZE | 0 | $0 — free to join | 8% |
| 🥈 SILVER | 5,000 | ~$500,000 | 12% |
| 🥇 GOLD | 10,000 | ~$1,000,000 | 18% |
| 💎 DIAMOND | 50,000 | ~$5,000,000 | 25% |

> Start with BRONZE (free) and upgrade later.

### Option B: Bridge from BNB Chain

1. Go to **[theseven.meme/bridge](https://theseven.meme/bridge)**
2. Select **BSC → Seven Chain**
3. Enter amount — minimum 1 USDT
4. Confirm the BSC transaction in your wallet
5. Solver fills within ~30 seconds → sUSDT appears in your Seven Chain wallet
6. Buy SEVEN with sUSDT at **[theseven.meme/spot/seven](https://theseven.meme/spot/seven)**

---

## STEP 1 — Spin Up a Server

Any VPS works — DigitalOcean, Hetzner, Vultr, AWS Lightsail.

**Minimum spec:**
- Ubuntu 22.04 or 24.04
- 2 vCPUs, 4 GB RAM, 50 GB SSD
- Open port 8545 (RPC) — required for the platform to ping your node

```bash
# Open port 8545
sudo ufw allow 8545/tcp
sudo ufw allow 30303/tcp   # optional: P2P sync
sudo ufw enable
```

---

## STEP 2 — Install Node Software

```bash
# Install Node.js 20
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs git

# Clone this repo
git clone https://github.com/umairkhan2582/seven-chain-node.git
cd seven-chain-node

# Install dependencies
npm install

# Copy example config
cp config.toml config.local.toml
```

Edit `config.local.toml` — set your external IP in `HTTPHost`:

```toml
[Node]
HTTPHost = "0.0.0.0"   # expose to internet so platform can ping
HTTPPort = 8545
```

---

## STEP 3 — Start Your Node

```bash
# Start node (keeps running in background)
npm start &

# Verify it is running
curl http://localhost:8545 -X POST \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","method":"eth_chainId","params":[],"id":1}'

# Expected response:
# {"jsonrpc":"2.0","id":1,"result":"0x1117f"}
# 0x1117f = 70007 (Seven Chain ID) ✅
```

**Your RPC URL is:** `http://YOUR_SERVER_IP:8545`

Confirm it is publicly reachable:
```bash
# From any other machine / your local laptop:
curl http://YOUR_SERVER_IP:8545 -X POST \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","method":"net_version","params":[],"id":1}'
# Expected: "result":"70007"
```

---

## STEP 4 — Stake SEVEN + Register Node

1. Go to **[theseven.meme/staking](https://theseven.meme/staking)**
2. Connect your wallet
3. Choose your tier (BRONZE is free to start)
4. Enter your stake amount
5. **Enter your Node RPC URL** — e.g. `http://45.67.89.10:8545`
6. Click **Stake & Register**

> This single form does everything: stakes your SEVEN, registers your node, and sends the first liveness ping.

---

## STEP 5 — Automatic Activation (No Waiting)

The moment you submit the staking form:

```
Platform receives stake + RPC URL
          ↓
Auto-registers node in validator_stakes DB
          ↓
Immediately pings your RPC: eth_chainId + net_version
          ↓
If your node responds with chain ID 70007:
  status → "active" ✅
If not yet reachable:
  status → "approved" (activates on first heartbeat)
```

**You receive no email. No one approves you. It is instant.**

Check your status:
```bash
curl "https://theseven.meme/api/validators/0xYOUR_WALLET" | python3 -m json.tool
```

---

## STEP 6 — Send Heartbeats (Stay Active)

Your node must send a heartbeat every 30 seconds. The heartbeat daemon is built in:

```bash
# Run in background
npm run heartbeat -- \
  --wallet 0xYOUR_WALLET_ADDRESS \
  --rpc    http://YOUR_SERVER_IP:8545
```

Or as a systemd service (recommended for 24/7 operation):

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

sudo systemctl daemon-reload
sudo systemctl enable --now seven-heartbeat
sudo systemctl status seven-heartbeat
```

The heartbeat endpoint:
```
POST https://theseven.meme/api/node-heartbeat
{
  "walletAddress": "0xYOUR_WALLET",
  "rpcUrl":        "http://YOUR_SERVER_IP:8545",
  "nodeVersion":   "1.0.0"
}
```

---

## STEP 7 — Earnings

Once active you earn automatically — no claiming, no manual steps.

### Block Rewards
Issued each time your node is selected to seal a block. Higher tiers are selected more often.

### Relay Fees
Every time a user without SEVEN opens a futures trade by bridging from BNB/ETH:
- They pay **0.0004 BNB** relay fee
- Your validator wallet receives the BNB

With 100 trades/day × 0.0004 BNB = **0.04 BNB/day** (~$24/day at current prices)  
With 1,000 trades/day = **0.4 BNB/day** (~$240/day)

### Staking APR
Paid daily in SEVEN based on your staked balance:
- BRONZE (0 SEVEN): 8% APR
- SILVER (5,000 SEVEN): 12% APR — +$60,000/year at $100/SEVEN
- GOLD (10,000 SEVEN): 18% APR — +$180,000/year at $100/SEVEN
- DIAMOND (50,000 SEVEN): 25% APR — +$1,250,000/year at $100/SEVEN

---

## Troubleshooting

| Problem | Fix |
|---------|-----|
| Status stuck on "approved" | Make sure port 8545 is open: `sudo ufw allow 8545/tcp` |
| Heartbeat fails | Check your node is running: `curl localhost:8545 -d '{"jsonrpc":"2.0","method":"eth_chainId","params":[],"id":1}'` |
| Wrong chain ID in response | Re-init genesis: `npm run init-genesis` |
| Can't buy SEVEN | Make sure you have sUSDT — bridge from BNB first at [theseven.meme/bridge](https://theseven.meme/bridge) |

---

## Quick Reference

| What | Where |
|------|-------|
| Buy SEVEN | https://theseven.meme/spot/seven |
| Bridge from BNB | https://theseven.meme/bridge |
| Stake + Register | https://theseven.meme/staking |
| Check node status | https://theseven.meme/staking |
| Telegram support | https://t.me/thesevenmeme |
| Email support | support@theseven.meme |

---

*Updated May 20, 2026 — Seven Chain Validator Team*
