#!/bin/bash
# ================================================================
# Seven Chain — Nginx RPC Proxy Setup with SSL
# Usage: bash scripts/setup-nginx.sh rpc-testnet.theseven.meme
# Must be run on the RPC node (not validators directly)
# ================================================================

set -euo pipefail

DOMAIN="${1:-rpc-testnet.theseven.meme}"
EMAIL="${2:-admin@theseven.meme}"
NGINX_CONF="/etc/nginx/sites-available/seven-chain-rpc"

echo "Setting up Nginx RPC proxy for: ${DOMAIN}"

# Install config
cat > "${NGINX_CONF}" << EOF
# Rate limiting zone (50 req/s per IP)
limit_req_zone \$binary_remote_addr zone=seven_rpc:10m rate=50r/s;

upstream seven_chain_rpc {
    server 127.0.0.1:8545;
    keepalive 32;
}

upstream seven_chain_ws {
    server 127.0.0.1:8546;
    keepalive 32;
}

server {
    listen 80;
    server_name ${DOMAIN};
    location / { return 301 https://\$host\$request_uri; }
    location /.well-known/ { root /var/www/html; }
}

server {
    listen 443 ssl http2;
    server_name ${DOMAIN};

    ssl_certificate     /etc/letsencrypt/live/${DOMAIN}/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/${DOMAIN}/privkey.pem;
    ssl_protocols       TLSv1.2 TLSv1.3;
    ssl_ciphers         HIGH:!aNULL:!MD5;

    # Block oversized requests (DoS protection)
    client_max_body_size 5m;

    location / {
        limit_req zone=seven_rpc burst=200 nodelay;

        proxy_pass http://seven_chain_rpc;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_http_version 1.1;
        proxy_set_header Connection "";

        # CORS — allow all origins (public RPC)
        add_header Access-Control-Allow-Origin  "*" always;
        add_header Access-Control-Allow-Methods "POST, GET, OPTIONS" always;
        add_header Access-Control-Allow-Headers "Content-Type, Authorization" always;

        if (\$request_method = OPTIONS) { return 204; }
    }

    location /ws {
        limit_req zone=seven_rpc burst=100 nodelay;

        proxy_pass http://seven_chain_ws;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host \$host;
        proxy_read_timeout 3600s;
    }
}
EOF

ln -sf "${NGINX_CONF}" /etc/nginx/sites-enabled/seven-chain-rpc
nginx -t
systemctl reload nginx

echo "Getting SSL certificate for ${DOMAIN}..."
certbot --nginx -d "${DOMAIN}" --non-interactive --agree-tos -m "${EMAIL}"

echo ""
echo "✅ Nginx RPC proxy live at:"
echo "   HTTP  : https://${DOMAIN}"
echo "   WS    : wss://${DOMAIN}/ws"
echo ""
echo "Add to TheSeven.meme platform:"
echo "   SEVEN_CHAIN_RPC_URL=https://${DOMAIN}"
echo "   SEVEN_CHAIN_WS_URL=wss://${DOMAIN}/ws"
