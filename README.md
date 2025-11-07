# Arch Linux i3 Setup - Ansible Playbook

Automated setup for Arch Linux with i3wm, including all packages, dotfiles, and system configuration.

## Structure
```
ansible-arch/
├── setup.yml              # Main playbook
├── aur-packages.yml       # AUR packages (run after main)
├── roles/
│   ├── packages/          # Package installation
│   └── dotfiles/          # Dotfiles deployment
│       ├── tasks/
│       └── files/
│           ├── config/    # ~/.config contents
│           ├── zshrc
│           └── p10k.zsh
├── fstab-nas.txt         # NAS mount configuration
└── README.md
```

## Quick Start

### On your main machine (first time setup):
```bash
# Already done if you're reading this!
cd ~/ansible-arch
git add .
git commit -m "Initial Arch i3 setup"
git remote add origin <your-git-url>
git push -u origin main
```

### On a fresh Arch installation:

1. **Install base tools:**
```bash
sudo pacman -S ansible git
```

2. **Clone this repo:**
```bash
git clone <your-repo-url> ~/ansible-arch
cd ~/ansible-arch
```

3. **Run the playbook:**
```bash
ansible-playbook setup.yml --ask-become-pass
```

4. **Install AUR packages:**
```bash
ansible-playbook aur-packages.yml
```

5. **Add NAS mounts (optional):**
```bash
sudo nano /etc/fstab
# Copy contents from fstab-nas.txt and update password
```

6. **Reboot:**
```bash
sudo reboot
```

## Testing in VM

Perfect for testing before committing to a real installation:
```bash
# In your VM after base Arch install:
sudo pacman -S ansible git
git clone <your-repo-url>
cd ansible-arch
ansible-playbook setup.yml --ask-become-pass
```

## Customization

- **Add packages:** Edit `roles/packages/tasks/main.yml`
- **Update dotfiles:** Edit files in `roles/dotfiles/files/`
- **Modify services:** Edit service list in `setup.yml` post_tasks
- **AUR packages:** Edit `aur-packages.yml`

## Notes

- Username is hardcoded as "arron" - change in `setup.yml` if needed
- NAS passwords in fstab are plaintext - consider using ansible-vault for production
- Some AUR packages may require manual intervention
- Dotfiles are copied, not symlinked (modify tasks if you want symlinks)

