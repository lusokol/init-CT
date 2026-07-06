#!/usr/bin/env bash
set -e

apt update
apt upgrade -y

apt install -y \
  sudo \
  git \
  curl \
  wget \
  vim \
  nano \
  zsh \
  ca-certificates \
  openssh-server

systemctl enable --now ssh

# Node.js + npm, nécessaire pour Claude Code
apt install -y nodejs npm

npm install -g @anthropic-ai/claude-code

echo "==> Installation de Tailscale"
curl -fsSL https://tailscale.com/install.sh | sh

read -p "Voulez-vous connecter cette machine à Tailscale maintenant ? (y/N) " answer

if [[ "$answer" =~ ^[Yy]$ ]]; then
    tailscale up
else
    echo "Vous pourrez lancer 'tailscale up' plus tard."
fi

# Oh My Zsh
export RUNZSH=no
export CHSH=no
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

chsh -s /bin/zsh root

apt autoremove -y
apt clean

zsh
echo "Bootstrap terminé."
