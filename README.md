# Session Node Docker Image

This Docker image allows you to run a Session node easily within a containerized environment.

## Requirements

- Docker installed on your host system
- An Arbitrum One RPC provider URL (from providers like Infura, Alchemy, or dRPC)
- At least 25,000 SESH tokens for staking (or 6,250 SESH for operator in a multi-contributor node)
- Sufficient ETH on Arbitrum One for gas fees
- A server with at least 45GB storage, 4-8GB RAM, and 100Mb+ network connection

## Quick Start

```bash
docker run -d \
  --name session-node \
  -p 11022:11022 \
  -p 11025:11025 \
  -v session-node-data:/var/lib/oxen \
  -v <path/to/oxen.conf>:/etc/oxen \
  --restart unless-stopped \
  session-node:latest
```

Or with docker-compose:

```sh
# docker-compose.yml example
# uses ./oxen.conf for configuration
docker-compose up --build -d
```

TODO: Add example with public images

## Building the Image

```bash
cd session/docker
docker build -t session-node:latest .
```

## Node Registration

After your node is running and synced, you can register it with the Session network:

1. Get your Ethereum wallet address
2. Run the registration command in the container:
   ```bash
   docker exec session-node oxend register <your-eth-address>
   ```
3. Follow the link provided to complete registration on the Session Staking Portal
4. Stake your SESH tokens to the node

## Backing Up Keys

Your node's secret keys are essential for operation. Back them up using:

```bash
# View and backup ED25519 key
docker exec session-node oxen-sn-keys show /var/lib/oxen/key_ed25519

# View and backup BLS key
docker exec session-node oxen-sn-keys show /var/lib/oxen/key_bls
```

Store these keys securely. They can be used to restore your node if needed.

## Restoring from Backup (TODO)

## Checking Node Status

```bash
# View node status
docker exec session-node oxend status

# View service node status
docker exec session-node oxend print_sn_status

# View logs
docker logs -f session-node
```

## References

- [Session Documentation](https://docs.getsession.org/contribute-to-the-session-network/running-a-session-node)
- [Session Staking Portal](https://stake.getsession.org/)
