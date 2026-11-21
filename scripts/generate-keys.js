#!/usr/bin/env node
/**
 * Generate validator wallets and store encrypted keystores locally.
 * Usage: npm run generate-keys -- [count]
 * Private keys are never printed. Keep the generated .secrets directory offline
 * and make an encrypted backup before moving a keystore to a validator host.
 */
const fs = require('node:fs');
const path = require('node:path');
const readline = require('node:readline');
let ethers;
try { ({ ethers } = require('ethers')); }
catch { console.error('ERROR: ethers package not found. Run npm ci.'); process.exit(1); }

const count = Number.parseInt(process.argv[2] || '1', 10);
if (!Number.isInteger(count) || count < 1 || count > 21) {
  console.error('Validator count must be an integer from 1 to 21.'); process.exit(1);
}
function getEnodePublicKey(wallet) {
  return wallet.signingKey.publicKey.slice(4);
}
function buildExtraData(addresses) {
  if (!addresses.length || addresses.some(a => !/^0x[0-9a-fA-F]{40}$/.test(a))) throw new Error('Invalid validator address set.');
  return '0x' + '00'.repeat(32) + addresses.map(a => a.slice(2).toLowerCase()).join('') + '00'.repeat(65);
}
function readHiddenPassword(prompt) {
  return new Promise((resolve, reject) => {
    const input = process.stdin;
    if (!input.isTTY || typeof input.setRawMode !== 'function') return reject(new Error('Run this command in an interactive terminal to enter the keystore password securely.'));
    let value = '';
    process.stdout.write(prompt);
    input.setRawMode(true); input.resume(); input.setEncoding('utf8');
    const cleanup = () => { input.setRawMode(false); input.pause(); input.removeListener('data', onData); process.stdout.write('\n'); };
    const onData = (chunk) => {
      for (const ch of chunk) {
        if (ch === '\u0003') { cleanup(); reject(new Error('Cancelled.')); return; }
        if (ch === '\r' || ch === '\n') { cleanup(); resolve(value); return; }
        if (ch === '\u007f' || ch === '\b') value = value.slice(0, -1); else value += ch;
      }
    };
    input.on('data', onData);
  });
}
(async () => {
  const password = await readHiddenPassword('Keystore password (12+ characters): ');
  if (password.length < 12) throw new Error('Use a password at least 12 characters long.');
  const confirm = await readHiddenPassword('Confirm password: ');
  if (password !== confirm) throw new Error('Passwords do not match.');
  const dir = path.resolve('.secrets');
  fs.mkdirSync(dir, { recursive: true, mode: 0o700 }); fs.chmodSync(dir, 0o700);
  const wallets = Array.from({ length: count }, () => ethers.Wallet.createRandom());
  for (let i = 0; i < wallets.length; i++) {
    const wallet = wallets[i];
    const encrypted = await wallet.encrypt(password);
    const file = path.join(dir, `validator-${i + 1}-${wallet.address.slice(2, 10).toLowerCase()}.json`);
    fs.writeFileSync(file, encrypted, { flag: 'wx', mode: 0o600 }); fs.chmodSync(file, 0o600);
    console.log(`Validator ${i + 1}: ${wallet.address}`);
    console.log(`Encrypted keystore: ${path.relative(process.cwd(), file)}`);
    console.log(`Enode public key: ${getEnodePublicKey(wallet)}`);
  }
  console.log(`Genesis extraData: ${buildExtraData(wallets.map(w => w.address))}`);
  console.log('Private keys were not printed. Back up encrypted keystores securely; never commit them.');
})().catch((err) => { console.error(`Key generation failed: ${err.message}`); process.exitCode = 1; });
