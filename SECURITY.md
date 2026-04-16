# Security Policy

## Supported Versions

| Version | Supported |
|---------|-----------|
| Latest (main branch) | Yes |
| Older releases | No |

## Reporting a Vulnerability

**Please do not report security vulnerabilities through public GitHub issues.**

If you discover a security vulnerability in the Seven Chain node software, validator scripts, or anything related to the Seven Chain mainnet (Chain ID: 70007), please report it privately:

**Email:** security@theseven.meme

Include in your report:
- A description of the vulnerability and its potential impact
- Steps to reproduce the issue
- Any proof-of-concept code (if applicable)
- Your suggested fix (optional)

## Response Timeline

- **Acknowledgement:** Within 48 hours
- **Initial assessment:** Within 5 business days
- **Fix + disclosure:** Coordinated with reporter, typically within 30 days

## Scope

In scope:
- Seven Chain node configuration (`config.toml`, `genesis.json`)
- Installer and setup scripts (`scripts/`)
- Docker configuration
- Any issue that could compromise validator key security

Out of scope:
- The BSC/Geth binary itself (report to [bnb-chain/bsc](https://github.com/bnb-chain/bsc))
- TheSeven.meme web platform (email support@theseven.meme)

## Recognition

Responsible disclosures will be acknowledged in release notes (with your permission).
