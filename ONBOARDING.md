# Seven Chain — Validator Onboarding

This guide describes the **current administrative onboarding flow**. Registration is not automatic consensus admission, and a heartbeat is not proof that a node signs blocks.

## Current flow

1. **Review the network and security requirements.** Read this guide and [VALIDATOR_SETUP.md](VALIDATOR_SETUP.md). Do not reuse a wallet whose private key has been shared or stored in a platform database.
2. **Prepare an operator-controlled node.** Keep validator keys and keystore passwords on infrastructure you control. Do not send them to the platform.
3. **Submit a validator application** through <https://theseven.meme/staking>. Provide the validator public address, operator contact, and a secured read-only HTTPS RPC endpoint if requested. Never submit a private key, seed phrase, SSH password, or keystore password.
4. **Wait for admin review.** A new entry should remain `pending` until an administrator verifies the operator and endpoint. A successful chain-ID check or heartbeat is only a health check, not approval or consensus membership.
5. **After approval, verify status independently.** Confirm the registry’s approval state, node health, chain ID, peer/sync status, and whether the validator is actually in the active consensus set. These states must not be conflated.
6. **Monitor and maintain the node.** Keep software updated, protect keys, and report incidents privately using [SECURITY.md](SECURITY.md).

## Consensus and explorer labels

The currently deployed Parlia-style consensus identifies a block proposer in the block header. Matching observations from two RPC endpoints are not two signatures. Do not advertise a 2/2 or “2 of 9 signed” result unless a verifiable consensus certificate proves those signatures and the explorer validates it. Adding that guarantee requires a reviewed protocol change; it is not enabled by this onboarding flow.

## RPC safety

- Keep the node’s RPC bound to loopback or a private network where possible.
- If an endpoint must be reachable by the platform, use HTTPS through a reverse proxy with an explicit read-only method allowlist, rate limiting, and request-size limits.
- Do not expose account unlock, signing, admin, debug, txpool, or personal RPC methods.
- Do not use plain public HTTP for an RPC that reveals operational data.

## Rewards and staking

This repository does not promise a reward, APR, block frequency, or income. Check the current on-chain contracts and official terms before staking or operating a node. Do not rely on figures in old issues, screenshots, or archived documentation.

## Support

- Application: <https://theseven.meme/staking>
- Explorer: <https://theseven.meme/blockchain/explorer>
- Security reports: see [SECURITY.md](SECURITY.md)
