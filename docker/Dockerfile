FROM ubuntu:22.04

ARG BSC_VERSION=v1.4.10

ENV DEBIAN_FRONTEND=noninteractive
ENV DATA_DIR=/data/seven-chain

RUN apt-get update && apt-get install -y \
    curl wget ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Download BSC binary
RUN wget -q -O /usr/local/bin/bsc \
    "https://github.com/bnb-chain/bsc/releases/download/${BSC_VERSION}/geth_linux" \
    && chmod +x /usr/local/bin/bsc

# Create data directory
RUN mkdir -p ${DATA_DIR}/logs

# Copy config files
COPY genesis.json ${DATA_DIR}/genesis.json
COPY config.toml  ${DATA_DIR}/config.toml

# Initialize chain from genesis
RUN bsc init --datadir ${DATA_DIR} ${DATA_DIR}/genesis.json

EXPOSE 8545 8546 30303 30303/udp

ENV VALIDATOR_ADDRESS=""
ENV BOOTNODE_ENODE=""

HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 \
  CMD curl -sf -X POST -H "Content-Type: application/json" \
    --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' \
    http://localhost:8545 || exit 1

ENTRYPOINT ["/bin/sh", "-c"]
CMD ["bsc \
  --config ${DATA_DIR}/config.toml \
  --datadir ${DATA_DIR} \
  --unlock ${VALIDATOR_ADDRESS} \
  --password /run/secrets/keystore_pass \
  --mine \
  --bootnodes ${BOOTNODE_ENODE} \
  --networkid 7777 \
  --verbosity 3"]
