#!/usr/bin/env bash
# Safe pointer to the documented validator application flow.
set -euo pipefail
cat <<'TEXT'
Seven Chain validator onboarding

1. Read ONBOARDING.md and VALIDATOR_SETUP.md in this repository.
2. Prepare your node and keep all signing keys and credentials under your control.
3. Submit public operator details at https://theseven.meme/staking.
4. Wait for explicit administrator approval. A heartbeat does not mean approval
   or consensus membership.

This helper does not install software, collect personal information, promise
rewards, or request private keys, seed phrases, passwords, or SSH credentials.
The current Parlia-style network identifies a block proposer; it does not prove
that two validators signed every block.
TEXT
