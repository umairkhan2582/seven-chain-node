#!/usr/bin/env node
/**
 * Seven Chain — Validator Key Generator
 * Generates real secp256k1 key pairs for validator nodes.
 * Run: npm install && node scripts/generate-keys.js [count]
 *
 * Output: private keys, Ethereum addresses, enode public keys,
 *         ready-to-paste genesis extraData, and env var exports.
 *
 * Store private keys in environment variables — NEVER commit them to git.
 *
 * Requires: ethers ^6 (npm install)
 */

let ethers;
try {
  ({ ethers } = require('ethers'));
} catch {
  console.error('\nERROR: ethers package not found. Run: npm install\n');
  process.exit(1);
}

const count = parseInt(process.argv[2] || '3', 10);
if (count < 1 || count > 21) {
  console.error('Validator count must be between 1 and 21');
  process.exit(1);
}

/**
 * Returns the 128-hex-char uncompressed public key (without 04 prefix)
 * — this is the key used in the enode:// URL.
 */
function getEnodePublicKey(wallet) {
  const pubKey = wallet.signingKey.publicKey; // '0x04xxxxxxxx...' (130 hex chars inc. 0x04)
  return pubKey.slice(4); // remove '0x04' prefix → 128 hex chars = 64 bytes
}

/**
 * Builds Parlia-compatible genesis extraData.
 * Format (hex): 32-byte vanity | N×20-byte validator addresses | 65-byte zero signature
 */
function buildExtraData(validatorAddresses) {
  if (!Array.isArray(validatorAddresses) || validatorAddresses.length === 0) {
    throw new Error('At least one validator address is required');
  }
  for (const addr of validatorAddresses) {
    if (!/^0x[0-9a-fA-F]{40}$/.test(addr)) {
      throw new Error(`Invalid Ethereum address: ${addr}`);
    }
  }
  const vanity       = '00'.repeat(32);                                     // 32 bytes
  const validators   = validatorAddresses.map(a => a.slice(2).toLowerCase()).join(''); // N×20 bytes
  const zeroSig      = '00'.repeat(65);                                     // 65 bytes
  return '0x' + vanity + validators + zeroSig;
}

console.log('\n╔══════════════════════════════════════════════════════════╗');
console.log('║        Seven Chain Validator Key Generator               ║');
console.log('║  Chain ID: 70007 — DO NOT COMMIT PRIVATE KEYS TO GIT  ║');
console.log('╚══════════════════════════════════════════════════════════╝\n');

const validators = [];
for (let i = 0; i < count; i++) {
  const wallet = ethers.Wallet.createRandom();
  const privateKey  = wallet.privateKey;
  const address     = wallet.address;
  const enodeKey    = getEnodePublicKey(wallet);

  validators.push({ index: i + 1, privateKey, address, enodeKey });

  console.log(`── Validator ${i + 1} ─────────────────────────────────────────────`);
  console.log(`  Private Key   : ${privateKey}`);
  console.log(`  Address       : ${address}  (checksum-encoded)`);
  console.log(`  Enode Pub Key : ${enodeKey}`);
  console.log('');
}

const addresses  = validators.map(v => v.address);
const extraData  = buildExtraData(addresses);

const lowerAddresses = addresses.map(a => a.toLowerCase());

console.log('── Genesis extraData (paste into genesis.json) ─────────────');
console.log(`  ${extraData}`);
console.log('');
console.log('── Alloc addresses (replace placeholders in genesis.json) ──');
validators.forEach((v, i) => {
  console.log(`  Validator ${i + 1}: ${v.address.toLowerCase()}`);
});
console.log('');
console.log('── Environment Variables (set on each node server) ─────────');
validators.forEach(v => {
  console.log(`  export VALIDATOR_${v.index}_ADDRESS="${v.address.toLowerCase()}"`);
  console.log(`  export VALIDATOR_${v.index}_KEY="${v.privateKey}"  # KEEP SECRET`);
});
console.log('');
console.log('── Enode URLs (replace <IP_N> with each server IP) ─────────');
validators.forEach((v, i) => {
  console.log(`  Validator ${v.index}: enode://${v.enodeKey}@<IP_${i + 1}>:30311`);
});
console.log('');
console.log('── Next Steps ──────────────────────────────────────────────');
console.log('  1. Copy private keys to a secure secrets manager (NEVER to git)');
console.log('  2. Replace extraData in genesis.json with the value above');
console.log('  3. Replace alloc placeholder addresses in genesis.json with the real addresses');
console.log('  4. Run: bash scripts/install.sh on each DigitalOcean droplet');
console.log('  5. Run: bash scripts/import-key.sh on each droplet to import the private key');
console.log('  6. Run: bash scripts/start-validator.sh on each droplet');
console.log('  7. Set SEVEN_CHAIN_RPC_URL and SEVEN_CHAIN_PLATFORM_KEY as environment variables on your server');
console.log('');
console.log('  All generated addresses are real secp256k1 Ethereum addresses.');
console.log('  Verified by: ethers.Wallet.createRandom() → keccak256(pubkey) → last 20 bytes');
console.log('');
