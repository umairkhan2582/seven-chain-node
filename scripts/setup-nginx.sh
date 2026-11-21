#!/usr/bin/env bash
# Optional public, operator-owned JSON-RPC reverse proxy.
# Usage: sudo bash scripts/setup-nginx.sh <your-domain> <your-contact-email>
set -euo pipefail

if [[ $# -ne 2 ]]; then
  echo "Usage: sudo bash scripts/setup-nginx.sh <your-domain> <your-contact-email>" >&2
  echo "This explicitly opens public HTTP/HTTPS for RPC; review the RPC modules and firewall first." >&2
  exit 2
fi

DOMAIN="$1"
EMAIL="$2"
if [[ ! "${DOMAIN}" =~ ^[A-Za-z0-9.-]+$ ]]; then
  echo "ERROR: provide a valid domain name." >&2
  exit 1
fi
NGINX_CONF="/etc/nginx/sites-available/seven-chain-rpc"
WEBROOT="/var/www/html"
mkdir -p "${WEBROOT}"

# Temporary HTTP-only server block for the ACME HTTP-01 challenge.
cat > "${NGINX_CONF}" << HTTP_CHALLENGE_EOF
server {
    listen 80;
    server_name ${DOMAIN};
    location /.well-known/acme-challenge/ { root ${WEBROOT}; }
    location / { return 200 'ACME challenge endpoint'; }
}
HTTP_CHALLENGE_EOF
ln -sf "${NGINX_CONF}" /etc/nginx/sites-enabled/seven-chain-rpc
nginx -t
if command -v ufw >/dev/null 2>&1; then ufw allow 80/tcp; fi
systemctl reload nginx
certbot certonly --webroot -w "${WEBROOT}" -d "${DOMAIN}" --non-interactive --agree-tos -m "${EMAIL}"

cat > "${NGINX_CONF}" << NGINX_CONFIG_EOF
limit_req_zone \$binary_remote_addr zone=seven_rpc:10m rate=30r/s;

upstream seven_chain_rpc {
    server 127.0.0.1:8545;
    keepalive 16;
}

server {
    listen 80;
    server_name ${DOMAIN};
    location /.well-known/acme-challenge/ { root ${WEBROOT}; }
    location / { return 301 https://\$host\$request_uri; }
}

server {
    listen 443 ssl http2;
    server_name ${DOMAIN};
    ssl_certificate /etc/letsencrypt/live/${DOMAIN}/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/${DOMAIN}/privkey.pem;
    ssl_protocols TLSv1.2 TLSv1.3;
    client_max_body_size 1m;

    location / {
        limit_req zone=seven_rpc burst=60 nodelay;
        proxy_pass http://seven_chain_rpc;
        proxy_http_version 1.1;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header Connection "";
        add_header Access-Control-Allow-Origin "*" always;
        add_header Access-Control-Allow-Methods "POST, OPTIONS" always;
        add_header Access-Control-Allow-Headers "Content-Type" always;
        if (\$request_method = OPTIONS) { return 204; }
    }
}
NGINX_CONFIG_EOF

nginx -t
if command -v ufw >/dev/null 2>&1; then ufw allow 443/tcp; fi
systemctl reload nginx
echo "Public JSON-RPC is available at https://${DOMAIN}. This endpoint is operator-owned, not a validator-membership or decentralization proof."
