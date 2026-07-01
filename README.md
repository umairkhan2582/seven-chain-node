<div align="center">

  <img src="https://theseven.meme/logo.png" width="100" alt="Seven Chain" />

  # 🔗 seven-chain-node

  **Run a Seven Chain Validator — Seal Blocks, Earn SEVEN + BNB Relay Fees**

  [![Chain ID](https://img.shields.io/badge/Chain%20ID-70007-FFD700?style=for-the-badge&logo=ethereum&logoColor=black)](https://theseven.meme/developers)
  [![Mainnet](https://img.shields.io/badge/Status-Mainnet%20Live-brightgreen?style=for-the-badge)](https://theseven.meme/seven-network)
  [![Version](https://img.shields.io/badge/Version-2.0.1-orange?style=for-the-badge)](https://theseven.meme/become-validator)
  [![Earn SEVEN](https://img.shields.io/badge/Earn-Block%20Rewards%20+%20Relay%20Fees-orange?style=for-the-badge)](https://theseven.meme/become-validator)
  [![License](https://img.shields.io/badge/License-MIT-blue?style=for-the-badge)](LICENSE)
  [![GitHub Topic](https://img.shields.io/badge/Topic-seven--chain-yellow?style=for-the-badge)](https://github.com/topics/seven-chain)

  [**Become a Validator**](https://theseven.meme/become-validator) · [**Block Explorer**](https://theseven.meme/blockchain/explorer) · [**Staking**](https://theseven.meme/staking) · [**Buy SEVEN**](https://theseven.meme/spot/seven) · [**Telegram**](https://t.me/SevenBlockChain)

</div>

---

## 🚀 v2.0.1 — May 2026

- **V3 Bridge live** — `0x41A70A6bE222174D8369A90fE91017E8Fb74606f` (non-upgradeable, no admin key)
- **Dynamic SEVEN price engine** — price moves in real-time on every on-chain trade
- **Validator reward system active** — block rewards pay 0.0003 SEVEN per block with real user transactions
- **Relay fee system active** — earn 0.0004 BNB per bridge trade relay
- **Staking multiplier live** — 1× – 3× earnings based on SEVEN staked

---

## What is a Seven Chain Validator?

Validators are the backbone of Seven Chain (Chain ID **70007**). They seal blocks and earn two streams of income simultaneously: SEVEN block rewards and BNB relay fees from the bridge. Seven Chain is in **early launch phase** — the genesis validator set is still forming. Joining now means lower competition and higher per-block yield.

| Metric | Value |
|---|---|
| **SEVEN per block** | 0.0003 SEVEN (blocks with real user transactions) |
| **BNB per bridge relay** | 0.0004 BNB per settled bridge intent |
| **Staking multiplier** | 1× – 3× based on SEVEN staked |
| **Registration** | Fully automatic via heartbeat — no approval needed |
| **Min server spec** | 2 vCPU · 4 GB RAM · 60 GB SSD · Linux |

### Why Join Now

The earlier you register, the more blocks you seal before the validator set expands. Genesis validators build a track record that compounds: more blocks sealed → more SEVEN earned → more staked → higher multiplier → even more SEVEN per block.

---

## How Relay Fees Work

Seven Chain uses a **micro-relay-fee** model — not gas auctions. When a user bridges assets from BNB Chain to Seven Chain:

1. A solver (or your validator node running the solver) detects the pending bridge intent
2. The solver verifies the source-chain lock on BSC
3. The solver submits a settlement proof to the V3 bridge contract on Seven Chain
4. Funds are released to the user
5. **0.0004 BNB is credited to the solver automatically** — no gas refund claim, no manual withdrawal

Running the [seven-chain-solver](https://github.com/umairkhan2582/seven-chain-solver) alongside your validator node lets you capture both income streams from a single server.

---

## Quick Start

```bash
# 1. Clone
git clone https://github.com/umairkhan2582/seven-chain-node
cd seven-chain-node

# 2. Install
npm install

# 3. Configure
cp .env.example .env
# Set WALLET_ADDRESS and RPC_URL in .env

# 4. Run
npm start
# Sends heartbeats every 30s — node registered automatically on first beat
```

Your node starts earning as soon as it's live. No approval. No waiting list.

### Docker

```bash
docker-compose up -d
```

The Docker image handles restarts automatically so your node stays online through server reboots.

---

## How Block Rewards Work

```
Every 30 seconds:
  └─ Your node sends heartbeat → POST /api/node-heartbeat

Each block with a real user transaction:
  └─ Platform credits 0.0003 SEVEN × your staking multiplier to your validator wallet

Each bridge intent you settle (if running the solver):
  └─ 0.0004 BNB credited automatically in the settlement transaction
```

1. Your node sends a heartbeat every 30 seconds to `/api/node-heartbeat`
2. The platform records your node as active in the validator registry
3. Every block containing a real user transaction credits **0.0003 SEVEN** to your validator wallet on-chain
4. Stake SEVEN at [theseven.meme/staking](https://theseven.meme/staking) to multiply your rewards up to **3×**
5. Run [seven-chain-solver](https://github.com/umairkhan2582/seven-chain-solver) on the same server to also earn **0.0004 BNB** per bridge relay

---

## Register Your Node

Registration is **fully automatic** via heartbeat — your first heartbeat registers the node. Alternatively, register manually via API:

```bash
curl -X POST https://theseven.meme/api/node-register \
  -H "Content-Type: application/json" \
  -d '{
    "walletAddress": "0xYOUR_WALLET",
    "rpcUrl": "http://YOUR_SERVER_IP/rpc",
    "name": "My Validator Node"
  }'
# → { "success": true, "message": "Node registered." }
```

No form. No email. No waiting period.

---

## Maximize Your Earnings — Staking

Staking SEVEN multiplies your per-block earnings. The multiplier scales linearly from 1× (no stake) to 3× (maximum stake tier).

```
Earnings per block (unstaked):      0.0003 SEVEN
Earnings per block (max stake 3×):  0.0009 SEVEN
```

Buy SEVEN → [theseven.meme/spot/seven](https://theseven.meme/spot/seven)
Stake SEVEN → [theseven.meme/staking](https://theseven.meme/staking)

---

## Network Details

| Parameter | Value |
|---|---|
| **Network Name** | Seven Chain |
| **Chain ID** | 70007 |
| **RPC URL** | `https://theseven.meme/api/seven-chain/jsonrpc` |
| **Currency Symbol** | SEVEN |
| **Block Explorer** | https://theseven.meme/blockchain/explorer |

---

## Bridge — V3 Contract (Non-Upgradeable)

| Network | Contract Address |
|---|---|
| **BNB Chain — source lock** | `0x41A70A6bE222174D8369A90fE91017E8Fb74606f` |
| **Seven Chain — receiver** | `0x968A78d10C7A8b05822FA4ED2F6ECC46a9102afE` |

The V3 contract has no admin key, no pause function, no upgrade proxy. The bytecode is final. Validators participate in settling bridge intents — run [seven-chain-solver](https://github.com/umairkhan2582/seven-chain-solver) alongside your node to capture bridge relay fees.

---

## Server Requirements

| Requirement | Minimum | Recommended |
|---|---|---|
| OS | Ubuntu 20.04+ / Debian 11+ | Ubuntu 22.04 LTS |
| CPU | 2 vCPU | 4 vCPU |
| RAM | 4 GB | 8 GB |
| SSD | 60 GB | 100 GB |
| Network | 100 Mbps | 1 Gbps |
| Node.js | 20+ | 22 LTS |

Any Linux VPS works — DigitalOcean, Hetzner, AWS, Vultr, or your own bare metal.

---

## Seven Chain Ecosystem

| Repo | Description |
|---|---|
| [**sevenchain**](https://github.com/umairkhan2582/sevenchain) | Developer hub — network config, Hardhat/Foundry quickstart, API docs |
| [**seven-chain-node**](https://github.com/umairkhan2582/seven-chain-node) | ← You are here — validator node client |
| [**seven-chain-solver**](https://github.com/umairkhan2582/seven-chain-solver) | Bridge solver — run alongside this node to earn BNB relay fees |
| [**seven-creator-kit**](https://github.com/umairkhan2582/seven-creator-kit) | Token launch toolkit — deploy meme tokens, migrate from pump.fun/four.meme |
| [**seven-gaming-sdk**](https://github.com/umairkhan2582/seven-gaming-sdk) | Gaming SDK — 1s finality on-chain games, session keys, Unreal Engine plugin |

All repositories: [`github.com/topics/seven-chain`](https://github.com/topics/seven-chain)

---

## Links

| Resource | URL |
|---|---|
| Platform | https://theseven.meme |
| Become a Validator | https://theseven.meme/become-validator |
| Staking | https://theseven.meme/staking |
| Buy SEVEN | https://theseven.meme/spot/seven |
| Block Explorer | https://theseven.meme/blockchain/explorer |
| Bridge | https://theseven.meme/bridge |
| Developer Hub | https://theseven.meme/developers |
| Whitepaper | https://theseven.meme/whitepaper |
| Telegram | https://t.me/SevenBlockChain |
| Twitter / X | [@thesevendotmeme](https://x.com/thesevendotmeme) |

---

## License

MIT
