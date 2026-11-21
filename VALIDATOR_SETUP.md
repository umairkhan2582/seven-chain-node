# Seven Chain Validator Operator Setup

This guide is for the validator node only. It does not install a bridge solver and does not register a node through a platform heartbeat.

## Before operating

1. Confirm the node binary/version, chain ID, genesis hash, and P2P peers with the network maintainers through independently verifiable sources.
2. Do not change `genesis.json` or reinitialize an existing data directory. A fresh genesis is a different chain.
3. The checked-in genesis lists one validator address. Additional validators on an existing network require consensus-compatible validator-set support and a coordinated network upgrade. This repository alone cannot add validators to the live set.
4. Keep the validator signing key in the local encrypted keystore. Never pass it on a command line, put it in a config file, or commit it.

## Install

On a supported Ubuntu host, review and run:

```bash
git clone https://github.com/umairkhan2582/seven-chain-node.git
cd seven-chain-node
sudo bash scripts/install.sh
```

The installer pins the upstream `bsc` release and creates the node data/config paths. It initializes only a fresh data directory. Existing chain data is preserved.

## Create the local validator account

Copy the generated sample settings and set the public validator address plus one or more P2P bootnode URLs:

```bash
sudo cp /etc/seven-chain/validator.env.example /etc/seven-chain/validator.env
sudo chown root:seven /etc/seven-chain/validator.env
sudo chmod 640 /etc/seven-chain/validator.env
sudo bash scripts/create-validator-account.sh
sudoedit /etc/seven-chain/validator.env  # enter the public address printed by the helper
```

The account helper generates a key directly into the node's encrypted keystore and prints only the public address. It never prints the private key or accepts one as an argument. Use separate keys for validators and solvers.

## Start and verify

```bash
sudo systemctl start seven-chain
sudo systemctl status seven-chain --no-pager
bash scripts/healthcheck.sh http://127.0.0.1:8545
```

The default RPC listener is local-only. The installer leaves HTTP/HTTPS firewall ports closed. Keep JSON-RPC private; any public RPC requires a separate security review and explicit firewall/proxy configuration. Do not expose account unlock, admin, debug, or txpool modules. The P2P port is `30303` TCP and UDP.

## Do not infer consensus from monitoring

Heartbeats and registration APIs are monitoring/indexing mechanisms, not consensus. A node is a consensus validator only when the running client, active chain rules, and on-chain/network validator set agree. Block-height or peer-count snapshots alone do not prove that a node authored blocks.
