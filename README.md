# openclaw-deploy

Simple deployment scripts for running [OpenClaw](https://openclaw.ai) on a VPS.

One server per person. Tested on Ubuntu 22.04.

---

## Requirements

- Ubuntu 22.04 VPS (recommended: [Hetzner cx23](https://www.hetzner.com/cloud) — ~$4.21/mo)

---

## Option 1 — Hetzner (cloud-init)

1. Create a new server on [Hetzner Cloud](https://console.hetzner.cloud/):
   - **OS:** Ubuntu 22.04
   - **User data:** paste the contents of [`hetzner/cloud-init.yaml`](hetzner/cloud-init.yaml)

2. Wait ~60 seconds for the server to boot and finish setup.

3. SSH in and run the OpenClaw setup wizard:
   ```bash
   ssh root@YOUR_SERVER_IP
   cd /opt/openclaw
   OPENCLAW_IMAGE=ghcr.io/openclaw/openclaw:latest ./docker-setup.sh
   ```

   The wizard will walk you through configuring your AI provider, channels (Discord, Telegram, etc.), and authentication.

---

## Option 2 — Any Ubuntu VPS

SSH in as root and run:

```bash
curl -fsSL https://raw.githubusercontent.com/oops-lab-ai/openclaw-deploy/main/install.sh | sudo bash
```

This installs Docker, configures the firewall, and drops you into the OpenClaw setup wizard.

---

## Accessing OpenClaw

OpenClaw binds to `localhost` by default. Access the web UI via SSH tunnel:

```bash
ssh -L 18789:localhost:18789 root@YOUR_SERVER_IP
```

Then open [http://localhost:18789](http://localhost:18789).

If you set up Discord or Telegram during the wizard, you can chat with your instance directly — no tunnel needed.

---

## What gets installed

| Component | Details |
|-----------|---------|
| Docker CE | Official Docker Engine + Compose v2 |
| UFW Firewall | Ports 22, 80, 443 open — everything else blocked |
| OpenClaw | `ghcr.io/openclaw/openclaw:latest` (pre-pulled) |
