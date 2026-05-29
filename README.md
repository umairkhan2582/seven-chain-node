<div align="center">

  <img src="https://theseven.meme/logo.png" width="80" alt="Seven Chain" />

  # 🔗 seven-chain-node

  **Run a Seven Chain Validator — Seal Blocks, Earn SEVEN**

  [![Chain ID](https://img.shields.io/badge/Chain%20ID-70007-yellow?style=for-the-badge)](https://theseven.meme/developers)
  [![Mainnet](https://img.shields.io/badge/Status-Mainnet%20Live-brightgreen?style=for-the-badge)](https://theseven.meme/seven-network)
  [![Version](https://img.shields.io/badge/Version-2.0.1-orange?style=for-the-badge)](https://theseven.meme/become-validator)
  [![Earn SEVEN](https://img.shields.io/badge/Earn-Block%20Rewards-orange?style=for-the-badge)](https://theseven.meme/become-validator)

  [**Become a Validator**](https://theseven.meme/become-validator) · [**Block Explorer**](https://theseven.meme/blockchain/explorer) · [**Staking**](https://theseven.meme/staking) · [**Telegram**](https://t.me/SevenBlockChain)

</div>

---

## 🚀 v2.0.1 — May 2026

- V3 Bridge contract live: `0x41A70A6bE222174D8369A90fE91017E8Fb74606f` (non-upgradeable)
- Dynamic price engine: SEVEN price moves in real-time on every trade
- Validator reward system active — block rewards pay out for every block with real user transactions
- Staking multiplier: 1× – 3× based on SEVEN staked

---

## What is a Seven Chain Validator?

Validators on Seven Chain seal blocks and earn rewards for every block that contains a real user transaction. Seven Chain is in **early launch phase** — the validator set is growing and this is the best time to join as a genesis validator.

| Metric | Value |
|---|---|
| **Reward per block** | 0.0003 SEVEN |
| **Relay fee per trade** | 0.0004 BNB |
| **Staking multiplier** | 1× – 3× (based on SEVEN staked) |
| **Registration** | Automatic via heartbeat |

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
# Add your WALLET_ADDRESS and RPC_URL to .env

# 4. Run
npm start
# Your node sends heartbeats every 30s — registered automatically
```

---

## How Rewards Work

1. Your node sends a heartbeat every 30 seconds to `/api/node-heartbeat`
2. The platform records your node as active
3. Every block with a real user transaction credits **0.0003 SEVEN** to your validator wallet on-chain
4. Stake SEVEN at [theseven.meme/staking](https://theseven.meme/staking) to multiply your rewards up to 3×
5. Additionally earn **0.0004 BNB** per trade relay

---

## Register Your Node

Registration is fully automatic via heartbeat. Alternatively, register manually:

```bash
curl -X POST https://theseven.meme/api/node-register \
  -H "Content-Type: application/json" \
  -d '{
    "walletAddress": "0xYOUR_WALLET",
    "rpcUrl": "http://YOUR_SERVER_IP/rpc",
    "name": "My Validator Node"
  }'
# → Registered. No form. No email. No waiting.
```

---

## Bridge — V3 Contract

The V3 bridge contract (non-upgradeable) is live on Seven Chain:

| Network | Address |
|---|---|
| **Seven Chain (receiver)** | `0x968A78d10C7A8b05822FA4ED2F6ECC46a9102afE` |
| **BNB Chain (source lock)** | `0x41A70A6bE222174D8369A90fE91017E8Fb74606f` |

Validators participate in settling bridge intents. Running the [seven-chain-solver](https://github.com/umairkhan2582/seven-chain-solver) alongside your node earns additional relay fees.

---

## Ecosystem

| Repo | Description |
|---|---|
| [**sevenchain**](https://github.com/umairkhan2582/sevenchain) | Developer hub — quickstart, examples, API docs |
| [**seven-chain-solver**](https://github.com/umairkhan2582/seven-chain-solver) | Bridge solver — earn relay fees |
| [**seven-chain-node**](https://github.com/umairkhan2582/seven-chain-node) | ← You are here |

---

## Links

| Resource | URL |
|---|---|
| Platform | https://theseven.meme |
| Become a Validator | https://theseven.meme/become-validator |
| Staking | https://theseven.meme/staking |
| Block Explorer | https://theseven.meme/blockchain/explorer |
| Buy SEVEN | https://theseven.meme/spot/seven |
| Telegram | https://t.me/SevenBlockChain |

---

## License

MIT
