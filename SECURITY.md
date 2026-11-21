# Security Policy

Security reports should be sent privately to **support@theseven.meme**. Do not publish exploit details, private keys, seed phrases, keystore files, credentials, or sensitive production logs in a public issue or pull request. Include reproduction steps and affected versions only after removing secrets and personal data.

We will acknowledge reports as capacity allows. This repository does not promise a fixed response or remediation deadline.

## Supported software

This is an actively changing community repository. Check the current `main` branch and release notes; do not assume an old version or deployment is supported without confirmation.

## Validator security checklist

- Keep validator signing keys in an operator-controlled keystore; never place private keys in source, shell arguments, logs, CI variables printed to output, or platform databases.
- Use unique, strong keystore passwords and restrictive file permissions (`0700` directories, `0600` secret files). Keep encrypted backups offline.
- Do not expose account unlock/signing, `admin`, `debug`, `personal`, `txpool`, or other privileged RPC namespaces to the public internet.
- Keep HTTP/WS RPC bound to loopback/private interfaces. If external read access is required, use TLS, a strict read-method allowlist, authentication where supported, rate limits, and monitoring.
- Never expose management ports or keystore paths through Docker port mappings or web servers.
- Restrict SSH, update the host, use least privilege, and review firewall rules and logs.
- Treat an RPC chain-ID response, heartbeat, or matching observation as a health signal only, not evidence of validator approval or a second signature.

## Consensus claims

The deployed Parlia-style chain identifies a proposer in the block header. It does not by itself prove that two validators signed each block. Do not present independent RPC observations as cryptographic signatures. A multi-signature claim requires a protocol-level certificate with independently validated signer identities and quorum rules.

## Reporting

Email **support@theseven.meme** with subject `SECURITY: [brief description]`. Use a private channel for follow-up. If a secret was exposed, rotate or revoke it immediately and avoid including the replacement value in the report.
