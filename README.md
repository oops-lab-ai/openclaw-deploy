# openclaw-deploy

Simple deployment scripts for running [OpenClaw](https://openclaw.ai) on a VPS.

One server per person. Tested on Ubuntu 22.04.

---

## Requirements

- Ubuntu 22.04 VPS (recommended: [Hetzner cx23](https://www.hetzner.com/cloud) — ~$4.21/mo)
- An OpenAI API key (from [platform.openai.com](https://platform.openai.com))
- (Optional) A Discord bot token if you want to chat via Discord

---

## Option 1 — Hetzner (fully automated, zero SSH)

1. Open [`hetzner/cloud-init.yaml`](hetzner/cloud-init.yaml) and fill in:
   - `YOUR_OPENAI_API_KEY` — your OpenAI API key
   - `YOUR_DISCORD_BOT_TOKEN` — your Discord bot token (or delete those lines)
   - `YOUR_DISCORD_USER_ID` — your Discord user ID (or delete those lines)

2. Create a new server on [Hetzner Cloud](https://console.hetzner.cloud/):
   - **OS:** Ubuntu 22.04
   - **User data:** paste your edited `cloud-init.yaml`

3. Wait ~60 seconds. OpenClaw is running.

To get your gateway token (for web UI access):
```bash
ssh root@YOUR_SERVER_IP cat /var/log/openclaw-setup.log
```

---

## Option 2 — Any Ubuntu VPS (install script)

SSH in as root and run:

```bash
curl -fsSL https://raw.githubusercontent.com/oops-lab-ai/openclaw-deploy/main/install.sh | sudo bash
```

The script installs Docker, configures the firewall, and launches the interactive OpenClaw setup wizard.

---

## Accessing OpenClaw

OpenClaw runs on `localhost` inside the server. Access the web UI via SSH tunnel:

```bash
ssh -L 18789:localhost:18789 root@YOUR_SERVER_IP
```

Then open [http://localhost:18789](http://localhost:18789) in your browser.

If you configured Discord, just message your bot directly — no SSH needed.

---

## What gets installed

| Component | Details |
|-----------|---------|
| Docker CE | Official Docker Engine + Compose v2 |
| UFW Firewall | Ports 22, 80, 443 open — everything else blocked |
| OpenClaw | Latest image: `ghcr.io/openclaw/openclaw:latest` |

---

## Tested on

- Hetzner cx23 (2 vCPU, 4GB RAM, Ubuntu 22.04)
- DigitalOcean Basic Droplet (2 vCPU, 4GB RAM, Ubuntu 22.04)
