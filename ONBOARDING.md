# Seven Chain — Validator Onboarding

> **Updated: May 20, 2026 — Zero human interaction. Active in under 5 minutes.**

---

## The Flow

```
STEP 0  Get SEVEN tokens
          theseven.meme/spot/seven  (buy with sUSDT)
          theseven.meme/bridge      (bridge USDT from BNB Chain first)
            |
STEP 1  Spin up a VPS — Ubuntu 22.04+, port 8545 open
            |
STEP 2  Clone repo + npm install + configure HTTPHost = "0.0.0.0"
            |
STEP 3  npm run init-genesis && npm start
          Verify: curl localhost:8545 returns chain ID 0x1117f (70007)
            |
STEP 4  theseven.meme/staking
          Connect wallet → choose tier → enter stake + RPC URL
          Click "Stake & Register"
            |
STEP 5  Platform auto-registers node
          Pings RPC immediately
          If chain ID 70007 confirmed → STATUS: ACTIVE instantly
            |
STEP 6  npm run heartbeat -- --wallet 0xYOUR_WALLET --rpc http://YOUR_IP:8545
          Runs every 30 seconds forever
          OR install systemd service (see VALIDATOR_SETUP.md)
            |
STEP 7  Earn automatically
          Block rewards  — per block sealed
          Relay fees     — 0.0004 BNB per bridged trade opened
          Staking APR    — 8-25%/yr on staked SEVEN
```

---

## Step 0 — Get SEVEN

### Buy on Spot Market
1. Go to **[theseven.meme/spot/seven](https://theseven.meme/spot/seven)**
2. Connect MetaMask or Binance Wallet
3. Buy SEVEN with sUSDT

### Bridge First (if you have BNB/USDT on BNB Chain)
1. Go to **[theseven.meme/bridge](https://theseven.meme/bridge)**
2. Select BSC → Seven Chain, enter amount, confirm
3. Solver fills within ~30 seconds
4. Use sUSDT to buy SEVEN at **[theseven.meme/spot/seven](https://theseven.meme/spot/seven)**

### Tier Selection
| Tier    | Stake     | APR    |
|---------|-----------|--------|
| BRONZE  | 0 SEVEN   | 8%/yr  |
| SILVER  | 5,000     | 12%/yr |
| GOLD    | 10,000    | 18%/yr |
| DIAMOND | 50,000    | 25%/yr |

> Start with BRONZE (free) — upgrade anytime at theseven.meme/staking

---

## Step 1 — VPS Setup

```bash
sudo ufw allow 22/tcp && sudo ufw allow 8545/tcp && sudo ufw enable
```

Any cloud provider works: DigitalOcean, Hetzner, Vultr, AWS Lightsail.
Minimum: 2 vCPU / 4 GB RAM / 50 GB SSD.

---

## Step 2 — Install

```bash
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs git
git clone https://github.com/umairkhan2582/seven-chain-node.git
cd seven-chain-node && npm install
cp config.toml config.local.toml
# Edit config.local.toml: HTTPHost = "0.0.0.0"
```

---

## Step 3 — Start Node

```bash
npm run init-genesis
npm start &
curl -s http://localhost:8545 -X POST -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","method":"eth_chainId","params":[],"id":1}'
# Must return: {"result":"0x1117f"}
```

---

## Step 4 — Register at theseven.meme/staking

1. **[theseven.meme/staking](https://theseven.meme/staking)**
2. Connect wallet → select tier → enter stake + `http://YOUR_IP:8545`
3. Click **Stake & Register**

---

## Step 5 — Instant Activation

```
Platform receives your form
  -> Stakes SEVEN on-chain
  -> Registers node in validator DB
  -> Pings http://YOUR_IP:8545 with eth_chainId
  -> Response = 70007 -> STATUS: "active"

No email. No approval. Instant.
```

Check status:
```bash
curl "https://theseven.meme/api/validators/0xYOUR_WALLET" | python3 -m json.tool
```

---

## Step 6 — Heartbeat (systemd)

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
systemctl daemon-reload && systemctl enable --now seven-heartbeat
```

---

## Step 7 — Earnings Are Automatic

Once active, earnings accumulate without any action:

**Relay fees** — Every time a BNB/ETH bridge user opens a futures trade:
- They pay 0.0004 BNB
- It goes directly to your validator wallet

**Block rewards** — SEVEN emitted each block your node seals

**Staking APR** — Paid daily in SEVEN:
- BRONZE: 8%/yr
- SILVER (5k SEVEN): 12%/yr — ~$60,000/yr at $100/SEVEN
- GOLD (10k SEVEN): 18%/yr — ~$180,000/yr at $100/SEVEN
- DIAMOND (50k SEVEN): 25%/yr — ~$1,250,000/yr at $100/SEVEN

View your earnings at **[theseven.meme/staking](https://theseven.meme/staking)**

---

## Quick Reference

| What | URL |
|------|-----|
| Buy SEVEN | https://theseven.meme/spot/seven |
| Bridge from BNB | https://theseven.meme/bridge |
| Stake + Register | https://theseven.meme/staking |
| Monitor earnings | https://theseven.meme/staking |
| Telegram support | https://t.me/thesevenmeme |
| Email | support@theseven.meme |

---

*Seven Chain Validator Onboarding — Updated May 20, 2026*
*Zero human interaction. Permissionless. On-chain.*
