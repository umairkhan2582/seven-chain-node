# Contributing to Seven Chain

Thank you for your interest in contributing to the Seven Chain validator node software!

## Ways to Contribute

### Run a Validator Node
The most impactful contribution is running a validator node on the Seven Chain mainnet (Chain ID: 70007).
Apply at [theseven.meme/become-validator](https://theseven.meme/become-validator).

### Report Bugs
Use the **Bug Report** issue template. Include:
- Your OS and BSC binary version
- Steps to reproduce
- Relevant log output from `journalctl -u seven-chain -n 100`

### Suggest Improvements
Use the **Feature Request** issue template. Explain:
- The problem you are solving
- Your proposed solution
- Any alternatives you considered

### Submit Code Changes
1. Fork this repository
2. Create a feature branch: `git checkout -b feature/my-improvement`
3. Make your changes and test them on a local node
4. Commit with a clear message: `git commit -m "feat: describe what changed"`
5. Push and open a Pull Request using the PR template

## Code Standards

- Shell scripts must pass `shellcheck`
- Keep scripts idempotent (safe to run multiple times)
- Document any new environment variables in `validator.env.example`
- Test against a fresh Ubuntu 22.04 LTS environment before submitting

## Security Issues

**Do not open a public issue for security vulnerabilities.**
Report them privately via the [Security Policy](SECURITY.md).

## Questions

Open a **Discussion** or email **support@theseven.meme**.
