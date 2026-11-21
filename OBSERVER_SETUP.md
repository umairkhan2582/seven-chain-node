# Independent Seven Chain Full Node (Node 3 Observer)

This guide runs the pinned upstream BSC client as an independent, non-mining full node. Node 3 executes and verifies the chain locally and receives blocks over P2P; it does not use PostgreSQL, the platform API as a block source, synthetic blocks, a validator signing key, or bridge-solver credentials.

A real full node must keep persistent local chain data (`chaindata`). That is the node client's own state database, not PostgreSQL or a simulated ledger. This setup makes Node 3 an independent observer/peer; it does not admit Node 3 as a consensus validator.

## Independence model

- Run the node on a host and service account administered separately from the web/API host.
- Let the BSC client sync and verify blocks directly over P2P. Do not use the website, API, database, or heartbeat as the source of chain truth.
- Configure multiple verified P2P peers. For geographic/operator diversity, use peers operated by different parties; two endpoints controlled by the same operator are not independent.
- Keep the node's RPC on loopback. Expose only P2P TCP/UDP `30303` as needed.
- Validator and solver roles remain separate. This observer has no signing key and does not mine.

## Before starting on a live host

1. Use a host you administer, and rotate any password or Brain token previously pasted into chat. Never put credentials in this repository or in `docker/.env`.
2. Verify the exact genesis hash and chain ID (`70007`) against at least two independently operated, trusted Seven Chain nodes. Chain ID alone is not enough. The first-time Docker startup initializes its persistent volume from this repository's `genesis.json`; do not start if the live genesis hash does not match.
3. Obtain valid P2P enode URLs from independent node operators and configure more than one where available. A dashboard heartbeat or API endpoint is not a P2P peer or proof of consensus.
4. Confirm the host and cloud firewalls allow inbound P2P TCP/UDP `30303`. Do not expose JSON-RPC or management methods to the public internet.
5. Do not run `scripts/install.sh` or `scripts/create-validator-account.sh` for observer mode. The systemd service installed by `scripts/install.sh` is validator/mining-oriented.

## Start the observer

Install Docker Engine and the Docker Compose plugin on the independently administered host, then:

```bash
git clone https://github.com/umairkhan2582/seven-chain-node.git
cd seven-chain-node
cp docker/.env.example docker/.env
# Edit docker/.env and set BOOTNODE_ENODES to verified comma-separated enode URLs.
docker compose --env-file docker/.env -f docker/docker-compose.yml up --build -d
```

The compose file persists chain data in a named Docker volume. A restart preserves that data. Do not use `docker compose down -v` on a live node; it deletes the chain-data volume and forces a resync.

## Verify actual chain sync

The container healthcheck only proves that the local RPC responds. Check the chain ID, peer count, and sync status too:

```bash
bash scripts/healthcheck.sh http://127.0.0.1:8545
curl -sS -X POST http://127.0.0.1:8545 \
  -H 'Content-Type: application/json' \
  --data '{"jsonrpc":"2.0","method":"eth_syncing","params":[],"id":1}'
```

Before calling the node synced, confirm `eth_chainId` is `0x11177`, `eth_syncing` returns `false`, and `net_peerCount` is nonzero. At a common recent block height, compare `eth_getBlockByNumber` hashes with at least two independent nodes. A matching height or a reachable RPC alone is not proof of shared history; a non-mining observer is not proof of validator participation.

## Validator promotion is separate

The checked-in genesis lists one validator. Do not edit or reinitialize genesis to try to add Node 3. This observer setup adds independent P2P redundancy only. Promote Node 3 to a validator only after the network's consensus rules and supported validator-set upgrade are independently verified, rehearsed on an isolated network, and activated through the protocol. Keep validator and bridge-solver keys separate.
