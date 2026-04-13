#!/usr/bin/env node
/**
 * Seven Chain — Parlia extraData Builder
 * Builds genesis extraData from one or more validator Ethereum addresses.
 *
 * Usage: node scripts/build-extradata.js <addr1> [addr2] [addr3] ...
 * Example: node scripts/build-extradata.js \
 *   0xAbCd...1 \
 *   0xAbCd...2 \
 *   0xAbCd...3
 *
 * Parlia extraData format (packed hex, no delimiters):
 *   [32 bytes vanity][N × 20 bytes validator addresses][65 bytes zero signature]
 *
 * This value goes into the "extraData" field of genesis.json.
 *
 * You can also get extraData from: node scripts/generate-keys.js
 */

const addresses = process.argv.slice(2);

if (addresses.length === 0) {
  console.error('\nUsage: node scripts/build-extradata.js <addr1> [addr2] ...\n');
  console.error('Example:');
  console.error('  node scripts/build-extradata.js 0xAaaa... 0xBbbb... 0xCccc...\n');
  process.exit(1);
}

// Validate all addresses
for (const addr of addresses) {
  if (!/^0x[0-9a-fA-F]{40}$/i.test(addr)) {
    console.error(`\nInvalid Ethereum address: ${addr}`);
    console.error('Addresses must be 20-byte hex strings with 0x prefix (42 chars total).\n');
    process.exit(1);
  }
}

const vanity     = '00'.repeat(32);
const validators = addresses.map(a => a.slice(2).toLowerCase()).join('');
const zeroSig    = '00'.repeat(65);
const extraData  = '0x' + vanity + validators + zeroSig;

const expectedLen = 2 + 64 + addresses.length * 40 + 130;
if (extraData.length !== expectedLen) {
  console.error(`\nBug: extraData length ${extraData.length} expected ${expectedLen}\n`);
  process.exit(1);
}

console.log('\n── Parlia extraData ────────────────────────────────────────');
console.log(`  Validator count : ${addresses.length}`);
console.log(`  Hex length      : ${extraData.length} chars (${(extraData.length - 2) / 2} bytes)`);
console.log('');
console.log('  Paste this into genesis.json → "extraData" field:');
console.log(`  ${extraData}`);
console.log('');
console.log('  Breakdown:');
console.log(`    Vanity (32 b)      : 0x${'00'.repeat(32)}`);
addresses.forEach((addr, i) => {
  console.log(`    Validator ${i + 1} (20 b) : ${addr.toLowerCase()}`);
});
console.log(`    Seal sig (65 b)    : (zero bytes — filled by first miner)`);
console.log('');
