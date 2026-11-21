# Security Policy

## Reporting

Do not open a public issue for a security vulnerability. Contact the maintainers privately at `support@theseven.meme` with a concise description and reproduction details that do not include secrets or live user data.

## Validator key handling

- Generate validator accounts on the validator host with `scripts/create-validator-account.sh`; the private key stays in the node's encrypted keystore.
- Do not print, paste, email, commit, or pass private keys as command-line arguments or environment variables.
- Keep the keystore password readable only by the dedicated `seven` service account. Use separate keys and hosts/accounts for validators and bridge solvers.
- If any key value was committed or pasted into chat, treat it as compromised and rotate it through the appropriate protocol process.

## Network and RPC exposure

- The installer preserves existing UFW rules, opens P2P port `30303` TCP/UDP, and leaves RPC ports closed by default.
- Keep JSON-RPC bound to loopback unless a separate security review authorizes a restricted proxy. Never expose `admin`, `debug`, `personal`, account-unlock, or transaction-pool methods.
- Run validator and solver processes separately. A heartbeat, registration API, RPC response, peer count, or block-height snapshot is not proof of validator-set membership or block production.
- The checked-in genesis is a reference configuration for a fresh chain and contains one validator address. This repository does not prove the live validator roster or supply a multi-validator upgrade. Adding validators to an existing network requires consensus-compatible code and a coordinated, tested upgrade.

## Scope

This repository provides operator scripts and configuration around an upstream BSC client binary. It does not itself audit the client, bridge contracts, token supply, or live chain state. Report issues in this repository's scripts/configuration privately.
