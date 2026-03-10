# openclaw-deploy

Simple deployment scripts for running [OpenClaw](https://openclaw.ai) on a VPS.

Each person gets their own server. Tested on Ubuntu 22.04.

---

## Requirements

- Ubuntu 22.04 VPS (recommended: [Hetzner cx23](https://www.hetzner.com/cloud) — ~$4.21/mo)
- SSH access as root
- An API key for your preferred AI provider (OpenAI, Anthropic, etc.)

---

## Option 1 — Hetzner (cloud-init, fully automated)

1. Create a new server on [Hetzner Cloud](https://console.hetzner.cloud/)
2. Choose **Ubuntu 22.04**
3. In the **User data** field, paste the contents of [`hetzner/cloud-init.yaml`](hetzner/cloud-init.yaml)
4. Create the server and wait ~60 seconds for it to boot
5. SSH in:
   ```bash
   ssh root@YOUR_SERVER_IP
   ```
6. Run the OpenClaw setup wizard:
   ```bash
   cd /opt/openclaw
   OPENCLAW_IMAGE=ghcr.io/openclaw/openclaw:latest ./docker-setup.sh
   ```

---

## Option 2 — Any Ubuntu VPS (install script)

SSH into your server as root, then run:

```bash
curl -fsSL https://raw.githubusercontent.com/oops-lab-ai/openclaw-deploy/main/install.sh | sudo bash
```

This installs Docker, configures the firewall, and launches the OpenClaw setup wizard in one step.

---

## Accessing OpenClaw

OpenClaw runs on `localhost` inside the server. Access it from your machine via SSH tunnel:

```bash
ssh -L 3000:localhost:3000 root@YOUR_SERVER_IP
```

Then open [http://localhost:3000](http://localhost:3000) in your browser.

---

## What gets installed

| Component | Details |
|-----------|---------|
| Docker CE | Official Docker Engine + Compose v2 |
| UFW Firewall | Ports 22, 80, 443 open — everything else blocked |
| OpenClaw | Latest image from `ghcr.io/openclaw/openclaw:latest` |

---

## Tested on

- Hetzner cx23 (2 vCPU, 4GB RAM, Ubuntu 22.04)
- DigitalOcean Basic Droplet (2 vCPU, 4GB RAM, Ubuntu 22.04)
