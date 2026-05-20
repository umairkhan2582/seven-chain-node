# Contributing to Seven Chain Node

> Updated: May 20, 2026

## Getting Started

```bash
git clone https://github.com/YOUR_USERNAME/seven-chain-node.git
cd seven-chain-node
git checkout -b feature/your-improvement
npm install
```

## High-Priority Contributions

- Heartbeat daemon reliability and retry logic
- Grafana + Prometheus dashboards for validator stats
- Cloud setup guides (AWS, GCP, Azure, Hetzner)
- Cross-distro support (Debian, Fedora, Arch)
- Security hardening automation scripts

## Good First Issues

- Documentation improvements
- Translated docs (Chinese, Spanish, Arabic, Turkish)
- Bug fixes in heartbeat or healthcheck scripts
- Additional OS support

## Code Standards

- Shell scripts: POSIX-compatible, idempotent, fail loudly
- Test on clean Ubuntu 22.04 from scratch
- Comment every non-obvious step

## Pull Request Process

1. Test on a clean server from scratch
2. Open PR with clear title and description
3. Reference issues: `Closes #123`
4. Review within 48 hours

## Related Repos

| Repo | Purpose |
|------|---------|
| [seven-chain-node](https://github.com/umairkhan2582/seven-chain-node) | Validator node (this repo) |
| [seven-chain-solver](https://github.com/umairkhan2582/seven-chain-solver) | Bridge solver node |

## Community

| Channel | Link |
|---------|------|
| Telegram | t.me/thesevenmeme |
| Buy SEVEN | theseven.meme/spot/seven |
| Stake + Validate | theseven.meme/staking |
| Support | support@theseven.meme |
