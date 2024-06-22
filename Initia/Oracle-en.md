# Oracle Validator Node Setup Guide for Slinky Oracle

## Overview

Welcome to the comprehensive guide for setting up and operating validator nodes using the Slinky Oracle. This guide is designed to provide you with step-by-step instructions to ensure a smooth setup process. The Slinky Oracle system is composed of two primary components:

1. **On-Chain Component:** This component is responsible for retrieving price data from the sidecar with each block, forwarding these prices to the blockchain through vote extensions, and compiling prices from all involved validators.
2. **Sidecar Process:** This process is dedicated to polling price information from various providers and delivering this data to the on-chain component.

For more detailed information on the Slinky Oracle, please visit the [Slinky repository](https://github.com/skip-mev/slinky/).

**Note:** While pre-compiled binaries will be available in the future, users are currently required to compile the necessary software from the source code.

## Tutorial

This tutorial will guide you through the following steps:

1. Cloning the Slinky repository.
2. Setting up and running the sidecar.
3. Validating prices retrieved by the oracle.
4. Enabling the oracle vote extension in your Initia node.

### Step 1: Clone the Repository

First, you need to clone the Slinky repository to your local machine. Open your terminal and run the following commands:

```bash
# Clone the repository
git clone https://github.com/skip-mev/slinky.git

# Navigate to the slinky directory
cd slinky

# Checkout the appropriate version
git checkout v0.4.3
```

### Step 2: Running The Sidecar

The sidecar process is essential for polling price data from various providers. Here’s how you set it up:

#### Configuration Setup

To operate the oracle sidecar, you need valid configuration files for both the oracle component and the market component. The oracle executable recognizes flags that specify each configuration file. Below are the recommended default settings suitable for the existing Initia Devnet environment.

##### Oracle Component Configuration

The oracle component configuration determines parameters such as how often to poll price providers, the multiplexing behavior of websockets, and more. You can find the recommended configuration file at `config/core/oracle.json` within the Slinky repository.

##### Market Component Configuration

The market component configuration specifies which markets the sidecar should fetch prices for. To configure the sidecar properly, point it to the GRPC port on a node (typically port 9090). You can do this by adding the `--market-map-endpoint` flag when starting the sidecar or by modifying the `oracle.json` component as shown below:

```json
{
  "name": "marketmap_api",
  "api": {
    "enabled": true,
    "timeout": 20000000000,
    "interval": 10000000000,
    "reconnectTimeout": 2000000000,
    "maxQueries": 1,
    "atomic": true,
    "url": "0.0.0.0:9090", // URL that must point to a node GRPC endpoint
    "endpoints": null,
    "batchSize": 0,
    "name": "marketmap_api"
  },
  "type": "market_map_provider"
},
"metrics": {
  "prometheusServerAddress": "0.0.0.0:8002",
  "enabled": true
},
"host": "0.0.0.0",
"port": "8080"
}
```

#### Starting The Sidecar

After setting up the configuration files, you can start the sidecar process by executing the binary. Follow these steps:

```bash
# Build the Slinky binary in the repository
make build

# Run the sidecar with the core oracle configuration
./build/slinky --oracle-config-path ./config/core/oracle.json --market-map-endpoint 0.0.0.0:9090
```

By default, the GRPC server operates on `0.0.0.0:8080`, and if activated, the Prometheus metrics endpoint uses `0.0.0.0:8002`.

### Step 3: Validating Prices

With the oracle sidecar running, you should observe successful price retrieval from the configured provider sources. To ensure everything is functioning correctly, you can run a test client script available in the Slinky repository using the following command:

```bash
make run-oracle-client
```

This script will help verify that the oracle is fetching and processing prices as expected.

### Step 4: Enable Oracle Vote Extension

To leverage the data collected by the Slinky Oracle in your Initia node, you need to enable the Oracle setting in the `config/app.toml` file. This configuration enables the node to connect to the oracle sidecar and utilize the price data.

Open `config/app.toml` and locate the Oracle settings section. Update it as follows:

```toml
###############################################################################
###                                  Oracle                                 ###
###############################################################################
[oracle]
# Enabled indicates whether the oracle is enabled.
enabled = "true"

# Oracle Address is the URL of the out of process oracle sidecar. This is used to
# connect to the oracle sidecar when the application boots up. Note that the address
# can be modified at any point, but will only take effect after the application is
# restarted. This can be the address of an oracle container running on the same
# machine or a remote machine.
oracle_address = "127.0.0.1:8080"

# Client Timeout is the time that the client is willing to wait for responses from 
# the oracle before timing out.
client_timeout = "500ms"

# MetricsEnabled determines whether oracle metrics are enabled. Specifically
# this enables instrumentation of the oracle client and the interaction between
# the oracle and the app.
metrics_enabled = "false"
```

This configuration enables the oracle feature and specifies the address of the oracle sidecar, ensuring your Initia node can properly retrieve and use the price data.
