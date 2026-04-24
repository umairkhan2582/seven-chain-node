#!/bin/bash
# ================================================================
# Seven Chain — Validator Sign-Up & Quick-Install Helper
# ================================================================
# This script:
#   1. Collects your validator details
#   2. Installs the node software (optional)
#   3. Generates a pre-filled registration email
#   4. Outputs a ready-to-send summary for info@theseven.meme
#
# Usage:
#   bash <(curl -s https://raw.githubusercontent.com/umairkhan2582/seven-chain-node/main/scripts/validator-signup.sh)
# ================================================================

set -uo pipefail

BOLD="\033[1m"
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
CYAN="\033[0;36m"
RED="\033[0;31m"
RESET="\033[0m"

clear

echo ""
echo -e "${BOLD}╔══════════════════════════════════════════════════════════════╗${RESET}"
echo -e "${BOLD}║       Seven Chain — Validator Sign-Up & Install Helper       ║${RESET}"
echo -e "${BOLD}║              Chain ID: 70007  |  Mainnet Live                ║${RESET}"
echo -e "${BOLD}╚══════════════════════════════════════════════════════════════╝${RESET}"
echo ""
echo -e "  ${GREEN}Earn relay fees + daily volume share on every trade settled.${RESET}"
echo -e "  ${CYAN}Mainnet is LIVE — theseven.meme${RESET}"
echo ""
echo "──────────────────────────────────────────────────────────────"
echo ""

# ── Step 1: Collect validator information ──────────────────────────────
echo -e "${BOLD}[STEP 1/4]  Tell us about yourself${RESET}"
echo ""

read -rp "  Your name (or organisation): " VALIDATOR_NAME
read -rp "  Email address:               " VALIDATOR_EMAIL
read -rp "  Telegram handle (optional):  " VALIDATOR_TG

echo ""
echo -e "${BOLD}[STEP 2/4]  Choose your validator tier${RESET}"
echo ""
echo "  1)  🥉 BRONZE   — Entry PoA validator        (no SEVEN stake required)"
echo "  2)  🥈 SILVER   — Staked PoS validator        (5,000 SEVEN)"
echo "  3)  🥇 GOLD     — Authority PoS validator     (10,000 SEVEN)"
echo "  4)  👑 PARLIAMENT — Strategic partner         (50,000+ SEVEN)"
echo ""
read -rp "  Enter choice [1-4, default 1]: " TIER_CHOICE
TIER_CHOICE="${TIER_CHOICE:-1}"

case "$TIER_CHOICE" in
  2) TIER="SILVER — 5,000 SEVEN stake";;
  3) TIER="GOLD — 10,000 SEVEN stake";;
  4) TIER="PARLIAMENT — 50,000+ SEVEN stake";;
  *) TIER="BRONZE — entry PoA (no stake)";;
esac

echo ""
echo -e "${BOLD}[STEP 3/4]  Node details${RESET}"
echo ""
read -rp "  Server IP or domain (leave blank if not provisioned yet): " NODE_IP

echo ""
echo -e "${BOLD}[STEP 4/4]  Install the node?${RESET}"
echo ""
read -rp "  Install Seven Chain node software now? [y/N]: " DO_INSTALL

echo ""
echo "──────────────────────────────────────────────────────────────"

# ── Optional install ───────────────────────────────────────────────────
if [[ "${DO_INSTALL,,}" == "y" ]]; then
  echo ""
  echo -e "${YELLOW}Installing Seven Chain node...${RESET}"
  echo ""

  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" 2>/dev/null && pwd)"
  REPO_DIR="$(cd "${SCRIPT_DIR}/.." 2>/dev/null && pwd)"

  if [ -f "${REPO_DIR}/scripts/install.sh" ]; then
    bash "${REPO_DIR}/scripts/install.sh"
  else
    echo "  Downloading installer..."
    curl -fsSL https://raw.githubusercontent.com/umairkhan2582/seven-chain-node/main/scripts/install.sh | bash
  fi
fi

# ── Registration summary ───────────────────────────────────────────────
echo ""
echo -e "${BOLD}╔══════════════════════════════════════════════════════════════╗${RESET}"
echo -e "${BOLD}║                   YOUR REGISTRATION SUMMARY                 ║${RESET}"
echo -e "${BOLD}╚══════════════════════════════════════════════════════════════╝${RESET}"
echo ""
echo -e "  Name      : ${CYAN}${VALIDATOR_NAME}${RESET}"
echo -e "  Email     : ${CYAN}${VALIDATOR_EMAIL}${RESET}"
echo -e "  Telegram  : ${CYAN}${VALIDATOR_TG:-N/A}${RESET}"
echo -e "  Tier      : ${CYAN}${TIER}${RESET}"
echo -e "  Node IP   : ${CYAN}${NODE_IP:-Not set yet}${RESET}"
echo ""

# ── Pre-filled email template ──────────────────────────────────────────
EMAIL_BODY="Subject: Validator Inquiry — ${VALIDATOR_NAME}

Hi Seven Chain team,

I would like to register as a validator on Seven Chain (Chain ID 70007).

Name:        ${VALIDATOR_NAME}
Email:       ${VALIDATOR_EMAIL}
Telegram:    ${VALIDATOR_TG:-N/A}
Tier:        ${TIER}
Node IP:     ${NODE_IP:-To be provided}

Please send me onboarding instructions.

Thanks,
${VALIDATOR_NAME}"

echo "──────────────────────────────────────────────────────────────"
echo -e "${BOLD}  NEXT STEP — Send this email to info@theseven.meme${RESET}"
echo "──────────────────────────────────────────────────────────────"
echo ""
echo "$EMAIL_BODY"
echo ""
echo "──────────────────────────────────────────────────────────────"
echo ""
echo -e "${GREEN}  Or join Telegram instantly: https://t.me/thesevenmeme${RESET}"
echo ""
echo -e "${BOLD}  Node installation guide:${RESET}"
echo "  https://github.com/umairkhan2582/seven-chain-node"
echo ""
echo -e "${BOLD}  Become a validator:${RESET}"
echo "  https://theseven.meme/become-validator"
echo ""
echo "──────────────────────────────────────────────────────────────"
echo ""

if [[ "${DO_INSTALL,,}" == "y" ]]; then
  echo -e "${BOLD}  Node installed. Next steps:${RESET}"
  echo ""
  echo "  1. Import your validator private key:"
  echo "     bash scripts/import-key.sh 0xYOUR_PRIVATE_KEY"
  echo ""
  echo "  2. Edit your validator config:"
  echo "     nano /etc/seven-chain/validator.env"
  echo ""
  echo "  3. Start your node:"
  echo "     systemctl start seven-chain"
  echo ""
  echo "  4. Verify it's running:"
  echo "     bash scripts/healthcheck.sh"
  echo ""
fi

echo -e "${CYAN}  Questions? support@theseven.meme | t.me/thesevenmeme${RESET}"
echo ""
