# Seven Chain Validator Onboarding

This repository is for the validator client only. Bridge solvers are separate processes with separate keys and configuration.

## Start safely

1. Review this repository and verify the chain ID/genesis hash with an independent source before connecting a production node.
2. Install on an operator-managed Linux host with `sudo bash scripts/install.sh`.
3. Copy `/etc/seven-chain/validator.env.example` to `/etc/seven-chain/validator.env`, set safe ownership/permissions, and configure P2P bootstrap peers.
4. Run `sudo bash scripts/create-validator-account.sh`; it generates the account inside the encrypted local keystore and prints only the public address. Put that address in `VALIDATOR_ADDRESS`.
5. Start `seven-chain` and verify local RPC health with `bash scripts/healthcheck.sh http://127.0.0.1:8545`.

Keep RPC and management methods private. The installer does not open HTTP/HTTPS ports. Expose P2P port `30303` TCP/UDP for peer discovery and block gossip.

## Live-network limitation

The checked-in genesis contains one validator. This repo does not provide a live validator-set upgrade, does not prove the current active set, and does not make a node a validator merely because it is online. Expanding an existing network requires a tested consensus-compatible upgrade and coordinated activation. Never replace genesis or reset an existing data directory to add validators.

## Separate services

Do not combine validator and solver credentials. A validator process receives only its validator keystore; a solver process receives only its solver secret. Each service should have its own host or isolated service account, independently managed configuration, and least-privilege access.
