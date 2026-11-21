# Seven Chain — Validator Node Setup

This repository supplies node tooling for Chain ID `70007`. Use an isolated test environment first. The deployed Parlia-style consensus currently identifies a proposer; it does not provide a per-block 2-of-2 signature certificate.

## Before production

- Verify the chain software, genesis, network configuration, and current validator set from trusted sources.
- Keep signing keys and keystore passwords under your control. Never paste them into an issue, chat, shell command, environment dump, or support request.
- A node registration or heartbeat is not admin approval and is not proof of consensus participation. Follow [ONBOARDING.md](ONBOARDING.md).
- Review the current network’s RPC and security requirements before exposing any service.

## 1. Install

Use a supported Linux host, apply security updates, and install Node.js 20 or newer. Clone the repository and install the lockfile-pinned dependencies:

```bash
git clone https://github.com/umairkhan2582/seven-chain-node.git
cd seven-chain-node
npm ci
```

Review scripts and configuration before running them with elevated privileges.

## 2. Configure the node

Start from the repository’s configuration and keep HTTP/WS RPC bound to loopback unless a reviewed deployment design requires otherwise. The default example uses `127.0.0.1`; do not change it to `0.0.0.0` just to make registration easier.

If an externally reachable endpoint is required, place a TLS reverse proxy in front of the loopback RPC. Allow only required read methods such as chain ID, network version, block reads, and receipt reads. Apply rate limits and request-size limits. Never publicly expose admin, debug, personal, account unlock/signing, or txpool methods. Do not expose the management port.

## 3. Initialize and start

Only initialize genesis when the network instructions explicitly require it. Do not run an initialization command against an existing production datadir without a verified backup.

```bash
npm run init-genesis   # only for a fresh, isolated datadir when instructed
npm start
```

In a second terminal, verify the local RPC response:

```bash
curl -sS http://127.0.0.1:8545 \
  -H 'Content-Type: application/json' \
  --data '{"jsonrpc":"2.0","method":"eth_chainId","params":[],"id":1}'
```

The chain ID should be `0x11177` (70007). A successful response only confirms RPC reachability and chain ID; it does not prove the node is approved, synchronized, or signing blocks.

## 4. Apply for approval

Submit a validator application at <https://theseven.meme/staking>. Provide only public operator and node information requested by the form. Keep the node pending until an administrator approves it. Verify the separate registry, health, sync, and consensus-membership states after review.

## 5. Operate safely

- Restrict inbound access to SSH and required P2P traffic; keep RPC private or behind a controlled HTTPS proxy.
- Use SSH keys, a firewall, least-privilege accounts, monitored backups, and a secure keystore.
- Monitor logs for unexpected unlocks, RPC methods, peers, or restarts.
- Test upgrades on an isolated network before production.
- See [SECURITY.md](SECURITY.md) for incident reporting.

## What this guide does not promise

No reward, APR, block schedule, transaction finality duration, or multi-validator signing guarantee is made here. Confirm any economic terms from current, verifiable contract data and official documentation.
