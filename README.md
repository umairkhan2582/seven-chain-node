<div align="center">

  <img src="https://theseven.meme/logo.png" width="80" alt="Seven Chain" />

  # 🔗 seven-chain-node

  **Run a Seven Chain Validator — Seal Blocks, Earn SEVEN**

  [![Chain ID](https://img.shields.io/badge/Chain%20ID-70007-yellow?style=for-the-badge)](https://theseven.meme/developers)
  [![Mainnet](https://img.shields.io/badge/Status-Mainnet%20Live-brightgreen?style=for-the-badge)](https://theseven.meme/seven-network)
  [![Earn SEVEN](https://img.shields.io/badge/Earn-0.0003%20SEVEN%2Fblock-orange?style=for-the-badge)](https://theseven.meme/become-validator)

  [**Become a Validator**](https://theseven.meme/become-validator) · [**Block Explorer**](https://theseven.meme/blockchain/explorer) · [**Staking**](https://theseven.meme/staking) · [**Telegram**](https://t.me/SevenBlockChain)

  </div>

  ---

  ## What is a Seven Chain Validator?

  Validators on Seven Chain seal blocks and earn rewards for every block that contains a real user transaction.

  | Metric | Value |
  |---|---|
  | **Reward per block** | 0.0003 SEVEN |
  | **Relay fee per trade** | 0.0004 BNB |
  | **Staking multiplier** | 1× – 3× (based on SEVEN staked) |
  | **Auto-approval** | Yes — no human review |

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
  # Your node sends heartbeats every 30s — auto-registered, instantly approved
  ```

  ## How Rewards Work

  1. Your node sends a heartbeat every 30 seconds to `/api/node-heartbeat`
  2. The platform records your node as active
  3. Every block with a real user transaction credits **0.0003 SEVEN** to your validator wallet on-chain
  4. Stake SEVEN at [theseven.meme/staking](https://theseven.meme/staking) to multiply your rewards up to 3×
  5. Additionally earn **0.0004 BNB** per trade relay

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
  # → Instantly approved. No form. No email. No waiting.
  ```

  ## Ecosystem

  | Repo | Description |
  |---|---|
  | [**sevenchain**](https://github.com/umairkhan2582/sevenchain) | Developer hub — quickstart, examples, hackathon |
  | [**seven-chain-solver**](https://github.com/umairkhan2582/seven-chain-solver) | Bridge solver — earn relay fees |
  | [**seven-chain-node**](https://github.com/umairkhan2582/seven-chain-node) | ← You are here |

  ---

  <div align="center">
  ⚡ <a href="https://theseven.meme">theseven.meme</a> · <a href="https://t.me/SevenBlockChain">Telegram</a>
  </div>
  