#!/bin/bash
set -e

# 1. Update System & Install Git + Ansible
echo "--> Updating system and installing Git & Ansible..."
sudo pacman -Sy --noconfirm git ansible

# --- NEW STEP: Install Ansible Collections ---
echo "--> Installing Ansible Plugins (AUR support)..."
ansible-galaxy collection install community.general kewlfft.aur
# ---------------------------------------------

# 2. Clone the ANSIBLE Repo (Infrastructure)
ANSIBLE_REPO="https://github.com/ajcraig99/archlinux_ansible.git"
SETUP_DIR="$HOME/arch-setup"

if [ -d "$SETUP_DIR" ]; then
    echo "--> Directory exists. Pulling latest..."
    cd "$SETUP_DIR"
    git pull
else
    echo "--> Cloning Ansible setup..."
    git clone "$ANSIBLE_REPO" "$SETUP_DIR"
fi

# 3. Run the Playbook
echo "--> Running Ansible Playbook..."
cd "$SETUP_DIR"
ansible-playbook playbook.yml --ask-become-pass

echo "--> DONE! Reboot your computer."
