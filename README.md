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
     │  rpc-testnet.theseven.meme:443                   │
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

## Quick Start — Full Testnet Deployment

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
bash scripts/setup-nginx.sh rpc-testnet.theseven.meme admin@theseven.meme
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
```
SEVEN_CHAIN_RPC_URL=https://rpc-testnet.theseven.meme
```

The platform will automatically detect the real RPC and use it for:
- Writing trade transactions on-chain
- Querying live block data for the explorer
- Verifying transaction hashes

---

## Network Details

| Parameter | Value |
|---|---|
| Chain ID | 70007 |
| Network Name | Seven Chain Testnet |
| Currency Symbol | tBNB (testnet) |
| Block Time | 3 seconds |
| Consensus | Parlia (Proof of Staked Authority) |
| Public RPC | https://rpc-testnet.theseven.meme |
| Public WSS | wss://rpc-testnet.theseven.meme/ws |
| Explorer | https://theseven.meme/blockchain/explorer |
| Native Gas | 0 gwei (gasless for traders) |

### Add to MetaMask

1. Open MetaMask → Settings → Networks → Add Network
2. Enter:
   - Network Name: `Seven Chain Testnet`
   - RPC URL: `https://rpc-testnet.theseven.meme`
   - Chain ID: `70007`
   - Currency Symbol: `tBNB`
   - Explorer URL: `https://theseven.meme/blockchain/explorer`

---

## Validator Economics

### Testnet

Each transaction on Seven Chain is signed with 3 gwei gas price and 150,000 gas limit, making each trade ≈ **0.00045 tBNB** in gas fees routed through validator nodes. tBNB has no real-world value on testnet.

Gas fees on testnet are pre-paid by the platform on behalf of traders (zero-fee UX for users), and are split equally among active validators sealing blocks.

### Mainnet (Phase 5)

- Gas model: 3 gwei × 150,000 gas = 0.00045 BNB per trade (real BNB)
- Validators accumulate fees in their coinbase address automatically
- No manual claiming required — fees credit on every block proposal

### Validator rewards are transparent

All fee accumulation is visible on-chain. You can track your validator coinbase balance at any time via the RPC or block explorer.

---

## Security

- **Validator private keys**: Stored in encrypted keystore, never in code or git
- **P2P only**: Validators are not directly reachable from internet (only via port 30303)
- **RPC node**: Separate from validators, sits behind Nginx with rate limiting
- **Firewall**: UFW configured on all nodes — only necessary ports open
- **Fail2Ban**: Installed on all nodes to block SSH brute force

### What to NEVER commit

- Private keys (`*.key`, `keystore.*`, `.env`)
- Keystore password files (`*.pass`)
- Validator environment files (`validator.env`)

The `.gitignore` is already configured to block these.

---

## Docker (for local testing)

```bash
# Build and start 3-node local testnet
cd docker
cp .env.example .env
# Edit .env with your validator addresses

docker-compose up -d

# Check block production
bash ../scripts/healthcheck.sh http://localhost:8545
```

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
- [x] Phase 2: Seven Chain Testnet — **Live** (Chain ID 70007, 3 validator nodes)
- [ ] Phase 3: Public validator onboarding + staking contracts
- [ ] Phase 4: Mainnet with SEVEN/USDT as native gas token

---

**TheSeven.meme Ltd**
