# Citrea Node Installation Guide

![Full Node (1)](https://github.com/blackowltr/Testnetler-ve-Rehberler/assets/107190154/35ad5554-3919-4176-bf4d-b449f74cb3fc)

## Step 1: Install Docker

First, update your existing list of packages:

```bash
sudo apt update
```

Install Docker using the `docker.io` package:

```bash
sudo apt install docker.io
```

Start Docker:

```bash
sudo systemctl start docker
```

Enable Docker to start at boot:

```bash
sudo systemctl enable docker
```

Verify that Docker is installed correctly by running the hello-world image:

```bash
sudo docker run hello-world
```

## Step 2: Install Docker Compose

Download the current stable release of Docker Compose:

```bash
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
```

Apply executable permissions to the binary:

```bash
sudo chmod +x /usr/local/bin/docker-compose
```

Verify the installation:

```bash
docker-compose --version
```

## Step 3: Set Up Docker Compose for Citrea

1. Download the `docker-compose.yml` file from the Citrea repository:

   ```bash
   curl -O https://raw.githubusercontent.com/chainwayxyz/citrea/v0.4.0/docker-compose.yml
   ```

2. Optionally, set `ROLLUP__RUNNER__INCLUDE_TX_BODY` to `false` if soft batches are not needed. Open the `docker-compose.yml` file with a text editor:

   ```bash
   nano docker-compose.yml
   ```

   Find the line containing `ROLLUP__RUNNER__INCLUDE_TX_BODY` and set it to `false` if necessary.

### Step 4: Run Docker Compose

Run Docker Compose to start the Bitcoin Signet node and the Citrea full node:

```bash
docker-compose -f /root/docker-compose.yml up -d
```

This command uses the `-f` flag to specify the path to the `docker-compose.yml` file (`/root/docker-compose.yml`). It starts the necessary containers in detached mode (`-d`). After a minute, the node will begin syncing with the network.

```bash
docker-compose logs -f
```

To stop the containers, run:

```bash
docker-compose down
```

**Follow me on X here: https://x.com/brsbtc**
