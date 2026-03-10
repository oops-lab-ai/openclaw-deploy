#!/usr/bin/env bash
set -euo pipefail

# Must run as root
if [[ $EUID -ne 0 ]]; then
  echo "Please run as root: sudo bash install.sh"
  exit 1
fi

echo ""
echo "╔══════════════════════════════════╗"
echo "║       OpenClaw Installer         ║"
echo "╚══════════════════════════════════╝"
echo ""

# Update packages
echo "→ Updating packages..."
apt-get update -y -q
apt-get install -y -q curl git ufw

# Install Docker CE (official)
if ! command -v docker &>/dev/null; then
  echo "→ Installing Docker..."
  curl -fsSL https://get.docker.com -o /tmp/get-docker.sh
  sh /tmp/get-docker.sh -q
  systemctl enable docker
  systemctl start docker
else
  echo "→ Docker already installed, skipping."
fi

# Firewall
echo "→ Configuring firewall..."
ufw allow 22   > /dev/null
ufw allow 80   > /dev/null
ufw allow 443  > /dev/null
ufw --force enable > /dev/null

# Clone OpenClaw repo
if [[ ! -d /opt/openclaw ]]; then
  echo "→ Cloning OpenClaw..."
  git clone --depth=1 https://github.com/openclaw/openclaw /opt/openclaw -q
else
  echo "→ OpenClaw already present, pulling latest..."
  git -C /opt/openclaw pull -q
fi

cd /opt/openclaw

echo ""
echo "✓ Docker installed and running"
echo "✓ Firewall enabled (22, 80, 443)"
echo "✓ OpenClaw repo ready"
echo ""
echo "→ Starting OpenClaw setup wizard..."
echo ""

export OPENCLAW_IMAGE=ghcr.io/openclaw/openclaw:latest
./docker-setup.sh
