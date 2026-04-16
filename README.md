# Seven Chain — Validator Node

**Chain ID: 70007 | EVM-Compatible | BSC Fork | Parlia Consensus**

The Seven Chain is the public settlement ledger for [TheSeven.meme](https://theseven.meme) perpetual futures platform. Every trade open, close, liquidation, and profit payout is written as an immutable transaction on this chain.

Apply to run a validator node: [theseven.meme/become-validator](https://theseven.meme/become-validator)

---

## Architecture

```
                ┌─────────────────────────────────┐
                │        TheSeven.meme App          │
                │  (React + Express + PostgreSQL)   │
                └──────────────┬──────────────────┘
                               │ JSON-RPC
                               ▼
     ┌─────────────────────────────────────────────────┐
     │            Seven Chain (Chain ID: 70007)          │
     │                                                   │
     │  ┌──────────┐  ┌──────────┐  ┌──────────┐       │
     │  │ Node 1   │  │ Node 2   │  │ Node 3   │       │
     │  │Validator │◄─►Validator │◄─►Validator │       │
     │  │DO $12/mo │  │DO $12/mo │  │DO $12/mo │       │
     │  └────┬─────┘  └──────────┘  └──────────┘       │
     │       │ Public RPC (Nginx + SSL)                  │
     │       ▼                                           │
     │  https://theseven.meme/api/seven-chain/jsonrpc   │
     └─────────────────────────────────────────────────┘
```

---

## One-Command Install

The fastest way to get a Seven Chain validator running on a fresh Ubuntu 22.04 VPS:

```bash
bash <(curl -s https://raw.githubusercontent.com/umairkhan2582/seven-chain-node/main/scripts/install.sh)
```

This single command:
- Installs the BSC/Geth binary (Go Ethereum fork)
- Configures Nginx with SSL and rate limiting
- Sets up UFW firewall rules (ports 30303 TCP/UDP for P2P, 443 for RPC)
- Installs Fail2Ban for SSH protection
- Creates and enables a `seven-chain` systemd service

After the installer finishes, import your validator key and start the node:

```bash
bash scripts/import-key.sh 0xYOUR_VALIDATOR_PRIVATE_KEY
systemctl start seven-chain
```

---

## Quick Start — Mainnet Validator Setup

### Step 1: Generate Validator Keys (run once, locally)

```bash
node scripts/generate-keys.js 3
```

Copy the output. Keep private keys secure — never commit them.

### Step 2: Update Genesis Block

Edit `genesis.json`:
1. Replace `VALIDATOR_1_ADDRESS`, `VALIDATOR_2_ADDRESS`, `VALIDATOR_3_ADDRESS` with your generated addresses
2. Replace `extraData` with the generated value from `generate-keys.js`
3. Replace `alloc` keys with your actual addresses

### Step 3: Provision 3 VPS Droplets

- **Specs**: $12/month — 2 GB RAM, 2 vCPU, 60 GB SSD — Ubuntu 22.04 LTS
- **Regions**: Choose 3 different regions for redundancy (e.g. NYC1, FRA1, SGP1)
- **Label them**: `seven-validator-1`, `seven-validator-2`, `seven-validator-3`

Recommended providers: DigitalOcean, Linode, Vultr, Hetzner.

### Step 4: Install on Each Node

```bash
# SSH into each node
ssh root@YOUR_SERVER_IP

# Clone this repo
git clone https://github.com/umairkhan2582/seven-chain-node.git
cd seven-chain-node

# Install (installs BSC binary, Nginx, UFW, systemd service)
bash scripts/install.sh

# Import your validator key
bash scripts/import-key.sh 0xYOUR_VALIDATOR_PRIVATE_KEY

# Configure environment
cp /etc/seven-chain/validator.env.example /etc/seven-chain/validator.env
nano /etc/seven-chain/validator.env
# Fill in: VALIDATOR_ADDRESS and BOOTNODE_ENODE
```

### Step 5: Set Up Public RPC (on Node 1 only)

```bash
bash scripts/setup-nginx.sh rpc.theseven.meme admin@theseven.meme
```

This configures Nginx with SSL, rate limiting (50 req/s per IP), and CORS for public access.

### Step 6: Start Validators

```bash
# On each node
systemctl start seven-chain
systemctl status seven-chain

# Check health
bash scripts/healthcheck.sh
```

### Step 7: Connect the Platform

Set the following environment variable in your deployment:

```bash
SEVEN_CHAIN_RPC_URL=https://theseven.meme/api/seven-chain/jsonrpc
```

Or register your node at [theseven.meme/become-validator](https://theseven.meme/become-validator) and the platform will auto-detect it via the health monitor.

---

## Monitoring

### Check all nodes at once

```bash
for IP in NODE1_IP NODE2_IP NODE3_IP; do
  echo "=== $IP ===" && bash scripts/healthcheck.sh "http://${IP}:8545"
done
```

### View logs

```bash
journalctl -u seven-chain -f
# or
tail -f /data/seven-chain/logs/seven-chain.log
```

### Check peer connectivity

```bash
curl -sf -X POST -H "Content-Type: application/json" \
  --data '{"jsonrpc":"2.0","method":"admin_peers","params":[],"id":1}' \
  http://localhost:8545 | jq '.result | length'
# Should return 2 (for a 3-node setup)
```

---

## Apply to Become a Validator

We are actively recruiting validator operators worldwide. To apply:

- **Web form**: [theseven.meme/become-validator](https://theseven.meme/become-validator)
- **Email**: support@theseven.meme

Minimum requirements: Ubuntu 22.04 LTS, 2 vCPU, 2 GB RAM, 60 GB SSD.

---

## Roadmap

- [x] Phase 1: Internal DB ledger (production)
- [x] Phase 2: Seven Chain Mainnet — **Live** (Chain ID 70007, Parlia PoA)
- [ ] Phase 3: Public validator onboarding + staking contracts
- [ ] Phase 4: SEVEN/USDT as native gas token

---

**TheSeven.meme Ltd**
