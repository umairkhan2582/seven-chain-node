# Seven Chain — Validator Node Setup Guide

Complete step-by-step guide to spinning up a fresh Ubuntu 22.04 / Debian 12 droplet as a **Seven Chain** validator node.

---

## System Requirements

| Component | Minimum | Recommended |
|-----------|---------|-------------|
| OS | Ubuntu 22.04 LTS | Ubuntu 22.04 LTS |
| CPU | 4 vCPUs | 8 vCPUs |
| RAM | 8 GB | 16 GB |
| Disk | 200 GB SSD | 500 GB NVMe SSD |
| Bandwidth | 25 Mbps | 100 Mbps |
| Open ports | 8545 (RPC), 30303 (P2P) | same |

> **Tip:** DigitalOcean, Hetzner, or Vultr droplets work well. Choose a region close to your users.

---

## 1. Initial Server Setup

```bash
# Update system packages
sudo apt update && sudo apt upgrade -y

# Install essential tools
sudo apt install -y curl wget git build-essential ufw nginx certbot python3-certbot-nginx jq

# Create a dedicated user (optional but recommended)
sudo useradd -m -s /bin/bash sevenchain
sudo usermod -aG sudo sevenchain
```

---

## 2. Install Go

Seven Chain's BSC Parlia geth fork requires Go 1.21+.

```bash
# Download Go 1.21
wget https://go.dev/dl/go1.21.6.linux-amd64.tar.gz

# Install
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf go1.21.6.linux-amd64.tar.gz

# Add to PATH
echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
echo 'export GOPATH=$HOME/go' >> ~/.bashrc
source ~/.bashrc

# Verify
go version
# → go version go1.21.6 linux/amd64
```

---

## 3. Build BSC Parlia Geth

Seven Chain uses a BSC-compatible Parlia consensus engine.

```bash
# Clone the BSC node repository
git clone https://github.com/umairkhan2582/seven-chain-node.git ~/seven-chain-node
cd ~/seven-chain-node

# Build geth
make geth

# The binary will be at:
ls build/bin/geth

# Copy to system path
sudo cp build/bin/geth /usr/local/bin/geth-seven

# Verify
geth-seven version
```

---

## 4. Initialize the Genesis Block

```bash
# Create data directory
mkdir -p ~/seven-chain-data

# Initialize with the genesis file (included in this repo)
geth-seven init genesis.json --datadir ~/seven-chain-data

# Expected output:
# INFO Successfully wrote genesis state
```

---

## 5. Configure the Node

Copy and edit the provided config template:

```bash
cp ~/seven-chain-node/config.toml ~/seven-chain-data/config.toml
```

Edit `~/seven-chain-data/config.toml` — set your external IP:

```toml
[Node.P2P]
ListenAddr = ":30303"
BootstrapNodes = [
  "enode://REPLACE_WITH_BOOTNODE_ENODE@BOOTNODE_IP:30303"
]

[Node]
HTTPHost = "127.0.0.1"
HTTPPort = 8545
HTTPModules = ["eth", "net", "web3", "txpool"]
WSHost = "127.0.0.1"
WSPort = 8546
WSModules = ["eth", "net", "web3"]
```

> Replace `REPLACE_WITH_BOOTNODE_ENODE` with the official Seven Chain bootnode enode string (posted in the Discord #validators channel).

---

## 6. Create a Validator Wallet

```bash
# Create a new keystore account
geth-seven account new --datadir ~/seven-chain-data

# Note the address printed — this is your validator wallet address.
# Fund it with a small amount of BNB for gas (not required for Parlia PoA).

# Store the password in a file (used by systemd)
echo "YOUR_SECURE_PASSWORD" > ~/seven-chain-data/password.txt
chmod 600 ~/seven-chain-data/password.txt
```

---

## 7. Create systemd Service

This keeps the node running and auto-restarts on crash.

```bash
sudo tee /etc/systemd/system/seven-chain.service > /dev/null <<EOF
[Unit]
Description=Seven Chain Validator Node
After=network-online.target
Wants=network-online.target

[Service]
User=$USER
Group=$USER
Type=simple
Restart=always
RestartSec=5s
ExecStart=/usr/local/bin/geth-seven \
  --config /home/$USER/seven-chain-data/config.toml \
  --datadir /home/$USER/seven-chain-data \
  --unlock 0xYOUR_VALIDATOR_ADDRESS \
  --password /home/$USER/seven-chain-data/password.txt \
  --mine \
  --miner.etherbase 0xYOUR_VALIDATOR_ADDRESS \
  --verbosity 3 \
  --metrics \
  --metrics.addr 127.0.0.1 \
  --metrics.port 6060
LimitNOFILE=65536
StandardOutput=journal
StandardError=journal
SyslogIdentifier=seven-chain

[Install]
WantedBy=multi-user.target
EOF

# Enable and start
sudo systemctl daemon-reload
sudo systemctl enable seven-chain
sudo systemctl start seven-chain

# Check status
sudo systemctl status seven-chain
```

Replace `0xYOUR_VALIDATOR_ADDRESS` with your actual validator wallet address.

---

## 8. nginx Reverse Proxy

Expose the RPC endpoint over HTTPS with WebSocket support.

```bash
sudo tee /etc/nginx/sites-available/seven-chain > /dev/null <<'EOF'
server {
    listen 80;
    server_name YOUR_DOMAIN_OR_IP;

    # HTTP RPC
    location / {
        proxy_pass http://127.0.0.1:8545;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_read_timeout 300s;
        proxy_connect_timeout 10s;

        # CORS for browser clients
        add_header 'Access-Control-Allow-Origin' '*' always;
        add_header 'Access-Control-Allow-Methods' 'GET, POST, OPTIONS' always;
        add_header 'Access-Control-Allow-Headers' 'Content-Type' always;

        if ($request_method = 'OPTIONS') {
            return 204;
        }
    }

    # WebSocket
    location /ws {
        proxy_pass http://127.0.0.1:8546;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;
        proxy_read_timeout 86400s;
    }
}
EOF

sudo ln -s /etc/nginx/sites-available/seven-chain /etc/nginx/sites-enabled/
sudo nginx -t && sudo systemctl reload nginx
```

### Enable HTTPS (recommended)

```bash
sudo certbot --nginx -d YOUR_DOMAIN
```

---

## 9. UFW Firewall Rules

```bash
# Allow SSH (keep this — don't lock yourself out)
sudo ufw allow 22/tcp

# HTTP and HTTPS
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp

# P2P networking (required for peer discovery)
sudo ufw allow 30303/tcp
sudo ufw allow 30303/udp

# Do NOT expose RPC (8545/8546) directly — nginx handles this
# The RPC only listens on 127.0.0.1 internally

# Enable firewall
sudo ufw enable

# Verify
sudo ufw status verbose
```

---

## 10. Health Check Commands

```bash
# Check node is synced and mining
curl -s -X POST http://localhost:8545 \
  -H "Content-Type: application/json" \
  --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' | jq .

# Check peer count
curl -s -X POST http://localhost:8545 \
  -H "Content-Type: application/json" \
  --data '{"jsonrpc":"2.0","method":"net_peerCount","params":[],"id":1}' | jq .

# Check mining status
curl -s -X POST http://localhost:8545 \
  -H "Content-Type: application/json" \
  --data '{"jsonrpc":"2.0","method":"eth_mining","params":[],"id":1}' | jq .

# Watch live logs
sudo journalctl -u seven-chain -f

# Check sync progress
geth-seven attach --datadir ~/seven-chain-data --exec "eth.syncing"
```

Expected healthy output: `eth_blockNumber` returns an increasing hex block number, `net_peerCount` returns `"0x1"` or higher, and `eth_mining` returns `true`.

---

## 11. Register at TheSeven

Once your node is running and accessible via its public RPC URL:

1. Visit **[theseven.meme/become-validator](https://theseven.meme/become-validator)**
2. Connect your validator wallet
3. Enter your node's public RPC URL (e.g. `https://your-domain.com`)
4. Submit the registration — the team will review and approve within 24 hours
5. After approval, your validator address will appear as the `miner` field in newly mined blocks

---

## Monitoring & Maintenance

```bash
# View resource usage
htop

# Disk usage
df -h ~/seven-chain-data

# Check geth metrics (if prometheus is set up)
curl http://localhost:6060/debug/metrics/prometheus | grep chain_head

# Restart after config change
sudo systemctl restart seven-chain

# Upgrade geth binary
cd ~/seven-chain-node && git pull && make geth
sudo cp build/bin/geth /usr/local/bin/geth-seven
sudo systemctl restart seven-chain
```

---

## Troubleshooting

| Problem | Solution |
|---------|----------|
| `EADDRINUSE` on port 8545 | Run `sudo lsof -i :8545` and kill the conflicting process |
| Peer count stays at 0 | Ensure port 30303 TCP/UDP is open and the bootnode enode is correct |
| Node not mining | Check `--unlock` address matches the keystore and `--password` file is readable |
| nginx 502 Bad Gateway | Ensure `seven-chain.service` is running: `sudo systemctl status seven-chain` |
| Out of disk space | Prune old state: `geth-seven snapshot prune-state --datadir ~/seven-chain-data` |

---

## Security Checklist

- [ ] SSH key authentication only (disable password SSH)
- [ ] UFW enabled with minimal open ports
- [ ] RPC not exposed directly (only via nginx on 127.0.0.1)
- [ ] Keystore password stored in a file with `chmod 600`
- [ ] HTTPS enabled via certbot
- [ ] Regular OS security updates (`sudo unattended-upgrades`)

---

*Built for [TheSeven](https://theseven.meme) — the on-chain perpetual futures platform.*
