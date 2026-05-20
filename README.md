<div align="center">

# ⛓️ Seven Chain — Validator Node

### **🟢 MAINNET LIVE · Chain ID 70007 · Updated May 20, 2026**

[![Chain ID](https://img.shields.io/badge/Chain%20ID-70007-22c55e?style=for-the-badge&logo=ethereum)](https://theseven.meme)
[![Consensus](https://img.shields.io/badge/Consensus-Parlia%20PoSA-blue?style=for-the-badge)](https://theseven.meme/staking)
[![Staking](https://img.shields.io/badge/Stake%20SEVEN-Earn%20Up%20to%2025%25%20APR-gold?style=for-the-badge)](https://theseven.meme/staking)
[![Buy SEVEN](https://img.shields.io/badge/Buy%20SEVEN-Spot%20Market-orange?style=for-the-badge)](https://theseven.meme/spot/seven)
[![License](https://img.shields.io/badge/License-MIT-gray?style=for-the-badge)](LICENSE)

**Validate blocks on Seven Chain and earn relay fees from every futures trade, meme token swap, and transfer settled on-chain.**

[🏦 Buy SEVEN](https://theseven.meme/spot/seven) • [🥩 Stake & Validate](https://theseven.meme/staking) • [🌉 Bridge Assets](https://theseven.meme/bridge) • [📈 Exchange](https://theseven.meme) • [💬 Telegram](https://t.me/thesevenmeme)

</div>

---

## ⚡ What Is a Seven Chain Validator?

Seven Chain is the settlement ledger for [TheSeven.meme](https://theseven.meme) — a perpetual futures exchange with up to 2001× leverage, a meme token launchpad, and a P2P market. Every trade open, close, liquidation, profit payout, meme token buy/sell, and sUSDT transfer is written as an immutable on-chain transaction.

**Validators seal these blocks.** In return you earn:

| Revenue Stream | How You Earn |
|---|---|
| 🔁 **Relay fees** | 0.0004 BNB per trade opened by a BNB/ETH bridge user |
| 🏆 **Block rewards** | SEVEN emitted per block you seal |
| 📈 **Staking APR** | 8 – 25% annually on your staked SEVEN (paid in SEVEN) |

> **Example:** A DIAMOND validator with 50,000 SEVEN staked (~$5M at $100/SEVEN) earns 25% APR = 12,500 SEVEN/year + block rewards + relay fees from every trade.

---

## 💰 Validator Tiers & Earnings

| Tier | Min Stake | Staking APR | Block Rewards | Priority |
|------|-----------|-------------|---------------|----------|
| 🥉 **BRONZE** | 0 SEVEN | 8% / year | ✅ Yes | Standard |
| 🥈 **SILVER** | 5,000 SEVEN | 12% / year | ✅ Yes | Medium |
| 🥇 **GOLD** | 10,000 SEVEN | 18% / year | ✅ Yes | High |
| 💎 **DIAMOND** | 50,000 SEVEN | 25% / year | ✅ Yes | Maximum |

> Staking APR is paid in SEVEN tokens. All tiers earn relay fees. Higher tiers are selected more often to seal blocks.

---

## 🛒 Step 0 — Get SEVEN Tokens

You need SEVEN to stake. Two ways to get it:

### Option A — Buy on Spot Market (fastest)
1. Go to **[theseven.meme/spot/seven](https://theseven.meme/spot/seven)**
2. Connect your wallet
3. Buy SEVEN with sUSDT at the live market price (~$100 / SEVEN)

### Option B — Bridge from BNB Chain
1. Go to **[theseven.meme/bridge](https://theseven.meme/bridge)**
2. Bridge USDT or BNB from BSC → Seven Chain (receive sUSDT)
3. Buy SEVEN on **[theseven.meme/spot/seven](https://theseven.meme/spot/seven)** with your sUSDT

> **No SEVEN needed for BRONZE.** You can register with 0 stake and upgrade your tier later.

---

## 🚀 Fully Self-Service Onboarding — No Human Approval Required

From zero to active validator in under 5 minutes. No emails. No waiting for admin. No approval.

```
1. Buy or bridge SEVEN to theseven.meme wallet
          ↓
2. theseven.meme/staking → choose tier → enter stake amount + your node RPC URL
          ↓
3. Platform auto-registers your node + pings it immediately
          ↓  (if your node is reachable)
4. Status → ACTIVE instantly
          ↓
5. Your node sends POST heartbeat every 30s → stays active forever
          ↓
6. Earn block rewards + relay fees + staking APR
```

> See [ONBOARDING.md](ONBOARDING.md) for the complete step-by-step guide with commands.

---

## 🖥️ Run Your Validator Node

### Requirements

| Component | Minimum | Recommended |
|-----------|---------|-------------|
| OS | Ubuntu 22.04 LTS | Ubuntu 24.04 LTS |
| CPU | 2 vCPUs | 4+ vCPUs |
| RAM | 4 GB | 8 GB |
| Disk | 50 GB SSD | 200 GB NVMe |
| Network | 25 Mbps | 100 Mbps |
| Open ports | 8545 (RPC) | 8545 + 30303 (P2P) |

### Quick Start

```bash
# 1. Clone this repo
git clone https://github.com/umairkhan2582/seven-chain-node.git
cd seven-chain-node

# 2. Install Node.js 18+
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs

# 3. Install dependencies
npm install

# 4. Configure your node (copy example config)
cp config.toml config.local.toml
nano config.local.toml  # set your IP, ports

# 5. Initialize genesis block
npm run init-genesis

# 6. Start your node
npm start

# 7. Register as validator at:
#    https://theseven.meme/staking
#    Enter your node RPC URL (e.g. http://YOUR_SERVER_IP:8545)
```

> Full setup guide: [VALIDATOR_SETUP.md](VALIDATOR_SETUP.md)

---

## 🔄 Heartbeat — Staying Active

Your node must send a heartbeat to the platform every 30 seconds to stay in `active` status. The platform uses this to know your node is online and eligible for block selection.

```bash
# One-liner heartbeat (run this from your node server)
while true; do
  curl -s -X POST https://theseven.meme/api/node-heartbeat \
    -H "Content-Type: application/json" \
    -d '{"walletAddress":"0xYOUR_WALLET","rpcUrl":"http://YOUR_IP:8545","nodeVersion":"1.0.0"}' \
    > /dev/null
  sleep 30
done
```

Or use the built-in heartbeat daemon that comes with this package:

```bash
npm run heartbeat -- --wallet 0xYOUR_WALLET --rpc http://YOUR_IP:8545
```

---

## 📊 Monitor Your Node

After staking, your node appears on the validator dashboard. Check your status anytime:

```bash
# Check node status via API
curl https://theseven.meme/api/validators/status/0xYOUR_WALLET | python3 -m json.tool
```

Live dashboard: **[theseven.meme/staking](https://theseven.meme/staking)**

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    TheSeven.meme Exchange                     │
│  Futures │ Meme Launchpad │ Spot SEVEN │ P2P Market          │
└──────────────────────┬──────────────────────────────────────┘
                       │ Every trade/transfer/settlement
                       ▼
┌─────────────────────────────────────────────────────────────┐
│                 Seven Chain (Chain ID 70007)                  │
│          BSC-compatible · Parlia PoSA Consensus              │
│                                                               │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐   │
│  │Validator │  │Validator │  │Validator │  │Validator │   │
│  │ (Bronze) │  │ (Silver) │  │  (Gold)  │  │(Diamond) │   │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘   │
└─────────────────────────────────────────────────────────────┘
                       │ Settled blocks
                       ▼
┌─────────────────────────────────────────────────────────────┐
│              BNB Chain Bridge (SevenBridgeLock v3)           │
│        0x41A70A6bE222174D8369A90fE91017E8Fb74606f           │
└─────────────────────────────────────────────────────────────┘
```

---

## 🔗 Related Repositories

| Repo | Purpose |
|------|---------|
| [seven-chain-node](https://github.com/umairkhan2582/seven-chain-node) | This repo — validator node setup |
| [seven-chain-solver](https://github.com/umairkhan2582/seven-chain-solver) | Bridge solver — relay cross-chain intents |

---

## 📞 Contact & Support

| Channel | Link |
|---------|------|
| 🌐 Exchange | [theseven.meme](https://theseven.meme) |
| 🥩 Staking | [theseven.meme/staking](https://theseven.meme/staking) |
| 🛒 Buy SEVEN | [theseven.meme/spot/seven](https://theseven.meme/spot/seven) |
| 💬 Telegram | [t.me/thesevenmeme](https://t.me/thesevenmeme) |
| 📧 Support | support@theseven.meme |

---

<div align="center">

*Seven Chain Validator Node — Updated May 20, 2026*

*Seal blocks. Earn fees. Power the chain.*

</div>
