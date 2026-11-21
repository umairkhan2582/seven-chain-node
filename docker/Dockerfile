FROM ubuntu:22.04

ARG BSC_VERSION=v1.4.10
ENV DEBIAN_FRONTEND=noninteractive
ENV DATA_DIR=/data/seven-chain

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates curl \
    && rm -rf /var/lib/apt/lists/* \
    && useradd --system --home-dir /data/seven-chain --shell /usr/sbin/nologin seven

RUN curl -fsSL \
    "https://github.com/bnb-chain/bsc/releases/download/${BSC_VERSION}/geth_linux" \
    -o /usr/local/bin/bsc \
    && chmod 0755 /usr/local/bin/bsc

RUN mkdir -p /data/seven-chain/geth /data/seven-chain/keystore \
    && chown -R seven:seven /data/seven-chain

COPY genesis.json /data/seven-chain/genesis.json
COPY config.toml /data/seven-chain/config.toml
COPY docker/entrypoint.sh /usr/local/bin/seven-chain-entrypoint
RUN chmod 0755 /usr/local/bin/seven-chain-entrypoint

USER seven
EXPOSE 8545/tcp 30303/tcp 30303/udp
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
  CMD curl -fsS -X POST -H "Content-Type: application/json" \
    --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' \
    http://127.0.0.1:8545 || exit 1

ENTRYPOINT ["/usr/local/bin/seven-chain-entrypoint"]
