# Security Policy

> Updated: May 20, 2026

## Supported Versions

| Version | Supported |
|---------|-----------|
| 2.x     | Yes       |
| 1.x     | Yes       |
| < 1.0   | No        |

## Reporting a Vulnerability

**Do NOT open a public GitHub issue for security vulnerabilities.**

Email: **support@theseven.meme**
Subject: `SECURITY: [brief description]`

Response: within 24 hours. Critical patches: within 7 days.

## Scope

| In Scope | Out of Scope |
|----------|--------------|
| Validator RPC exposure | Social engineering |
| Bridge contract bugs | Third-party wallet bugs |
| Staking contract exploits | Cloud provider infra |
| P2P consensus attacks | Already-public issues |

## Bridge Contract (Immutable)

- **SevenBridgeLock v3**: `0x41A70A6bE222174D8369A90fE91017E8Fb74606f` (BSC Mainnet)
- No admin key. No pause. No upgrade proxy. Final bytecode.

## Validator Security Checklist

```bash
# Protect keystore
chmod 600 ~/seven-chain-data/keystore/*
chmod 600 ~/seven-chain-data/password.txt

# Minimal firewall
sudo ufw default deny incoming
sudo ufw allow 22/tcp
sudo ufw allow 8545/tcp
sudo ufw allow 30303/tcp
sudo ufw enable

# Only expose safe RPC modules publicly
# config.toml: HTTPModules = ["eth","net","web3"]
```

## Contact

| Channel | Link |
|---------|------|
| Security | support@theseven.meme |
| Telegram | t.me/thesevenmeme |
| Staking | theseven.meme/staking |
