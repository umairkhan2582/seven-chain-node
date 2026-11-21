<div align="center">
  # Seven Chain Node

  **Community-operated node tooling for Seven Chain (EVM, Chain ID 70007).**

  [![Chain ID](https://img.shields.io/badge/Chain%20ID-70007-F5C842?style=for-the-badge)](https://theseven.meme/staking)
  [![License: MIT](https://img.shields.io/badge/License-MIT-blue?style=for-the-badge)](LICENSE)
  [![Security](https://img.shields.io/badge/Security-report%20privately-red?style=for-the-badge)](SECURITY.md)

  [Validator onboarding](ONBOARDING.md) · [Node setup](VALIDATOR_SETUP.md) · [Security policy](SECURITY.md) · [Explorer](https://theseven.meme/blockchain/explorer)
</div>

---

## Important: what validator status means today

This repository contains node setup and operational tooling. The currently deployed chain uses Parlia-style block production: a block header identifies its proposer. It does **not** provide a cryptographic 2-of-2 signature certificate for every block. Two nodes reporting the same block or receipt means they independently observed matching data; it does not prove both validators signed it. The explorer and operators must not describe that as “signed by 2/9.”

Validator registry status, node health, proposer identity, and cryptographic consensus evidence are separate facts. Admin approval is an onboarding control; it does not itself add a key to the chain’s consensus set. A protocol-level consensus change and independently verifiable certificates would be required before claiming multi-signature finality.

## Join the network

Read [Validator Onboarding](ONBOARDING.md) first, then follow [Validator Setup](VALIDATOR_SETUP.md). New submissions remain pending until reviewed by an administrator. Approval, node health, and actual consensus participation should be checked separately in the official explorer.

- Network: Seven Chain
- Chain ID: `70007`
- Public explorer: <https://theseven.meme/blockchain/explorer>
- Validator application: <https://theseven.meme/staking>

Do not send your private key, seed phrase, keystore password, or SSH credentials to the platform or repository maintainers. Keep signing keys under the validator operator’s control.

## Repository contents

- `scripts/` — node installation, key handling, health checks, and validator helpers
- `docker/` — development/test deployment files
- `config.toml` — example node configuration; review RPC exposure before deployment
- `ONBOARDING.md` and `VALIDATOR_SETUP.md` — current registration and operational guidance

This repository is not a substitute for a consensus audit. Test changes on an isolated network before using them with funds or production keys.

## Security principles

- Keep RPC and management interfaces private by default; never expose admin, debug, account, txpool, or signing methods to the public internet.
- Use HTTPS and a method allowlist with rate limits if a read-only RPC must be reachable externally.
- Do not pass private keys as command-line arguments or print them to logs.
- Review pending validator applications and verify the node independently before approval.
- Report vulnerabilities privately as described in [SECURITY.md](SECURITY.md).

## Contributing

Issues and pull requests are welcome. Do not include secrets, production addresses tied to private keys, or unredacted logs. See the repository’s issue templates and [SECURITY.md](SECURITY.md) for responsible reporting.

## License

MIT. See [LICENSE](LICENSE).
