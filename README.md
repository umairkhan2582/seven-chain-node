# Seven Chain Validator Node

This repository contains configuration and operator scripts for running the Seven Chain validator client. It downloads the upstream BNB Chain `bsc` executable at a pinned release; it does **not** contain or independently maintain the consensus client source code. Validator operations belong here. Bridge solvers are a separate service and repository.

## Important network-safety notes

- Chain ID: `70007`.
- `genesis.json` is a reference for a fresh local/test data directory. Do not apply a changed genesis file to an existing node or live network; doing so creates a different chain or risks existing data.
- The checked-in genesis configuration contains one validator address. This repository does not prove the live validator roster or enable a multi-validator protocol upgrade by itself. Adding validators to an existing network requires consensus-compatible client/protocol support and a coordinated, tested network upgrade that preserves the existing chain history.
- Do not treat a public RPC endpoint, registration endpoint, dashboard heartbeat, or explorer count as proof that a node is in the consensus validator set.
- This repository does not provide bridge-solver services, bridge relays, or reward accounting. Do not place solver keys or solver configuration on a validator host.

## Install on a fresh operator-managed host

The installer targets Ubuntu and requires root access. Review it before running it.

```bash
git clone https://github.com/umairkhan2582/seven-chain-node.git
cd seven-chain-node
sudo bash scripts/install.sh
```

The installer creates `/etc/seven-chain/validator.env.example`, installs the pinned `bsc` binary and configuration, and initializes a data directory only when one is not already present. Configure a validator address and one or more comma-separated P2P bootnodes in the operator-owned environment file. Keep validator key material in the node's local encrypted keystore; the account helper generates the key directly into the encrypted local keystore and prints only the public address:

```bash
sudo cp /etc/seven-chain/validator.env.example /etc/seven-chain/validator.env
sudo chown root:seven /etc/seven-chain/validator.env
sudo chmod 640 /etc/seven-chain/validator.env
sudo bash scripts/create-validator-account.sh
# Copy the public address printed by the helper into VALIDATOR_ADDRESS.
sudoedit /etc/seven-chain/validator.env
sudo systemctl start seven-chain
```

The node uses the local RPC listener by default. The installer leaves HTTP/HTTPS firewall ports closed. Keep JSON-RPC private; any public RPC requires a separate security review and explicit firewall/proxy configuration. Never expose admin, debug, account-unlock, or transaction-pool methods publicly. P2P uses TCP/UDP `30303`; multiple independently operated bootstrap peers can be configured with `BOOTNODE_ENODES`.

## Verify local node health

```bash
bash scripts/healthcheck.sh http://127.0.0.1:8545
```

This reports RPC reachability, chain ID, block height, peer count, mining status, and sync status. A healthy RPC response alone does not prove independent validator production or consensus participation.

## Genesis tooling

`npm run init-genesis` is only for a new, empty data directory and refuses to initialize over existing chain data. `scripts/build-extradata.js` is a local utility for a new test chain. The unsafe private-key-printing generator was removed; create each validator account locally with `scripts/create-validator-account.sh`. A change to genesis does not upgrade an existing network.

## Separation of duties

- **Validator:** runs the consensus client, stores its own validator keystore, syncs blocks, and participates only if the live consensus rules admit it.
- **Solver:** a separate bridge service with separate configuration and signing key. See [seven-chain-solver](https://github.com/umairkhan2582/seven-chain-solver).
- **RPC/API:** an access path to node data, not a substitute for independent P2P peers or consensus.

## Docker local node smoke test

`docker/docker-compose.yml` runs one non-mining node for RPC/P2P smoke testing. It does not test validator production, multi-validator consensus, or mainnet decentralization. The checked-in genesis admits one validator, and a running container is not automatically in that validator set. RPC is bound to `127.0.0.1` on the host; only P2P is exposed. Optionally set independent P2P peers in `docker/.env.example`, then run:

```bash
docker compose --env-file docker/.env.example -f docker/docker-compose.yml up --build
```

The Docker node has no validator signing key. Use the host operator setup above to create an encrypted validator account; consensus participation still depends on the live network rules.

## License

MIT
